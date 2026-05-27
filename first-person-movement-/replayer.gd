extends Node
class_name  ReplayController
@export var recorded_objects : Array[Node3D]
@export var dummy_scene : PackedScene # Drag your saved Dummy scene here in the Inspector
@onready var delay: Timer = $Delay

# File path configuration
const SAVE_PATH : String = "user://temp_replay.json"

# Runtime tracking state
var frames : int = 0
var recording_data : Dictionary = {}
var recording : bool = false
var is_playing : bool = false
var current_dummy : Node3D = null

# --- STEP 1: RECORDING TIMELINE ---

func start_recording_session() -> void:
	if is_playing:
		print("Cannot record while a replay is playing!")
		return
	recording = true
	frames = 0
	recording_data = {} # Wipes the previous run out of RAM
	record_frame()

func record_frame() -> void:
	if not recording:
		delay.stop()
		return
		
	# Initialize the current frame index dictionary
	if not recording_data.has(frames):
		recording_data[frames] = {}
		
	# Capture the global positions/rotations of our VR components
	for ro in recorded_objects:
		recording_data[frames][ro.name] = {
			"position": ro.global_position,
			"rotation": ro.global_rotation
		}
	
	frames += 1
	delay.start()

func _on_delay_timeout() -> void:
	if recording:
		record_frame()

# --- STEP 2: SERIALIZATION & SAVING (LOCAL EXPORT) ---

func stop_and_save_session() -> void:
	if not recording:
		return
	recording = false
	delay.stop()
	
	save_telemetry_to_json()

func save_telemetry_to_json() -> void:
	print("Serializing RAM dictionary to JSON structure...")
	
	# 1. Build a clean, scalable envelope payload layout
	var file_payload : Dictionary = {
		"metadata": {
			"player_profile": "Hoc",
			"total_recorded_frames": frames,
			"engine_version": "Godot 4"
		},
		"frames": {}
	}
	
	# 2. Convert Godot Vector3 types into plain floating-point numbers
	for f in recording_data.keys():
		var frame_str = str(f)
		file_payload["frames"][frame_str] = {}
		
		for node_name in recording_data[f].keys():
			var pos: Vector3 = recording_data[f][node_name]["position"]
			var rot: Vector3 = recording_data[f][node_name]["rotation"]
			
			file_payload["frames"][frame_str][node_name] = {
				"position": {"x": pos.x, "y": pos.y, "z": pos.z},
				"rotation": {"x": rot.x, "y": rot.y, "z": rot.z}
			}
			
	# 3. Stringify the structured dictionary into raw plain text
	var json_string : String = JSON.stringify(file_payload, "\t") # Tab indents make it readable
	
	# 4. Use FileAccess to overwrite the target path
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		print(" Successfully exported data to local path: ", ProjectSettings.globalize_path(SAVE_PATH))
	else:
		push_error("OS Error: Failed to open save track destination path.")

# --- STEP 3: LOADING & DESERIALIZATION (LOCAL IMPORT) ---

func load_and_play_session() -> void:
	if is_playing or recording:
		return
		
	if not FileAccess.file_exists(SAVE_PATH):
		push_error("Playback failed: No replay file exists at storage directory.")
		return
		
	print("Reading file data from internal storage disk...")
	
	# 1. Pull down the raw file contents
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var raw_text : String = file.get_as_text()
	file.close()
	
	# 2. Parse the text back into an active memory dictionary
	var parsed_payload = JSON.parse_string(raw_text)
	if parsed_payload == null:
		push_error("Deserialization failed: The target file content layout is corrupted.")
		return
		
	var imported_frames_data: Dictionary = parsed_payload["frames"]
	var total_frames_to_play: int = int(parsed_payload["metadata"]["total_recorded_frames"])
	
	print("Loaded file successfully! Initializing playback sequence...")
	run_playback_loop(imported_frames_data, total_frames_to_play)

# --- STEP 4: RECONSTRUCTED PLAYBACK ---

func run_playback_loop(frames_data: Dictionary, total_frames: int) -> void:
	is_playing = true
	
	# Setup the virtual dummy instance clone
	if current_dummy != null:
		current_dummy.queue_free()
	current_dummy = dummy_scene.instantiate()
	get_tree().current_scene.add_child(current_dummy)
	
	# Playback sequence execution loop
	for f in total_frames:
		var frame_key : String = str(f) # Remember: JSON file keys are ALWAYS strings!
		
		# If this specific frame index isn't in the file data map, skip smoothly
		if not frames_data.has(frame_key):
			continue
			
		for node_name in frames_data[frame_key].keys():
			var dummy_part = current_dummy.get_node_or_null(node_name)
			
			if dummy_part != null:
				var target_raw = frames_data[frame_key][node_name]
				
				# Transform standard web data maps right back into Godot Vector3 types
				var target_pos = Vector3(target_raw["position"]["x"], target_raw["position"]["y"], target_raw["position"]["z"])
				var target_rot = Vector3(target_raw["rotation"]["x"], target_raw["rotation"]["y"], target_raw["rotation"]["z"])
				
				if f == 0:
					# Instantly snap dummy nodes to matching positions on frame 0
					dummy_part.global_position = target_pos
					dummy_part.global_rotation = target_rot
				else:
					# Smoothly interpolate positional changes across active intervals
					var tween = create_tween().set_parallel(true)
					tween.tween_property(dummy_part, "global_position", target_pos, 0.1)
					tween.tween_property(dummy_part, "global_rotation", target_rot, 0.1)
					
		# Await synchronization pacing delay signature
		await get_tree().create_timer(0.1).timeout
		
	print("--- PLAYBACK COMPLETED ---")
	is_playing = false
