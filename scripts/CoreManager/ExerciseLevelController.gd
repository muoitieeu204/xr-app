@tool
extends XRToolsSceneBase

@export_group("Level Tracking Variable")
@export var isLesson: bool = false
@export var levelId: int = 1
@export var taskList: Array[String] = []

@export_group("Level Tutorial Variable")
@export var waypointSequence: Array[Node3D]

@export_group("Exercise Specific Variables")
@export var item_slot_spawner: Array[Marker3D] = []
@export var item_catalog: Dictionary[String, PackedScene]
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

func _ready() -> void:
	if Engine.is_editor_hint():
		return
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
	
	# --- EXERCISE API LOGIC ---
	GetExerciseItemsApi.exercise_data_loaded.connect(_on_data_loaded)
	GetExerciseItemsApi.exercise_data_load_failed.connect(_on_data_failed)
	print("🔍 Requesting exercise data from API for level: ", levelId)
	
	# Fetch the API using the exported levelId!
	GetExerciseItemsApi.fetch_exercise_data(levelId)

# ----------------- EXERCISE API LOGIC -----------------
func _on_data_loaded(_data: Array) -> void:
	taskList.clear() # Clear any old data from the Godot Inspector
	for slot_info in ExerciseData.items:
		var slot_name: String = str(slot_info.get("slotName", ""))
		var raw_asset = slot_info.get("itemAsset")
		var asset_dict: Dictionary = raw_asset if raw_asset is Dictionary else {}
		var item_name: String = str(asset_dict.get("ItemName", ""))
		
		# --- DYNAMICALLY ADD TO TASK LIST ---
		if item_name != "":
			taskList.append(item_name)
		# ------------------------------------
		
		if item_catalog.has(item_name):
			var packed_scene: PackedScene = item_catalog[item_name]
			var spawn_marker = find_child(slot_name, true, false)
			if spawn_marker and spawn_marker.has_method("spawn_item"):
				spawn_marker.spawn_item(packed_scene)
	
	print("✅ Dynamic Task List Created: ", taskList)
	get_tree().call_group("TaskUI", "update_tasks", taskList, completedTask)

func _on_data_failed(error_msg: String) -> void:
	push_error("❌ API Fetch Failed: " + error_msg)

# ----------------- LEVEL TRACKING LOGIC -----------------
func CorrectAnswer(itemName: String) -> void:
	var seccondsPassed = currentTimeSecconds
	var logMessage = "[" + str(seccondsPassed) + "s] Correct Answer: " + itemName
	var is_scoring = taskList.has(itemName) and not attemptedItems.has(itemName)
	var earned_points: int = 0
	if is_scoring:
		for slot in ExerciseData.items:
			var asset = slot.get("itemAsset")
			if asset is Dictionary and asset.get("ItemName", "") == itemName:
				earned_points = slot.get("correctPoints", 0)
				break
		logMessage += " (+" + str(earned_points) + " điểm)"
	if interactionLog == "":
		interactionLog = logMessage
	else: interactionLog += " | " + logMessage
	ReplayManager.log_interaction("Correct Answer " + itemName)
	
	if is_scoring:
		attemptedItems.append(itemName) # Lock the score forever
		correctCount += 1
		currentScore += earned_points
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
	var earned_points: int = 0
	if is_scoring:
		for slot in ExerciseData.items:
			var asset = slot.get("itemAsset")
			if asset is Dictionary and asset.get("ItemName", "") == itemName:
				earned_points = slot.get("wrongPoints", 0)
				break
		logMessage += " (-" + str(earned_points) + " điểm)"
	if interactionLog == "":
		interactionLog = logMessage
	else: interactionLog += " | " + logMessage
	ReplayManager.log_interaction("Wrong Answer " + itemName)
	if is_scoring:
		attemptedItems.append(itemName) # Lock the score forever
		errorCount += 1
		currentScore = max(0, currentScore - earned_points)
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
			"lessonId": levelId,
			"isExercise": not isLesson,
			"score": currentScore,
			"errorCount": errorCount,
			"correctCount": correctCount,
			"startedAt": startedAt,
			"completedAt": Time.get_datetime_string_from_system(false) + tz_offset,
			"durationSeconds": currentTimeSecconds,
			"interactionLog": interactionLog,
			"feedbackText": ""
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
