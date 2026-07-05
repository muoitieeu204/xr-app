extends Node

@export var isLesson: bool = false
@export var levelId: int = 0

var currentScore: int = 0
var startedAt : String = ""
var interactionLog: String = ""

var startTick: int = 0

func _ready() -> void:
    startedAt = Time.get_datetime_string_from_system()
    startTick = Time.get_ticks_msec()

func CorrectAnswer(point : int) -> void:
    currentScore += point
    var seccondsPassed = (Time.get_ticks_msec() - startTick) /1000
    var logMessage = "[" + str(seccondsPassed) +"s] Correc Answer"
    if interactionLog == "":
        interactionLog = logMessage
    else: interactionLog += " | " + logMessage
    # ReplayManager.get_node("Replayer").log_event_to_replay("Correct Answer")
    ReplayManager.log_interaction("Correct Answer")
    print ("Score updated: ", currentScore)

func WrongAnswer(point : int) -> void:
    currentScore = max(0, currentScore - point)
    print("Score updated: ", currentScore)

func FinishLevel():
    var currentTick = Time.get_ticks_msec()
    var finalResult = {
            "sessionId": SessionData.sessionId,        # Assuming you have this Autoload                                                                                                                                         
            "childId": PlayerData.childId,            # Assuming you have this Autoload                                                                                                                                         
            "attemptNumber": 1,                                                                                                                                                                                                  
            "completionStatus": "Completed",                                                                                                                                                                                     
            "score": currentScore,                                                                                                                                                                                              
            "startedAt": startedAt,                                                                                                                                                                                              
            "completedAt": Time.get_datetime_string_from_system(),                                                                                                                                                               
            "durationSeconds": (currentTick - startTick)/1000,                                                                                                                                                                                                
            "interactionLog": interactionLog,                                                                                                                                                                                    
            "feedbackText": ""  
        }
    ResultApi.send_result(finalResult)