@tool
extends XRToolsSceneBase

@export var isLesson: bool = false
@export var levelId: int = 0
@export var taskList: Array[String] = []

var currentScore: int = 0
var startedAt: String = ""
var interactionLog: String = ""
var isLevelFinished: bool = false
var completedTask: Array[String] = []
var completionStatus = false
var correctCount: int = 0
var errorCount: int = 0

var currentTimeSecconds: int = 0
var lastEmittedTime: int = -1
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	SessionData.sessionId = str(ResourceUID.create_id())
	var levelTimer = Timer.new()
	levelTimer.wait_time = 1.0
	levelTimer.autostart = true
	levelTimer.timeout.connect(_on_timer_timeout)
	add_child(levelTimer)

	currentScore = 0
	interactionLog = ""
	startedAt = Time.get_datetime_string_from_system(true) + "Z"
	ReplayManager.start_recording()

func CorrectAnswer(point: int, itemName: String) -> void:
	if completedTask.has(itemName):
		return
	currentScore = min(100, currentScore + point)
	var seccondsPassed = currentTimeSecconds
	var logMessage = "[" + str(seccondsPassed) + "s] Correct Answer: " + itemName
	if interactionLog == "":
		interactionLog = logMessage
	else: interactionLog += " | " + logMessage
	ReplayManager.log_interaction("Correct Answer " + itemName)
	print("Score updated: ", currentScore)
	GameManager.score_updated.emit(currentScore)
	correctCount += 1
	markTaskComplete(itemName)

func WrongAnswer(point: int, itemName: String, spokenText: String) -> void:
	if completedTask.has(itemName):
		return
	currentScore = max(0, currentScore - point)
	var seccondsPassed = currentTimeSecconds
	var logMessage = "[" + str(seccondsPassed) + "s] Wrong Answer: từ đúng " + "'" + itemName + "'" + ", trẻ nói: " + "'" + spokenText + "'"
	if interactionLog == "":
		interactionLog = logMessage
	else: interactionLog += " | " + logMessage
	ReplayManager.log_interaction("Wrong Answer " + itemName)
	print("Score updated: ", currentScore)
	GameManager.score_updated.emit(currentScore)
	errorCount += 1

func FinishLevel():
	if isLevelFinished == true:
		return
	
	isLevelFinished = true
	var finalResult = {
			"sessionId": SessionData.sessionId, # Assuming you have this Autoload
			"childId": PlayerData.childId, # Assuming you have this Autoload
			"score": currentScore,
			"errorCount": errorCount,
			"correctCount": correctCount,
			"startedAt": startedAt,
			"completedAt": Time.get_datetime_string_from_system(true) + "Z",
			"durationSeconds": currentTimeSecconds,
			"interactionLog": interactionLog,
			"feedbackText": "" # Game can send data base on current logic
		}
	if isLesson == true:
		finalResult["lessonId"] = levelId
	else:
		finalResult["exerciseId"] = levelId # This need to be fix for the exercise
	if completionStatus == true:
		finalResult["completionStatus"] = "Completed"
	else:
		finalResult["completionStatus"] = "Incomplete"
	print("Sending result to server: ", JSON.stringify(finalResult))
	ResultApi.send_result(finalResult)
	ReplayManager.stop_recording()
	get_tree().call_group("MenuUI", "show_result", currentScore)
	get_tree().call_group("MenuViewport", "set_visible", true)

func markTaskComplete(taskName: String) -> void:
	if taskList.has(taskName) and not completedTask.has(taskName):
		completedTask.append(taskName)
		get_tree().call_group("TaskUI", "update_tasks", taskList, completedTask)
	if not taskList.is_empty() and completedTask.size() >= taskList.size():
		if not completionStatus:
			print("All tasks completed!")
			currentScore = min(100, currentScore + 20)
			GameManager.score_updated.emit(currentScore)
			completionStatus = true

func _on_timer_timeout() -> void:
	if isLevelFinished:
		return
	currentTimeSecconds += 1
	GameManager.time_updated.emit(currentTimeSecconds)
	if currentTimeSecconds > 0 and currentTimeSecconds % 300 == 0:
		var config = ConfigFile.new()
		var is_enabled = true
		if config.load("user://settings.cfg") == OK:
			is_enabled = config.get_value("Game", "HealthWarning", true)
		if is_enabled:
			GameManager.health_warning_triggered.emit()