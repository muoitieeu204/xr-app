@tool
extends XRToolsSceneBase

@export var isLesson: bool = false
@export var levelId: int = 0

var currentScore: int = 0
var startedAt: String = ""
var interactionLog: String = ""
var startTick: int = 0
var isLevelFinished: bool = false

func _ready() -> void:
	currentScore = 0
	interactionLog = ""
	startedAt = Time.get_datetime_string_from_system(true) + "Z"
	startTick = Time.get_ticks_msec()
	ReplayManager.start_recording()

func CorrectAnswer(point: int) -> void:
	currentScore += point
	var seccondsPassed = (Time.get_ticks_msec() - startTick) / 1000
	var logMessage = "[" + str(seccondsPassed) + "s] Correct Answer"
	if interactionLog == "":
		interactionLog = logMessage
	else: interactionLog += " | " + logMessage
	ReplayManager.log_interaction("Correct Answer")
	print("Score updated: ", currentScore)

func WrongAnswer(point: int) -> void:
	currentScore = max(0, currentScore - point)
	var seccondsPassed = (Time.get_ticks_msec() - startTick) / 1000
	var logMessage = "[" + str(seccondsPassed) + "s] Wrong Answer"
	if interactionLog == "":
		interactionLog = logMessage
	else: interactionLog += " | " + logMessage
	ReplayManager.log_interaction("Wrong Answer")
	print("Score updated: ", currentScore)

func FinishLevel():
	if isLevelFinished == true:
		return
	
	isLevelFinished = true
	var currentTick = Time.get_ticks_msec()
	var finalResult = {
			"sessionId": SessionData.sessionId, # Assuming you have this Autoload
			"childId": PlayerData.childId, # Assuming you have this Autoload
			"attemptNumber": 1,
			"completionStatus": "Completed",
			"score": currentScore,
			"startedAt": startedAt,
			"completedAt": Time.get_datetime_string_from_system(true)+"Z",
			"durationSeconds": (currentTick - startTick) / 1000,
			"interactionLog": interactionLog,
			"feedbackText": ""
		}
	if isLesson == true:
		finalResult["lessonId"] = levelId
	else: 
		finalResult["exeriseId"] = levelId #This need to be fix for the exercise 
	print("Sending result to server: ", JSON.stringify(finalResult))
	ResultApi.send_result(finalResult)
	ReplayManager.stop_recording()
