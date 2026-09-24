@tool
extends XRToolsSceneBase

@export_group("Level Tracking Variable")
@export var isLesson: bool = false
@export var levelId: int = 0
@export var taskList: Array[String] = []

#Item pointer is even num, CashRegister pointer is odd num
@export_group("Level Tutorial Variable")
@export var waypointSequence: Array[Node3D]

var maxScore: int = 60
var completionBonusPoints: int = 20
var correctAnswerScore: int = 20
var incorrectAnswerScore: int = 10
var currentScore: int = 0
var startedAt: String = ""
var interactionLog: String = ""
var isLevelFinished: bool = false
var completedTask: Array[String] = []
var attemptedItems: Array[String] = []
var completionStatus = false
var correctCount: int = 0
var errorCount: int = 0
var currentStepIndex: int = 0

var currentTimeSecconds: int = 0
var lastEmittedTime: int = -1

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for lesson in LessonData.response_data:
		if lesson.get("id") == levelId:
			maxScore = lesson.get("maxScore", 60)
			completionBonusPoints = lesson.get("completionBonusPoints", 20)
			correctAnswerScore = lesson.get("correctAnswerScore", 20)
			incorrectAnswerScore = lesson.get("incorrectAnswerScore", 10)
			print("✅ Loaded dynamic scores for level: ", levelId)
			break
			  
	SessionData.sessionId = str(ResourceUID.create_id())
	var levelTimer = Timer.new()
	levelTimer.wait_time = 1.0
	levelTimer.autostart = true
	levelTimer.timeout.connect(_on_timer_timeout)
	add_child(levelTimer)

	#Reset all state variable
	currentScore = 0
	interactionLog = ""
	isLevelFinished = false
	completedTask.clear()
	attemptedItems.clear()
	completionStatus = false
	correctCount = 0
	errorCount = 0
	currentTimeSecconds = 0
	
	var tz_offset = Time.get_offset_string_from_offset_minutes(Time.get_time_zone_from_system().bias)
	startedAt = Time.get_datetime_string_from_system(false) + tz_offset
	ReplayManager.start_recording()
	show_next_waypoint()

# ----------------- LEVEL TRACKING LOGIC -----------------
func CorrectAnswer(itemName: String) -> void:
	var seccondsPassed = currentTimeSecconds
	var logMessage = "[" + str(seccondsPassed) + "s] Correct Answer: " + itemName
	var is_scoring = taskList.has(itemName) and not attemptedItems.has(itemName)
	if is_scoring:
		logMessage += " (+" + str(correctAnswerScore) + " điểm)"
			
	if interactionLog == "":
		interactionLog = logMessage
	else: interactionLog += " | " + logMessage
	ReplayManager.log_interaction("Correct Answer " + itemName)
	
	if is_scoring:
		attemptedItems.append(itemName) # Lock the score forever
		correctCount += 1
		currentScore = min(maxScore, currentScore + correctAnswerScore)
		print("Score updated: ", currentScore)
		GameManager.score_updated.emit(currentScore)
		
	if not completedTask.has(itemName):
		markTaskComplete(itemName)
	else:
		print("Not in task list or already completed. Logged, but no score change!")

func WrongAnswer(itemName: String, spokenText: String) -> void:
	if spokenText == "[Không nghe rõ/ Im lặng]":
		return
	var seccondsPassed = currentTimeSecconds
	var logMessage = "[" + str(seccondsPassed) + "s] Wrong Answer: từ đúng " + "'" + itemName + "'" + ", trẻ nói: " + "'" + spokenText + "'"
	var is_scoring = taskList.has(itemName) and not attemptedItems.has(itemName)
	if is_scoring:
		logMessage += " (-" + str(incorrectAnswerScore) + " điểm)"
	if interactionLog == "":
		interactionLog = logMessage
	else: interactionLog += " | " + logMessage
	ReplayManager.log_interaction("Wrong Answer " + itemName)
	if taskList.has(itemName) and not attemptedItems.has(itemName):
		attemptedItems.append(itemName) # Lock the score forever
		errorCount += 1
		currentScore = max(0, currentScore - incorrectAnswerScore)
		print("Score updated: ", currentScore)
		GameManager.score_updated.emit(currentScore)
		
	if errorCount >= 10:
		skip_to_exit()

func FinishLevel():
	if isLevelFinished == true:
		return
	
	isLevelFinished = true
	var tz_offset = Time.get_offset_string_from_offset_minutes(Time.get_time_zone_from_system().bias)
	var finalResult = {
			"sessionId": SessionData.sessionId, # Assuming you have this Autoload
			"childId": PlayerData.childId, # Assuming you have this Autoload
			"lessonId": levelId,
			"isExercise": not isLesson,
			"score": currentScore,
			"errorCount": errorCount,
			"correctCount": correctCount,
			"startedAt": startedAt,
			"completedAt": Time.get_datetime_string_from_system(false) + tz_offset,
			"durationSeconds": currentTimeSecconds,
			"interactionLog": interactionLog,
			"feedbackText": "" # Game can send data base on current logic
		}
	if completionStatus == true:
		finalResult["completionStatus"] = "Completed"
	else:
		finalResult["completionStatus"] = "Incomplete"
	print("Sending result to server: ", JSON.stringify(finalResult))
	ResultApi.send_result(finalResult)
	ReplayManager.stop_recording()
	get_tree().call_group("MenuUI", "show_result", currentScore, currentTimeSecconds, correctCount, errorCount)
	get_tree().call_group("MenuViewport", "set_visible", true)

func markTaskComplete(taskName: String) -> void:
	if taskList.has(taskName) and not completedTask.has(taskName):
		completedTask.append(taskName)
		get_tree().call_group("TaskUI", "update_tasks", taskList, completedTask)
		advance_tutorial_step()
	if not taskList.is_empty() and completedTask.size() >= taskList.size():
		if not completionStatus:
			print("All tasks completed!")
			currentScore = min(100, currentScore + 20)
			GameManager.score_updated.emit(currentScore)
			completionStatus = true
			var logMessage = "[" + str(currentTimeSecconds) + "s] Điểm bonus hoàn thành nhiệm vụ: +20 điểm thưởng!"
			if interactionLog == "":
				interactionLog = logMessage
			else: interactionLog += " | " + logMessage

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
	if currentTimeSecconds == 900:
		skip_to_exit()

func show_next_waypoint() -> void:
	for point in waypointSequence:
		if is_instance_valid(point):
			point.hide()
			point.process_mode = Node.PROCESS_MODE_DISABLED
	if currentStepIndex < waypointSequence.size():
		var target = waypointSequence[currentStepIndex]
		if is_instance_valid(target):
			target.show()
			target.process_mode = Node.PROCESS_MODE_INHERIT

	
func advance_tutorial_step() -> void:
	currentStepIndex += 1
	show_next_waypoint()

func skip_to_exit() -> void:
	currentStepIndex = waypointSequence.size() - 1
	show_next_waypoint()
	print("Tutorial skipped! Guiding player to the exit")

func item_grabbed_for_tutorial() -> void:
	if currentStepIndex % 2 == 0 and currentStepIndex < waypointSequence.size() - 1:
		advance_tutorial_step()