@tool
extends XRToolsSceneBase

@export_group("Fish  Variables")
@export var catchable_items: Array[PackedScene]
@export var spawn_marker: Marker3D

@export_group("Level Tracking Variable")
@export var isLesson: bool = false
@export var levelId: int = 0
@export var taskList: Array[String] = []

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

	# Reset all state variables
	currentScore = 0
	interactionLog = ""
	isLevelFinished = false
	completedTask.clear()
	attemptedItems.clear()
	completionStatus = false
	correctCount = 0
	errorCount = 0
	currentTimeSecconds = 0
	currentStepIndex = 0
	
	var tz_offset = Time.get_offset_string_from_offset_minutes(Time.get_time_zone_from_system().bias)
	startedAt = Time.get_datetime_string_from_system(false) + tz_offset
	ReplayManager.start_recording()
	show_next_waypoint()

# ----------------- FISHING SPECIFIC LOGIC -----------------
func spawn_item(spawn_position: Vector3 = Vector3.ZERO):
	if catchable_items.is_empty():
		push_warning("No catchable items assigned in the FishinLevelController");
		return
	
	var available_items = []
	for scene in catchable_items:
		var temp_instance = scene.instantiate()
		var item_name = ""
		if temp_instance.has_meta("itemName"):
			item_name = temp_instance.get_meta("itemName")
		if item_name == "" or not completedTask.has(item_name):
			available_items.append(scene)
		temp_instance.queue_free()

	var random_item_scene = null
	if available_items.size() > 0:
		random_item_scene = available_items.pick_random()
	else:
		random_item_scene = catchable_items.pick_random()
	
	var item_instance = random_item_scene.instantiate()
	# get_tree().root.add_child(item_instance)
	add_child(item_instance)
	
	if spawn_marker:
		item_instance.global_position = spawn_marker.global_position
	else:
		item_instance.global_position = spawn_position
		
	print("Item spawned: ", item_instance.name)
	fishing_completed_for_tutorial()

# ----------------- LEVEL TRACKING LOGIC -----------------
func CorrectAnswer(itemName: String) -> void:
	var seccondsPassed = currentTimeSecconds
	var logMessage = "[" + str(seccondsPassed) + "s] Correct Answer: " + itemName
	if interactionLog == "":
		interactionLog = logMessage
	else: interactionLog += " | " + logMessage
	ReplayManager.log_interaction("Correct Answer " + itemName)
	
	if taskList.has(itemName) and not attemptedItems.has(itemName):
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
	var seccondsPassed = currentTimeSecconds
	var logMessage = "[" + str(seccondsPassed) + "s] Wrong Answer: từ đúng " + "'" + itemName + "'" + ", trẻ nói: " + "'" + spokenText + "'"
	if interactionLog == "":
		interactionLog = logMessage
	else: interactionLog += " | " + logMessage
	ReplayManager.log_interaction("Wrong Answer " + itemName)
	
	if spokenText == "[Không nghe rõ/ Im lặng]":
		return
		
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
			"sessionId": SessionData.sessionId,
			"childId": PlayerData.childId,
			"score": currentScore,
			"errorCount": errorCount,
			"correctCount": correctCount,
			"startedAt": startedAt,
			"completedAt": Time.get_datetime_string_from_system(false) + tz_offset,
			"durationSeconds": currentTimeSecconds,
			"interactionLog": interactionLog,
			"feedbackText": ""
		}
	if isLesson == true:
		finalResult["lessonId"] = levelId
	else:
		finalResult["exerciseId"] = levelId
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
			var logMsg = "[" + str(currentTimeSecconds) + "s] Hoàn thành tất cả nhiệm vụ: +20 Điểm thưởng!"
			if interactionLog == "": interactionLog = logMsg
			else: interactionLog += " | " + logMsg

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

# ----------------- LEVEL TUTORIAL LOGIC -----------------
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
	# Advance if we are at Step 0 (Grab Rod) or Step 2, 5, 8... (Grab Fish from Table)
	if currentStepIndex == 0 or (currentStepIndex >= 2 and (currentStepIndex - 2) % 3 == 0):
		if currentStepIndex < waypointSequence.size() - 1:
			advance_tutorial_step()

func fishing_completed_for_tutorial() -> void:
	# Advance if we are at Step 1, 4, 7... (Fishing Point)
	if currentStepIndex >= 1 and (currentStepIndex - 1) % 3 == 0:
		if currentStepIndex < waypointSequence.size() - 1:
			advance_tutorial_step()
