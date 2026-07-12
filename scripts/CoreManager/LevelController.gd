@tool
extends XRToolsSceneBase

@export var isLesson: bool = false
@export var levelId: int = 0
@export var taskList : Array[String] = []

var currentScore: int = 0
var startedAt: String = ""
var interactionLog: String = ""
var startTick: int = 0
var isLevelFinished: bool = false
var completedTask : Array[String] = []

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	currentScore = 0
	interactionLog = ""
	startedAt = Time.get_datetime_string_from_system(true) + "Z"
	startTick = Time.get_ticks_msec()
	ReplayManager.start_recording()

func CorrectAnswer(point: int, itemName: String) -> void:
	if completedTask.has(itemName):
		return
	currentScore = min(100,currentScore + point)
	var seccondsPassed = (Time.get_ticks_msec() - startTick) / 1000
	var logMessage = "[" + str(seccondsPassed) + "s] Correct Answer"
	if interactionLog == "":
		interactionLog = logMessage
	else: interactionLog += " | " + logMessage
	ReplayManager.log_interaction("Correct Answer" + itemName)
	print("Score updated: ", currentScore)
	markTaskComplete(itemName)

func WrongAnswer(point: int, itemName: String) -> void:
	if completedTask.has(itemName):
		return
	currentScore = max(0, currentScore - point)
	var seccondsPassed = (Time.get_ticks_msec() - startTick) / 1000
	var logMessage = "[" + str(seccondsPassed) + "s] Wrong Answer"
	if interactionLog == "":
		interactionLog = logMessage
	else: interactionLog += " | " + logMessage
	ReplayManager.log_interaction("Wrong Answer" + itemName)
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
	get_tree().call_group("MenuUI", "show_result",currentScore)
	get_tree().call_group("MenuViewport", "set_visible", true)

func markTaskComplete(taskName: String) -> void:
	if taskList.has(taskName) and not completedTask.has(taskName):
		completedTask.append(taskName)
		get_tree().call_group("TaskUI", "update_tasks", taskList,completedTask)
	if completedTask.size() == taskList.size():
		print("All tasks completed!") 
		currentScore = min(100, currentScore + 20)