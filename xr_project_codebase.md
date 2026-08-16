# XR-App Project Source Code


## File: GodotXR _Attempt_1.csproj

``xml
<Project Sdk="Godot.NET.Sdk/4.5.1">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <TargetFramework Condition=" '$(GodotTargetPlatform)' == 'android' ">net9.0</TargetFramework>
    <EnableDynamicLoading>true</EnableDynamicLoading>
    <RootNamespace>GodotXR_Attempt_1</RootNamespace>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Google.Protobuf" Version="3.33.2" />
    <PackageReference Include="Grpc.Net.Client" Version="2.76.0" />
    <PackageReference Include="Grpc.Tools" Version="2.76.0">
      <PrivateAssets>all</PrivateAssets>
      <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
    </PackageReference>
    <PackageReference Include="Vosk" Version="0.3.38" />
    <PackageReference Include="Microsoft.CognitiveServices.Speech" Version="1.50.0" />
    <Compile Remove="android\**" />
    <Content Remove="android\**" />
  </ItemGroup>
</Project>
``


## File: GodotXR _Attempt_1.sln

``text
Microsoft Visual Studio Solution File, Format Version 12.00
# Visual Studio 2012
Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "GodotXR _Attempt_1", "GodotXR _Attempt_1.csproj", "{BD4B85F6-209F-443D-916F-CA2144F4E478}"
EndProject
Global
	GlobalSection(SolutionConfigurationPlatforms) = preSolution
	Debug|Any CPU = Debug|Any CPU
	ExportDebug|Any CPU = ExportDebug|Any CPU
	ExportRelease|Any CPU = ExportRelease|Any CPU
	EndGlobalSection
	GlobalSection(ProjectConfigurationPlatforms) = postSolution
		{BD4B85F6-209F-443D-916F-CA2144F4E478}.Debug|Any CPU.ActiveCfg = Debug|Any CPU
		{BD4B85F6-209F-443D-916F-CA2144F4E478}.Debug|Any CPU.Build.0 = Debug|Any CPU
		{BD4B85F6-209F-443D-916F-CA2144F4E478}.ExportDebug|Any CPU.ActiveCfg = ExportDebug|Any CPU
		{BD4B85F6-209F-443D-916F-CA2144F4E478}.ExportDebug|Any CPU.Build.0 = ExportDebug|Any CPU
		{BD4B85F6-209F-443D-916F-CA2144F4E478}.ExportRelease|Any CPU.ActiveCfg = ExportRelease|Any CPU
		{BD4B85F6-209F-443D-916F-CA2144F4E478}.ExportRelease|Any CPU.Build.0 = ExportRelease|Any CPU
	EndGlobalSection
EndGlobal

``


## File: project.godot

``ini
; Engine configuration file.
; It's best edited using the editor UI and not directly,
; since the parameters that go here are not all obvious.
;
; Format:
;   [section] ; section goes between []
;   param=value ; assign values to parameters

config_version=5

[application]

config/name="GodotXR"
run/main_scene="uid://dacrvo5efu5py"
config/features=PackedStringArray("4.5", "C#", "Forward Plus")
run/max_fps=90
config/icon="res://icon.svg"

[audio]

buses/default_bus_layout="uid://dpr132vrqgah0"
driver/enable_input=true
driver/mix_rate=16000
input/transcribe/use_gpu=true

[autoload]

XRToolsUserSettings="*res://addons/godot-xr-tools/user_settings/user_settings.gd"
XRToolsRumbleManager="*res://addons/godot-xr-tools/rumble/rumble_manager.gd"
SessionData="*res://scripts/SessionData.gd"
SessionUploader="*res://scripts/SessionUploader.cs"
AzureSpeechManager="*res://scripts/AzureSpeechManager.cs"
GameManager="*res://scripts/GameManager.gd"
PlayerData="*res://Prefabs/PlayerPrefabs/PlayerData.gd"
RefreshTokenApi="*res://scripts/RefreshTokenApi.gd"

[dotnet]

project/assembly_name="GodotXR _Attempt_1"

[editor_plugins]

enabled=PackedStringArray("res://addons/godot-xr-tools/plugin.cfg")

[global_group]

interactable="Interactable Object"
VoiceLines=""

[godot_xr_tools]

player/standard_height=1.7

[input]

forward={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":87,"key_label":0,"unicode":119,"location":0,"echo":false,"script":null)
]
}
backward={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":83,"key_label":0,"unicode":115,"location":0,"echo":false,"script":null)
]
}
left={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":65,"key_label":0,"unicode":97,"location":0,"echo":false,"script":null)
]
}
right={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":68,"key_label":0,"unicode":100,"location":0,"echo":false,"script":null)
]
}
play={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":80,"key_label":0,"unicode":112,"location":0,"echo":false,"script":null)
]
}
record={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":82,"key_label":0,"unicode":114,"location":0,"echo":false,"script":null)
]
}
stop={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":0,"physical_keycode":81,"key_label":0,"unicode":113,"location":0,"echo":false,"script":null)
]
}

[layer_names]

3d_physics/layer_1="Static World"
3d_physics/layer_2="Dynamic World"
3d_physics/layer_3="Pickable Objects"
3d_physics/layer_4="Wall Walking"
3d_physics/layer_5="Grappling Target"
3d_physics/layer_17="Held Objects"
3d_physics/layer_18="Player Hands"
3d_physics/layer_19="Grab Handles"
3d_physics/layer_20="Player Body"
3d_physics/layer_21="Pointable Objects"
3d_physics/layer_22="Hand Pose Areas"
3d_physics/layer_23="UI Objects"

[physics]

common/physics_ticks_per_second=90

[rendering]

renderer/rendering_method="gl_compatibility"
textures/vram_compression/import_etc2_astc=true
anti_aliasing/quality/msaa_3d=1

[xr]

openxr/enabled=true
openxr/reference_space=1
openxr/foveation_level=1
shaders/enabled=true

``


## File: first-person-movement-/3d_level.gd

``gdscript
extends Node3D
@onready var replayer: Node = $Replayer

func _input(event):
	if event.is_action_pressed("record"):
		print("Start recording")
		replayer.recording = true
		replayer.record()
	
	if event.is_action_pressed("stop"):
		print("Stop recording")
		replayer.recording = false
		replayer.record()
		
	if event.is_action_pressed("play"):
		print("Playing back animation...")
		replayer.play()

``


## File: first-person-movement-/player.gd

``gdscript
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D

var has_control := true
func _unhandled_input(event: InputEvent) -> void:
	if not has_control : return
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode()== Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	if not has_control : return	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func set_control(state: bool):
	has_control = state

``


## File: first-person-movement-/replayer.gd

``gdscript
extends Node
class_name ReplayerFpv
@export var recorded_objects: Array[Node3D]
@export var dummy_scene: PackedScene # Drag your saved Dummy scene here in the Inspector
@onready var delay: Timer = $Delay

# File path configuration
var SAVE_PATH: String = "user://replay.json"

# Runtime tracking state
var frames: int = 0
var recording_data: Dictionary = {}
var recording: bool = false
var is_playing: bool = false
var current_dummy: Node3D = null
var linked_audio_filename: String = ""
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
	var file_payload: Dictionary = {
		"metadata": {
			"player_profile": "Hoc",
			"total_recorded_frames": frames,
			"engine_version": "Godot 4",
			"audio_file": linked_audio_filename,
			"world_path": get_tree().current_scene.scene_file_path
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
	var json_string: String = JSON.stringify(file_payload, "\t") # Tab indents make it readable
	
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
	var raw_text: String = file.get_as_text()
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
		var frame_key: String = str(f) # Remember: JSON file keys are ALWAYS strings!
		
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

``


## File: Prefabs/Boards/AzureSpeechChecker.gd

``gdscript
extends Node

@export var recordButton : Button
@export var outputLabel : Label

var speechManager : Node
var assignWord: String = ""
func _ready() -> void:
	speechManager = get_node_or_null("/root/AzureSpeechManager")
	if(speechManager == null):
		printerr("Node not found, make sure to assign it!!")
		return
	

	recordButton.focus_mode = Control.FOCUS_NONE
	
	if not recordButton.pressed.is_connected(_on_button_pressed):
		recordButton.pressed.connect(_on_button_pressed)
	
	if speechManager:
		speechManager.connect("OnSpeechRecognized", Callable(self, "_on_speech_recognized"))
		speechManager.connect("OnSpeechFailed", Callable(self, "_on_speech_failed"))
	else:
		printerr("ERROR: AzureSpeechManager signal not found!")

func _on_button_pressed() -> void:
	outputLabel.text = "Status: Listening"
	recordButton.disabled = true;
	speechManager.StartListening()

func _on_speech_recognized(text: String) -> void:
	recordButton.disabled = false
	recordButton.text = "Press to Speak"
	var resultWord = text.to_lower()
	var targetWord = assignWord.to_lower()
	if resultWord.contains(targetWord):
		outputLabel.text = "Correct! You said: " + text
		recordButton.text = "Correct"
		recordButton.modulate = Color.GREEN
	else:
		outputLabel.text = "Wrong! You said: " + text
		recordButton.modulate = Color.RED

func _on_speech_failed(reason:String) -> void:
	recordButton.disabled = false
	recordButton.text = "Press to Speak"
	outputLabel.text = "Cannot hear you clearly, please try again!"
	outputLabel.modulate = Color.YELLOW 
	recordButton.modulate = Color.YELLOW
``


## File: Prefabs/Boards/UIController.gd

``gdscript
extends Control

@onready var titleLabel : Label = $MarginContainer/VBoxContainer/Label2
@export var titleLabelText : String = "Please say: "
@export var targetWord : String = "":
	set(value):
		targetWord = value
		# When the Viewport pushes the new word, update the label immediately!
		if is_inside_tree() and titleLabel != null:
			titleLabel.text = titleLabelText

# This grabs the node with the AzureSpeechChecker.gd script
@onready var speechChecker = %CheckerBoardController

func _ready() -> void:
	if titleLabel == null:
		printerr("ERROR: titleLabel is empty! Please assign it in the Inspector on the right.")
		
	# 1. Update the label just in case
	if titleLabel != null:
		titleLabel.text = titleLabelText
		
	# 2. Safety check to make sure the Checker node exists
	if speechChecker == null:
		printerr("ERROR: Could not find %CheckerBoardController! Did you set it as a Unique Node?")
		return
		
	# 3. PASS the word to the checker!
	speechChecker.assignWord = targetWord

``


## File: Prefabs/Guide Sound/LabelAudioTrigger.gd

``gdscript
extends Label3D

@export var audioFile : AudioStreamPlayer3D



func _on_area_3d_body_entered(_body: Node3D) -> void:
	# 1. Stop all other voice lines
	get_tree().call_group("VoiceLines", "stop")
	
	# 2. Play this new speaker
	if audioFile != null:
		audioFile.play()
	else:
		$AudioStreamPlayer3D.play()
	

``


## File: Prefabs/PlayerPrefabs/PlayerData.gd

``gdscript
extends Node

# Active Child Profile Data
var child_id: int = 0
var parent_user_id: int = 0
var full_name: String = ""
var age: int = 0
var gender: String = ""
var learning_level: String = ""
var status: String = ""

func clear():
	child_id = 0
	parent_user_id = 0
	full_name = ""
	age = 0
	gender = ""
	learning_level = ""
	status = ""

``


## File: Prefabs/Shader/teleport_area_shader.gdshader

``glsl
shader_type spatial;

// unshaded makes it glow in VR. cull_disabled lets you see it from the inside out.
render_mode unshaded, cull_disabled, blend_mix;

// These will appear in your Inspector so you can easily change colors without touching code
uniform vec4 hologram_color : source_color = vec4(0.0, 0.4, 1.0, 0.3);
uniform vec4 scanline_color : source_color = vec4(0.5, 0.9, 1.0, 1.0);
uniform float scan_speed = 0.5;

void fragment() {
    // 1. Soft Edges: Fades the cylinder out at the very top and bottom so it blends into the world
    float edge_fade = smoothstep(0.0, 0.1, UV.y) * smoothstep(1.0, 0.9, UV.y);

    // 2. The Engine: fract(TIME) makes a value smoothly loop between 0.0 and 1.0 endlessly
    float scan_position = fract(TIME * scan_speed);

    // Calculate how far the current pixel is from the moving scan position
    float distance_to_scan = abs(UV.y - scan_position);

    // 3. The Laser: Creates a bright line that is thickest in the middle and soft on the edges
    float scanline = smoothstep(0.08, 0.0, distance_to_scan);

    // Combine everything together
    vec3 final_albedo = mix(hologram_color.rgb, scanline_color.rgb, scanline);
    float final_alpha = max(hologram_color.a, scanline) * edge_fade;

    ALBEDO = final_albedo;
    ALPHA = final_alpha;
}
``


## File: Prefabs/UI/childprofile-my-child-api.gd

``gdscript
extends Control

var apiUrl: String = "https://103-162-31-23.sslip.io/api/child-profiles/my-children"

@export var welcome_scene_path: NodePath = ^"../WelcomeScene"

@onready var httpRequest: HTTPRequest = $HTTPRequest
@onready var profilesContainer: GridContainer = $ProfileBox/VBoxContainer/ScrollContainer/ProfilesGrid
@onready var loadingLabel: Label = $ProfileBox/VBoxContainer/LoadingLabel
@onready var templateButton: Button = $ProfileBox/VBoxContainer/ScrollContainer/ProfilesGrid/TemplateButton
@onready var welcomeScene: Control = get_node_or_null(welcome_scene_path)

var children_data: Array = []

func _ready() -> void:
	templateButton.visible = false
	loadingLabel.visible = true
	loadingLabel.text = "Dang tai danh sach..."

	httpRequest.request_completed.connect(_on_request_completed)
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed() -> void:
	if visible:
		for child in profilesContainer.get_children():
			if child != templateButton:
				child.queue_free()

		loadingLabel.visible = true
		loadingLabel.text = "Dang tai danh sach..."
		fetch_child_profiles()

func fetch_child_profiles() -> void:
	var headers := [
		"Authorization: Bearer " + SessionData.accessToken,
		"accept: application/json"
	]

	httpRequest.set_tls_options(TLSOptions.client_unsafe())
	httpRequest.request(apiUrl, headers, HTTPClient.METHOD_GET)

func _on_request_completed(result: int, responseCode: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		loadingLabel.text = "Loi ket noi may chu!"
		return

	if responseCode != 200:
		loadingLabel.text = "Loi xac thuc (Ma " + str(responseCode) + ")"
		return

	var json = JSON.parse_string(body.get_string_from_utf8())

	if json != null and json.has("success") and json["success"] == true:
		loadingLabel.visible = false
		children_data = json["data"]

		for child in children_data:
			var btn: Button = templateButton.duplicate()
			btn.visible = true
			btn.text = str(child.get("fullName", "")) + "\n(" + str(child.get("age", "")) + " tuoi)"
			btn.pressed.connect(_on_profile_selected.bind(child))
			btn.mouse_entered.connect(_on_btn_hover.bind(btn))
			btn.mouse_exited.connect(_on_btn_unhover.bind(btn))
			profilesContainer.add_child(btn)
	else:
		loadingLabel.text = "Khong tim thay ho so nao!"

func _on_profile_selected(child_data: Dictionary) -> void:
	PlayerData.child_id = int(child_data.get("id", 0))
	PlayerData.parent_user_id = int(child_data.get("userId", 0))
	PlayerData.full_name = str(child_data.get("fullName", ""))
	PlayerData.age = int(child_data.get("age", 0))
	PlayerData.gender = str(child_data.get("gender", ""))
	PlayerData.learning_level = str(child_data.get("learningLevel", ""))
	PlayerData.status = str(child_data.get("status", ""))

	if welcomeScene == null:
		push_error("WelcomeScene not found at path: " + str(welcome_scene_path))
		return

	visible = false
	welcomeScene.visible = true

func _on_btn_hover(btn: Button) -> void:
	btn.pivot_offset = btn.size / 2
	var tween := create_tween()
	tween.tween_property(btn, "scale", Vector2(1.05, 1.05), 0.15)

func _on_btn_unhover(btn: Button) -> void:
	var tween := create_tween()
	tween.tween_property(btn, "scale", Vector2.ONE, 0.15)
``


## File: Prefabs/UI/WelcomeScene.gd

``gdscript
extends Control

@onready var welcomeLabel: Label = $WelcomeBox/VBoxContainer/Label2
@onready var joinButton: Button = $WelcomeBox/VBoxContainer/Button

func _ready() -> void:
	visibility_changed.connect(Callable(self, "_on_visibility_changed"))
	joinButton.pressed.connect(Callable(self, "_on_join_button_pressed"))

	if visible:
		_update_welcome_label()

func _on_visibility_changed() -> void:
	if visible:
		_update_welcome_label()

func _update_welcome_label() -> void:
	var child_name := PlayerData.full_name.strip_edges()

	if child_name.is_empty():
		welcomeLabel.text = "Hello!"
	else:
		welcomeLabel.text = "Hello " + child_name + "!"

func _on_join_button_pressed() -> void:
	GameManager.profile_selected.emit()
``


## File: Scenes/CyberLoadingSpace.gdshader

``glsl
shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}

``


## File: Scenes/import_session.gd

``gdscript
extends CanvasLayer

class_name ImportSessionManager

@onready var replay_dialog: FileDialog = $Control/ReplayDialog
@onready var replay_button: Button = $Control/BoxContainer/SelectReplay
@onready var accept_dialog: AcceptDialog = $Control/AcceptDialog


func _on_select_replay_pressed() -> void:
	replay_dialog.popup_centered(Vector2(800,600))

func _on_start_spectator_pressed() -> void:
	if SessionData.target_replay_path != "" and SessionData.target_audio_path != "" and SessionData.target_scene_path != "" :
		SessionData.is_spectator = true
		#Load the world from json file
		get_tree().change_scene_to_file(SessionData.target_scene_path)
		print("Successfully loading world: ", SessionData.target_scene_path)
	else:
		print("Select both files first!")
		accept_dialog.popup_centered()

func _on_replay_dialog_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()
	if parsed == null or not parsed.has("metadata"):
		accept_dialog.dialog_text = "Invalid file! This is not a replay JSON file"
		accept_dialog.popup_centered()
		return
	
	var targetAudioName = parsed["metadata"]["audio_file"]
	if parsed["metadata"].has("world_path"):
		SessionData.target_scene_path = parsed["metadata"]["world_path"]
	else:
		accept_dialog.dialog_text = "Invalid file! This JSON file do not contain world_path"
	var baseFolder = path.get_base_dir()
	var audioPath = baseFolder + "/" + targetAudioName
	if FileAccess.file_exists(audioPath):
		SessionData.target_replay_path = path
		SessionData.target_audio_path = audioPath
		replay_button.text = "Replay: " + path.get_file()
		print("Successfully link metadata audio: ", targetAudioName)
	else:
		SessionData.target_replay_path = ""
		SessionData.target_audio_path = ""
		
		accept_dialog.dialog_text = "Missing Audio! The metadata requires " + targetAudioName + "', but it is missing from the folder."
		accept_dialog.popup_centered()
		

``


## File: Scenes/LoginSceneManager.gd

``gdscript
extends Node3D

func _ready():
        # 1. We must wait 1 second for the headset to finish booting up and tracking
        await get_tree().create_timer(1.0).timeout
        
        # 2. Force the VR camera to perfectly align with the XROrigin3D
        # 'true' means it will keep the player's physical height (so sitting feels correct)
        XRServer.center_on_hmd(XRServer.RESET_BUT_KEEP_TILT, true)

``


## File: Scenes/spawner.gd

``gdscript
extends Node3D

@export var spawn_object: Array[PackedScene]
@export var spawn_pos : Array[Vector3]
# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn()

func _spawn():
	for i in range(spawn_object.size()):
		var obj = spawn_object[i]
		var spawn = obj.instantiate() as Node3D
		add_child(spawn)
		if i < spawn_pos.size():
			spawn.position= spawn_pos[i]
		else :
			spawn.position = Vector3(i * 2.0, 0 , 0)
			

``


## File: Scenes/water_shader.gdshader

``glsl
// Wind Waker style water - NekotoArts
// Adapted from https://www.shadertoy.com/view/3tKBDz
// After which I added in some fractal Brownian motion
// as well as vertex displacement

shader_type spatial;

uniform vec4 WATER_COL : source_color =  vec4(0.04, 0.38, 0.88, 1.0);
uniform vec4 WATER2_COL : source_color =  vec4(0.04, 0.35, 0.78, 1.0);
uniform vec4 FOAM_COL : source_color = vec4(0.8125, 0.9609, 0.9648, 1.0);
uniform float distortion_speed = 2.0;
uniform vec2 tile = vec2(5.0, 5.0);
uniform float height = 2.0;
uniform vec2 wave_size = vec2(2.0, 2.0);
uniform float wave_speed = 1.5;

const float M_2PI = 6.283185307;
const float M_6PI = 18.84955592;

float random(vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) *
            43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    // Four corners in 2D of a tile
    float a = random(uv_index);
    float b = random(uv_index + vec2(1.0, 0.0));
    float c = random(uv_index + vec2(0.0, 1.0));
    float d = random(uv_index + vec2(1.0, 1.0));

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix(a, b, blur.x) +
            (c - a) * blur.y * (1.0 - blur.x) +
            (d - b) * blur.x * blur.y;
}

float fbm(vec2 uv) {
    int octaves = 6;
    float amplitude = 0.5;
    float frequency = 3.0;
	float value = 0.0;

    for(int i = 0; i < octaves; i++) {
        value += amplitude * noise(frequency * uv);
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return value;
}

float circ(vec2 pos, vec2 c, float s)
{
    c = abs(pos - c);
    c = min(c, 1.0 - c);

    return smoothstep(0.0, 0.002, sqrt(s) - sqrt(dot(c, c))) * -1.0;
}

// Foam pattern for the water constructed out of a series of circles
float waterlayer(vec2 uv)
{
    uv = mod(uv, 1.0); // Clamp to [0..1]

    float ret = 1.0;
    ret += circ(uv, vec2(0.37378, 0.277169), 0.0268181);
    ret += circ(uv, vec2(0.0317477, 0.540372), 0.0193742);
    ret += circ(uv, vec2(0.430044, 0.882218), 0.0232337);
    ret += circ(uv, vec2(0.641033, 0.695106), 0.0117864);
    ret += circ(uv, vec2(0.0146398, 0.0791346), 0.0299458);
    ret += circ(uv, vec2(0.43871, 0.394445), 0.0289087);
    ret += circ(uv, vec2(0.909446, 0.878141), 0.028466);
    ret += circ(uv, vec2(0.310149, 0.686637), 0.0128496);
    ret += circ(uv, vec2(0.928617, 0.195986), 0.0152041);
    ret += circ(uv, vec2(0.0438506, 0.868153), 0.0268601);
    ret += circ(uv, vec2(0.308619, 0.194937), 0.00806102);
    ret += circ(uv, vec2(0.349922, 0.449714), 0.00928667);
    ret += circ(uv, vec2(0.0449556, 0.953415), 0.023126);
    ret += circ(uv, vec2(0.117761, 0.503309), 0.0151272);
    ret += circ(uv, vec2(0.563517, 0.244991), 0.0292322);
    ret += circ(uv, vec2(0.566936, 0.954457), 0.00981141);
    ret += circ(uv, vec2(0.0489944, 0.200931), 0.0178746);
    ret += circ(uv, vec2(0.569297, 0.624893), 0.0132408);
    ret += circ(uv, vec2(0.298347, 0.710972), 0.0114426);
    ret += circ(uv, vec2(0.878141, 0.771279), 0.00322719);
    ret += circ(uv, vec2(0.150995, 0.376221), 0.00216157);
    ret += circ(uv, vec2(0.119673, 0.541984), 0.0124621);
    ret += circ(uv, vec2(0.629598, 0.295629), 0.0198736);
    ret += circ(uv, vec2(0.334357, 0.266278), 0.0187145);
    ret += circ(uv, vec2(0.918044, 0.968163), 0.0182928);
    ret += circ(uv, vec2(0.965445, 0.505026), 0.006348);
    ret += circ(uv, vec2(0.514847, 0.865444), 0.00623523);
    ret += circ(uv, vec2(0.710575, 0.0415131), 0.00322689);
    ret += circ(uv, vec2(0.71403, 0.576945), 0.0215641);
    ret += circ(uv, vec2(0.748873, 0.413325), 0.0110795);
    ret += circ(uv, vec2(0.0623365, 0.896713), 0.0236203);
    ret += circ(uv, vec2(0.980482, 0.473849), 0.00573439);
    ret += circ(uv, vec2(0.647463, 0.654349), 0.0188713);
    ret += circ(uv, vec2(0.651406, 0.981297), 0.00710875);
    ret += circ(uv, vec2(0.428928, 0.382426), 0.0298806);
    ret += circ(uv, vec2(0.811545, 0.62568), 0.00265539);
    ret += circ(uv, vec2(0.400787, 0.74162), 0.00486609);
    ret += circ(uv, vec2(0.331283, 0.418536), 0.00598028);
    ret += circ(uv, vec2(0.894762, 0.0657997), 0.00760375);
    ret += circ(uv, vec2(0.525104, 0.572233), 0.0141796);
    ret += circ(uv, vec2(0.431526, 0.911372), 0.0213234);
    ret += circ(uv, vec2(0.658212, 0.910553), 0.000741023);
    ret += circ(uv, vec2(0.514523, 0.243263), 0.0270685);
    ret += circ(uv, vec2(0.0249494, 0.252872), 0.00876653);
    ret += circ(uv, vec2(0.502214, 0.47269), 0.0234534);
    ret += circ(uv, vec2(0.693271, 0.431469), 0.0246533);
    ret += circ(uv, vec2(0.415, 0.884418), 0.0271696);
    ret += circ(uv, vec2(0.149073, 0.41204), 0.00497198);
    ret += circ(uv, vec2(0.533816, 0.897634), 0.00650833);
    ret += circ(uv, vec2(0.0409132, 0.83406), 0.0191398);
    ret += circ(uv, vec2(0.638585, 0.646019), 0.0206129);
    ret += circ(uv, vec2(0.660342, 0.966541), 0.0053511);
    ret += circ(uv, vec2(0.513783, 0.142233), 0.00471653);
    ret += circ(uv, vec2(0.124305, 0.644263), 0.00116724);
    ret += circ(uv, vec2(0.99871, 0.583864), 0.0107329);
    ret += circ(uv, vec2(0.894879, 0.233289), 0.00667092);
    ret += circ(uv, vec2(0.246286, 0.682766), 0.00411623);
    ret += circ(uv, vec2(0.0761895, 0.16327), 0.0145935);
    ret += circ(uv, vec2(0.949386, 0.802936), 0.0100873);
    ret += circ(uv, vec2(0.480122, 0.196554), 0.0110185);
    ret += circ(uv, vec2(0.896854, 0.803707), 0.013969);
    ret += circ(uv, vec2(0.292865, 0.762973), 0.00566413);
    ret += circ(uv, vec2(0.0995585, 0.117457), 0.00869407);
    ret += circ(uv, vec2(0.377713, 0.00335442), 0.0063147);
    ret += circ(uv, vec2(0.506365, 0.531118), 0.0144016);
    ret += circ(uv, vec2(0.408806, 0.894771), 0.0243923);
    ret += circ(uv, vec2(0.143579, 0.85138), 0.00418529);
    ret += circ(uv, vec2(0.0902811, 0.181775), 0.0108896);
    ret += circ(uv, vec2(0.780695, 0.394644), 0.00475475);
    ret += circ(uv, vec2(0.298036, 0.625531), 0.00325285);
    ret += circ(uv, vec2(0.218423, 0.714537), 0.00157212);
    ret += circ(uv, vec2(0.658836, 0.159556), 0.00225897);
    ret += circ(uv, vec2(0.987324, 0.146545), 0.0288391);
    ret += circ(uv, vec2(0.222646, 0.251694), 0.00092276);
    ret += circ(uv, vec2(0.159826, 0.528063), 0.00605293);
	return max(ret, 0.0);
}

// Procedural texture generation for the water
vec3 water(vec2 uv, vec3 cdir, float iTime)
{
    uv *= vec2(0.25);
	uv += fbm(uv) * 0.2;

    // Parallax height distortion with two directional waves at
    // slightly different angles.
    vec2 a = 0.025 * cdir.xz / cdir.y; // Parallax offset
    float h = sin(uv.x + iTime); // Height at UV
    uv += a * h;
    h = sin(0.841471 * uv.x - 0.540302 * uv.y + iTime);
    uv += a * h;

    // Texture distortion
    float d1 = mod(uv.x + uv.y, M_2PI);
    float d2 = mod((uv.x + uv.y + 0.25) * 1.3, M_6PI);
    d1 = iTime * 0.07 + d1;
    d2 = iTime * 0.5 + d2;
    vec2 dist = vec2(
    	sin(d1) * 0.15 + sin(d2) * 0.05,
    	cos(d1) * 0.15 + cos(d2) * 0.05
    );

    vec3 ret = mix(WATER_COL.rgb, WATER2_COL.rgb, waterlayer(uv + dist.xy));
    ret = mix(ret, FOAM_COL.rgb, waterlayer(vec2(1.0) - uv - dist.yx));
    return ret;
}


void vertex(){
	float time = TIME * wave_speed;
	vec2 uv = UV * wave_size;
	float d1 = mod(uv.x + uv.y, M_2PI);
    float d2 = mod((uv.x + uv.y + 0.25) * 1.3, M_6PI);
    d1 = time * 0.07 + d1;
    d2 = time * 0.5 + d2;
    vec2 dist = vec2(
    	sin(d1) * 0.15 + sin(d2) * 0.05,
    	cos(d1) * 0.15 + cos(d2) * 0.05
    );
	VERTEX.y += dist.y * height;
}

void fragment()
{
	vec2 uv = UV;

    ALBEDO = vec3(water(uv * tile, vec3(0,1,0), TIME * distortion_speed));
}
``


## File: scripts/AuthController.gd

``gdscript
extends Control

var apiUrl : String = "https://103-162-31-23.sslip.io/api/auth/login"
# var apiUrl : String = "https://localhost:7153/api/auth/login"

@onready var httpRequest = $LoginBox/HTTPRequest                                                                                                                                                                             
@onready var emailInput = $LoginBox/VBoxContainer/Email                                                                                                                                                                      
@onready var passwordInput = $LoginBox/VBoxContainer/Password                                                                                                                                                                
@onready var loginButton = $LoginBox/VBoxContainer/LoginButton                                                                                                                                                               
@onready var passwordToggle = $LoginBox/VBoxContainer/Password/ShowPasswordToggle   
@onready var errorLabel = $LoginBox/VBoxContainer/ErrorLabel
@onready var forgotButton = $LoginBox/VBoxContainer/ForgotButton
@onready var welcomeLabel = $WelcomeScene/WelcomeBox/VBoxContainer/Label2                                                                                 
@onready var logoutButton = $LogoutBox/VBoxContainer/LogoutButton
@onready var joinWorldButton = $WelcomeScene/WelcomeBox/VBoxContainer/Button

# New Forgot Password Nodes
@onready var forgotPasswordBox = get_node_or_null("ForgotPasswordBox")
@onready var forgotBackButton = get_node_or_null("ForgotPasswordBox/VBoxContainer/BackButton")

@onready var childProfileScene = get_node_or_null("ChildProfileBox")

@onready var rememberMeCheckbox = get_node_or_null("LoginBox/VBoxContainer/RememberMe")

signal join_world_requested

func _ready() -> void:
	loginButton.pressed.connect(_on_login_pressed)
	httpRequest.request_completed.connect(_on_request_completed)
	passwordToggle.toggled.connect(_on_show_password_toggle)
	welcomeLabel.text = SessionData.fullName
	
	forgotButton.pressed.connect(_on_forgot_password_pressed)
	
	# Kids playful micro-animations (scale & tilt on hover)
	loginButton.mouse_entered.connect(_on_login_hover)
	loginButton.mouse_exited.connect(_on_login_unhover)
	forgotButton.mouse_entered.connect(_on_forgot_hover)
	forgotButton.mouse_exited.connect(_on_forgot_unhover)
	
	if joinWorldButton != null:
		joinWorldButton.pressed.connect(_on_join_world_pressed)
		joinWorldButton.mouse_entered.connect(_on_join_hover)
		joinWorldButton.mouse_exited.connect(_on_join_unhover)
		
	if forgotPasswordBox != null and forgotBackButton != null:
		forgotBackButton.pressed.connect(_on_forgot_back_pressed)
		forgotBackButton.mouse_entered.connect(_on_forgot_back_hover)
		forgotBackButton.mouse_exited.connect(_on_forgot_back_unhover)
		forgotPasswordBox.visible = false

	if childProfileScene != null:
		childProfileScene.visible = false

	$LoginBox.visible = true
	$WelcomeScene.visible = false
	$LogoutBox.visible = false

	if logoutButton == null :
		printerr("Node not found, make sure to assign in the inspector!")
	else:
		logoutButton.pressed.connect(_on_logout_button_pressed)

	_check_auto_login()

func _check_auto_login():
	if FileAccess.file_exists("user://auth.save"):
		var file = FileAccess.open("user://auth.save", FileAccess.READ)
		var saved_email = file.get_line()
		var saved_password = file.get_line()
		file.close()
		
		if saved_email != "" and saved_password != "":
			print_debug("Found saved credentials, auto-logging in...")
			emailInput.text = saved_email
			passwordInput.text = saved_password
			if rememberMeCheckbox != null:
				rememberMeCheckbox.button_pressed = true
			_on_login_pressed()

func _on_login_pressed() -> void:
	print_debug("Login button was pressed! Sending request...")
	if errorLabel != null:
		errorLabel.visible = false
		
	loginButton.disabled = true
	if forgotButton != null:
		forgotButton.disabled = true
	
	var emailText = emailInput.text
	var passwordText = passwordInput.text
	var data_to_send = {
		"email": emailText,
		"password": passwordText
	}
	var json = JSON.stringify(data_to_send)
	var headers = [
		"accept: text/plain",
		"Content-Type: application/json"
	]
	
	# Allow unsafe localhost certificates in VR
	httpRequest.set_tls_options(TLSOptions.client_unsafe())
	httpRequest.request(apiUrl, headers, HTTPClient.METHOD_POST, json)

func _on_show_password_toggle(button_pressed:bool) -> void:
	passwordInput.secret = not button_pressed

func _on_request_completed(result, responseCode, headers, body):
	print_debug("Request completed! Result code: ", result, " HTTP Status: ", responseCode)
	
	loginButton.disabled = false
	if forgotButton != null:
		forgotButton.disabled = false
	
	if result != HTTPRequest.RESULT_SUCCESS:
		print_debug("HTTP Request failed completely! Make sure server is running.")
		return
		
	if responseCode == 401:
		print_debug("Unauthorized: Incorrect email or password.")
		if errorLabel != null:
			errorLabel.text = "Incorrect email or password."
			errorLabel.visible = true
		return
		
	var body_string = body.get_string_from_utf8()
	var json = JSON.parse_string(body_string)
	
	if json == null:
		print_debug("Failed to parse JSON response: ", body_string)
		return
		
	if json.has("success") and json["success"] == true:
		SessionData.accessToken = json["data"]["accessToken"]
		SessionData.refreshToken = json["data"]["refreshToken"]
		SessionData.userId = json["data"]["user"]["id"]
		SessionData.fullName = json["data"]["user"]["fullName"]
		SessionData.roleName = json["data"]["user"]["roleName"]
		SessionData.isActive = json["data"]["user"]["isActive"]
		print_debug(JSON.stringify(json, "\t"))
		print_debug("Successfully logged in as ", SessionData.fullName)
		RefreshTokenApi.start_refresh_timer()
		# Save credentials if Remember Me is checked
		if rememberMeCheckbox != null and rememberMeCheckbox.button_pressed:
			var file = FileAccess.open("user://auth.save", FileAccess.WRITE)
			file.store_line(emailInput.text)
			file.store_line(passwordInput.text)
			file.close()

		welcomeLabel.text = SessionData.fullName
		$LoginBox.visible = false
		$WelcomeScene.visible = false
		$LogoutBox.visible = false
		
		if childProfileScene != null:
			childProfileScene.visible = true
		else:
			$WelcomeScene.visible = true # Fallback just in case
			print_debug("WARNING: ChildProfileScene not found!")
	else:
		# If the API returned a failure (wrong password, etc.)
		print_debug("API returned success: false")
		if errorLabel != null:
			var msg = "Lỗi đăng nhập."
			if json.has("message"):
				msg = json["message"]
			errorLabel.text = msg
			errorLabel.visible = true
		
func _on_logout_button_pressed() -> void:
	# SessionData.accessToken = ""
	# SessionData.refreshToken = ""
	# SessionData.userId = 0
	# SessionData.fullName = ""
	# SessionData.userName = ""
	# SessionData.roleName = ""
	# SessionData.isActive = false
	PlayerData.clear()
	print_debug("User Logout Successfully")
	
	# Clear auto-login save file
	if FileAccess.file_exists("user://auth.save"):
		var dir = DirAccess.open("user://")
		dir.remove("auth.save")
		emailInput.text = ""
		passwordInput.text = ""
		if rememberMeCheckbox != null:
			rememberMeCheckbox.button_pressed = false
	
	#Stop the refreshTokenApi
	RefreshTokenApi.stop_refresh_timer()
	$LoginBox.visible = true
	$WelcomeScene.visible = false
	$LogoutBox.visible = false

func _on_login_hover() -> void:
	loginButton.pivot_offset = loginButton.size / 2
	var tween = create_tween().set_parallel(true)
	tween.tween_property(loginButton, "scale", Vector2(1.05, 1.05), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(loginButton, "rotation_degrees", 1.5, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_login_unhover() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(loginButton, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(loginButton, "rotation_degrees", 0.0, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_forgot_hover() -> void:
	forgotButton.pivot_offset = forgotButton.size / 2
	var tween = create_tween()
	tween.tween_property(forgotButton, "scale", Vector2(1.08, 1.08), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_forgot_unhover() -> void:
	var tween = create_tween()
	tween.tween_property(forgotButton, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_join_world_pressed() -> void:
	print_debug("Join World pressed! Loading world...")
	join_world_requested.emit()
func _on_join_hover() -> void:
	if joinWorldButton != null:
		joinWorldButton.pivot_offset = joinWorldButton.size / 2
		var tween = create_tween().set_parallel(true)
		tween.tween_property(joinWorldButton, "scale", Vector2(1.05, 1.05), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(joinWorldButton, "rotation_degrees", 1.5, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_join_unhover() -> void:
	if joinWorldButton != null:
		var tween = create_tween().set_parallel(true)
		tween.tween_property(joinWorldButton, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(joinWorldButton, "rotation_degrees", 0.0, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

# --- FORGOT PASSWORD LOGIC ---

func _on_forgot_password_pressed() -> void:
	if forgotPasswordBox != null:
		$LoginBox.visible = false
		forgotPasswordBox.visible = true
	else:
		print_debug("WARNING: ForgotPasswordBox not found! You need to drag ForgotPasswordScreen.tscn into your scene!")

func _on_forgot_back_pressed() -> void:
	if forgotPasswordBox != null:
		forgotPasswordBox.visible = false
		$LoginBox.visible = true

func _on_forgot_back_hover() -> void:
	if forgotBackButton != null:
		forgotBackButton.pivot_offset = forgotBackButton.size / 2
		var tween = create_tween()
		tween.tween_property(forgotBackButton, "scale", Vector2(1.05, 1.05), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_forgot_back_unhover() -> void:
	if forgotBackButton != null:
		var tween = create_tween()
		tween.tween_property(forgotBackButton, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

``


## File: scripts/AutoOpenDoor.gd

``gdscript
extends Node3D

@onready var animation_player = $AnimationPlayer
var is_open = false



func _on_area_3d_body_entered(body: Node3D) -> void:
	if animation_player.is_playing():
		return
	if not is_open:
		open_door()
	else: 
		close_door()

func open_door():
	is_open = true
	print("Signal received! Playing sliding door animation...")
	animation_player.play("open")

func close_door():
	is_open = false
	print("Signal received! Playing sliding door animation...")
	animation_player.play("close")
	
``


## File: scripts/AzureSpeechManager.cs

``csharp
using Godot;
using Microsoft.CognitiveServices.Speech;
using System;

public partial class AzureSpeechManager : Node
{
	private string SubscriptionKey = "";
	private string Region = "";
	private string Language = "";

	[Signal]
	public delegate void OnSpeechRecognizedEventHandler(string text);
	[Signal]
	public delegate void OnSpeechFailedEventHandler(string reason);

	public static AzureSpeechManager Instance {get; private set;}

	public override void _Ready(){
		Instance = this;
		LoadSettingsFromJSON();
	}

	private void LoadSettingsFromJSON()
	{
		// MUST have res:// at the beginning for Godot to find it!
		string path = "res://Prefabs/PlayerPrefabs/appsettings.json";
		
		if (FileAccess.FileExists(path))
		{
			using var file = FileAccess.Open(path,FileAccess.ModeFlags.Read);
			string content = file.GetAsText();

			var jsonDict = Json.ParseString(content).AsGodotDictionary();
			if (jsonDict.ContainsKey("AzureService"))
			{
				var azureSettings = jsonDict["AzureService"].AsGodotDictionary();
				
				// These must match the exact names inside the AzureService JSON block!
				SubscriptionKey = azureSettings["SubscriptionKey"].AsString();
				Region = azureSettings["Region"].AsString();
				Language = azureSettings["Language"].AsString();
				
				GD.Print("AzureSpeechManager: Successfully loaded keys from appsettings.json");
			}
		}
		else GD.PrintErr($"AzureSpeechManager: Could not find {path}!. Make sure it exists");
	}

	private SpeechRecognizer _currentRecognizer;
	private bool _isListening = false;

	public async void StartListening(){
		if(string.IsNullOrEmpty(SubscriptionKey) || string.IsNullOrEmpty(Region)){
			GD.PrintErr("AzureSpeechManager: Key or Reigon not found");
			return;
		}
		
		_isListening = true;
		
		GD.Print("Connecting to Azure Service...");

		await System.Threading.Tasks.Task.Run(async () => {
			var config = SpeechConfig.FromSubscription(SubscriptionKey, Region);
			config.SpeechRecognitionLanguage = Language;
			
			var recognizer = new SpeechRecognizer(config);
			_currentRecognizer = recognizer;
			
			GD.Print("AzureSpeechManager: Listening... Speak now!");
			try {
				var result = await recognizer.RecognizeOnceAsync().ConfigureAwait(false);
				
				// Only process the result if we haven't dropped the item!
				if (_isListening && _currentRecognizer == recognizer) {
					CallDeferred(MethodName.ProcessResult, result.Text, (int)result.Reason);
				}
				
				// Safely dispose only AFTER it finishes running
				recognizer.Dispose();
			} catch (Exception e) {
				GD.PrintErr("AzureSpeechManager Error: " + e.Message);
			}
		});
	}

	public void StopListening() {
		_isListening = false;
		_currentRecognizer = null;
		GD.Print("AzureSpeechManager: Microphone turned off (ignoring result).");
	}

	private void ProcessResult(string recognizeText, int reasonCode)
	{
		var reason = (ResultReason)reasonCode;
		if(reason == ResultReason.RecognizedSpeech)
		{
			GD.Print($"AzureSpeechManager: Heard '{recognizeText}'");
			EmitSignal(SignalName.OnSpeechRecognized, recognizeText.ToLower());
		}
		else if(reason == ResultReason.NoMatch)
		{
			GD.Print("AzureSpeechManager: Speech could not be recognized");
			EmitSignal(SignalName.OnSpeechFailed, "No Match");
		}
	}

    public override void _ExitTree()
    {
		if(Instance == this) Instance = null;
    }

}

``


## File: scripts/AzureSpeechSpawner.gd

``gdscript
extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if(body.is_in_group("player_body")):
		print("Player is entering trigger zone, turning on mic...");
		# In GDScript, we access C# Autoloads by getting them from the root!
		var speech_manager = get_node_or_null("/root/AzureSpeechManager")
		if speech_manager:
			speech_manager.StartListening()

``


## File: scripts/basket_trigger.gd

``gdscript
extends Area3D
class_name BasketTrigger

## Emitted when a valid object is dropped into the basket
signal puzzle_solved

@export var required_group: String = "interactable"
var _is_solved: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	print("Basket Trigger Ready!")

func _on_body_entered(body: Node3D) -> void:
	if _is_solved:
		return
		
	# Check if the object that entered is what we want
	# By default, we check if it's a RigidBody3D in the "interactable" group
	if body is RigidBody3D and (required_group == "" or body.is_in_group(required_group)):
		print("Valid object dropped in basket! Emitting puzzle_solved.")
		_is_solved = true
		puzzle_solved.emit()

``


## File: scripts/BottleReturnController.gd

``gdscript
extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

``


## File: scripts/bulk_physic.gd

``gdscript
@tool
extends EditorScenePostImport

# This function runs automatically on every file you import
func _post_import(scene):
	add_collisions(scene)
	return scene

func add_collisions(node):
	# If the node is a mesh, automatically generate a collision box for it
	if node is MeshInstance3D:
		node.create_trimesh_collision()
		
	# Check all nested children just in case
	for child in node.get_children():
		add_collisions(child)

``


## File: scripts/CashRegisterController.gd

``gdscript
extends StaticBody3D

signal item_scanned_for_teaching(item_id, hint_audio)

# CONNECT YOUR ROLLER AREA3D'S 'body_entered' SIGNAL TO THIS FUNCTION!
func _on_roller_area_body_entered(body: Node3D) -> void:
	if body is RigidBody3D and body.has_meta("itemId"):
		var id = body.get_meta("itemId")
		var hint = body.get_meta("hintAudio")
		
		print("Cash Register detected: ", id)
		emit_signal("item_scanned_for_teaching", id, hint)

``


## File: scripts/CellingFanRotation.gd

``gdscript
extends Node3D

@export var rotationSpeed : float = 3.0

func _process(delta: float) -> void:
	rotate_y(rotationSpeed * delta )	

``


## File: scripts/EmployeeController.gd

``gdscript
extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

``


## File: scripts/GameManager.gd

``gdscript
extends Node

var currentHeldItemId = ""
var validScannedItem = []

signal speech_result(is_correct: bool)
signal profile_selected
func _ready() -> void:
	var speechManager = get_node_or_null("/root/AzureSpeechManager")
	if speechManager:
		speechManager.OnSpeechRecognized.connect(_on_speech_recognized)

func start_checkout_test(itemId: String):
	currentHeldItemId = itemId
	print("GameManager: Checkout test started for: ", itemId)
	var speechManager = get_node_or_null("/root/AzureSpeechManager")
	if speechManager:
		speechManager.StartListening()

func stop_checkout_test():
	print("GameManager: Checkout test stopped.")
	currentHeldItemId = ""
	var speechManager = get_node_or_null("/root/AzureSpeechManager")
	if speechManager and speechManager.has_method("StopListening"):
		speechManager.StopListening()

func _on_speech_recognized(text:String):
	if currentHeldItemId != "":
		if text.to_lower().contains(currentHeldItemId.to_lower()):
			print("Correct! Word matched: ", currentHeldItemId)
			validScannedItem.append(currentHeldItemId)
			emit_signal("speech_result", true)
		else:
			print("Incorrect! You said: ", text)
			emit_signal("speech_result", false)
``


## File: scripts/GenerateRoadMeshLib.gd

``gdscript
@tool
extends EditorScript

func _run():
	var dir_path = "res://Assets/kenney_3d-road-tiles/Models/gLTF/"
	var dir = DirAccess.open(dir_path)
	if not dir:
		print("Could not open directory.")
		return
		
	var mesh_lib = MeshLibrary.new()
	dir.list_dir_begin()
	
	var file_name = dir.get_next()
	var item_id = 0
	
	print("Generating MeshLibrary...")
	
	while file_name != "":
		if file_name.ends_with(".gltf") and not file_name.ends_with(".import"):
			var path = dir_path + file_name
			var packed_scene = load(path)
			if packed_scene is PackedScene:
				var instance = packed_scene.instantiate()
				var meshes = _find_meshes(instance)
				
				for mesh_node in meshes:
					var mesh = mesh_node.mesh
					if mesh:
						mesh_lib.create_item(item_id)
						
						# Combine the filename and the mesh node name to make it 100% unique!
						var base_name = file_name.replace(".gltf", "")
						mesh_lib.set_item_name(item_id, base_name + "_" + mesh_node.name)
						mesh_lib.set_item_mesh(item_id, mesh)
						
						# Automatically generate Trimesh (Concave) collision
						var shape = mesh.create_trimesh_shape()
						if shape:
							mesh_lib.set_item_shapes(item_id, [shape, Transform3D.IDENTITY])
						
						item_id += 1
				instance.free()
		file_name = dir.get_next()
		
	ResourceSaver.save(mesh_lib, "res://Assets/kenney_3d-road-tiles/city_road_kit_mesh_library_fixed.tres")
	print("Success! Mesh Library generated with ", item_id, " total items!")

func _find_meshes(node: Node) -> Array[MeshInstance3D]:
	var result: Array[MeshInstance3D] = []
	if node is MeshInstance3D:
		result.append(node)
	for child in node.get_children():
		result.append_array(_find_meshes(child))
	return result

``


## File: scripts/glass_door.gd

``gdscript
extends Node3D

func _on_area_3d_body_entered(_body: Node3D) -> void:
	$AnimationPlayer.play("Open")


func _on_area_3d_body_exited(_body: Node3D) -> void:                                                                                                                                                               
	if $Area3D.get_overlapping_bodies().size() == 0:                                                                                                                                                                         
		$AnimationPlayer.play("Close")                                                                                                                                                                                       
                                              

``


## File: scripts/InitializeScript.gd

``gdscript
@tool
extends  XRToolsSceneBase

``


## File: scripts/InitialTestScript.gd

``gdscript
@tool
extends XRToolsSceneBase

var xr_interface: XRInterface

func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialise successfully")
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
		get_viewport().use_xr = true
		get_viewport().scaling_3d_scale = 1.0
	else:
		print("OpenXR not initalise, please check if your headset is connected")

func _input(event):
	var replayer = find_child("Replayer", true, false)
	var mic_controller = find_child("MicController", true, false)
	
	if event.is_action_pressed("record"):
		print("Start recording telementry and audio")
		if replayer:
			replayer.start_recording_session()
		if mic_controller:
			mic_controller.start_record()
			
	if event.is_action_pressed("stop"):
		print("Stop recording telementry and audio")
		if mic_controller:
			mic_controller.stop_record_and_save()
		if replayer:
			replayer.stop_and_save_session()
		
	if event.is_action_pressed("play"):
		print("Playing back animation...")
		if replayer:
			replayer.load_and_play_session()
	
	if event.is_action_pressed("ui_accept"):
		test_the_upload()
	
func test_the_upload() -> void:
		print("Trigger upload function...")
		var jsonPath = "user://temp_replay_2026-06-03T23-05-10.json"
		var audioPath = "user://player_audio_2026-06-06T00-39-55.wav"
		#Call the uploader node
		var test_node = get_node("/root/SessionUploader")
		if test_node:
			test_node.UploadSessionDataAsync(jsonPath, audioPath)
		else: 
			print("Error: Cannt find SessionUploader node");

``


## File: scripts/interactable_table.gd

``gdscript
extends Node3D
@export var spawn_obj: PackedScene
@export var spawn_pos: Marker3D
	
func _on_interactable_area_button_2_button_pressed(_button) -> void:
	if not spawn_obj or not spawn_pos:
		printerr("TableButton: Missing an assignment in the inspector!")
		return
	var obj = spawn_obj.instantiate() as Node3D
	get_tree().current_scene.add_child(obj)
	obj.global_position = spawn_pos.global_position

``


## File: scripts/LadderTrigger.gd

``gdscript
extends Marker3D

@export var spawnPoint : Marker3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player_body"):
		body.global_position = spawnPoint.global_position

``


## File: scripts/LoginController.gd

``gdscript
extends Node

var apiUrl : String = "https://103-162-31-23.sslip.io/api/auth/lgin"
# var apiUrl : String = "https://localhost:7153/api/auth/login"

@onready var httpRequest = $"../HTTPRequest"
@onready var emailInput = $"../VBoxContainer/Email"
@onready var passwordInput = $"../VBoxContainer/Password"
@onready var loginButton = $"../VBoxContainer/LoginButton"
@onready var passwordToggle = $"../VBoxContainer/Password/ShowPasswordToggle"
func _ready() -> void:
	loginButton.pressed.connect(_on_login_pressed)
	httpRequest.request_completed.connect(_on_request_completed)
	passwordToggle.toggled.connect(_on_show_password_toggle)

func _on_login_pressed() -> void:
	var emailText = emailInput.text
	var passwordText = passwordInput.text
	var data_to_send = {
		"email": emailText,
		"password": passwordText
	}
	var json = JSON.stringify(data_to_send)
	var headers = [
		"accept: text/plain",
		"Content-Type: application/json"
	]
	httpRequest.request(apiUrl,headers,HTTPClient.METHOD_POST, json)

func _on_show_password_toggle(button_pressed:bool) -> void:
	passwordInput.secret = not button_pressed

func _on_request_completed(result, responseCode, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json["success"] == true:
		SessionData.accessToken = json["data"]["accessToken"]
		SessionData.refreshToken = json["data"]["refreshToken"]
		SessionData.userId = json["data"]["user"]["id"]
		SessionData.fullName = json["data"]["user"]["fullName"]
		SessionData.userName = json["data"]["user"]["username"]
		SessionData.roleName = json["data"]["user"]["roleName"]
		SessionData.isActive = json["data"]["user"]["isActive"]
		print_debug(JSON.stringify(json, "\t"))
		print_debug("Successfully logged in as ", SessionData.fullName)

``


## File: scripts/LoginSceneManager.gd

``gdscript
extends Node3D

@export_file("*.tscn") var main_scene: String = "res://Scenes/CyberLoadingSpace.tscn"

func _ready() -> void:
	var viewport2d = $Room/ComputerSetup/ComputerMonitor/Viewport2Din3D
	var auth_scene = viewport2d.get_scene_instance()

	if auth_scene == null:
		push_error("LoginSceneManager: AuthScene instance not found.")
		return

	if auth_scene.has_signal("join_world_requested"):
		auth_scene.join_world_requested.connect(Callable(self, "_on_join_world_requested"))
	else:
		push_error("LoginSceneManager: AuthScene does not have join_world_requested signal.")

func _on_join_world_requested() -> void:
	print_debug("LoginSceneManager: Join requested. Loading world...")

	if main_scene.is_empty():
		push_error("LoginSceneManager: main_scene is empty.")
		return

	get_tree().change_scene_to_file(main_scene)

``


## File: scripts/LogoutController.gd

``gdscript
extends PanelContainer

@export var logoutButton : Button
func _ready() -> void:
	if logoutButton == null :
		printerr("Node not found, make sure to assign in the inspector!")
	logoutButton.pressed.connect(_on_logout_button_pressed)

func _on_logout_button_pressed() -> void:
	SessionData.accessToken = ""
	SessionData.refreshToken = ""
	SessionData.userId = 0
	SessionData.fullName = ""
	SessionData.userName = ""
	SessionData.roleName = ""
	SessionData.isActive = false
	print_debug("User Logout Successfully")
``


## File: scripts/mesh_instance_3d.gd

``gdscript
extends MeshInstance3D

var scrollSpeed: float = 0.25

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if material_override != null:
		material_override.uv1_offset.x += scrollSpeed * delta

``


## File: scripts/MicController.gd

``gdscript
extends Node
class_name MicController

@export var replayController: ReplayController

var record_effect: AudioEffectRecord
var recording: AudioStreamWAV

func _ready():
	var index = AudioServer.get_bus_index("ReplayMic")
	record_effect = AudioServer.get_bus_effect(index,0)

func start_record():
	if record_effect:
		record_effect.set_recording_active(true)
	
func stop_record_and_save():
	if record_effect and record_effect.is_recording_active():
		record_effect.set_recording_active(false)
		recording = record_effect.get_recording()
	if recording:
		var time_string = Time.get_datetime_string_from_system().replace(":", "-")
		var final_audio_name = "player_audio_" + time_string + ".wav"
		var full_save_path = "user://" + final_audio_name 
		recording.save_to_wav(full_save_path)
		print("Audio successfully saved: ", final_audio_name)
		
		if replayController != null:
			replayController.linked_audio_filename = final_audio_name
			var final_json_name = "player_replay_" + time_string + ".json"
			replayController.SAVE_PATH = "user://" + final_json_name
			replayController.stop_and_save_session()

``


## File: scripts/MicInput.cs

``csharp
using Godot;
using System;
using System.Collections.Generic;

public partial class MicInput : Node
{
	// 1. We change this from SpeechRecognizer to a generic Node so it can hold the GDScript Whisper node
	[Export] public Node _whisperNode;

	public static MicInput Instance { get; private set; }

	[Signal]
	public delegate void OnCommandRecognizedEventHandler(string actionId);

	public event Action<string> OnRawPartialText;
	public event Action<string> OnRawFinalText;

	private Dictionary<string, string> _vocabulary = new Dictionary<string, string>
	{
		{ "mở cửa", "door_open" },
		{ "đóng cửa", "door_close" },
		{ "bắt đầu", "tutorial_start" }
	};

	public override void _Ready()
	{
		Instance = this;

		if (_whisperNode != null)
		{
			// Automatically connect the Whisper signal via code so you don't have to use the Editor!
			_whisperNode.Connect("transcribed_msg", new Callable(this, MethodName._on_whisper_transcribed_msg));
			GD.Print("SpeechBrain (Whisper): Online and listening.");
		}
		else
		{
			GD.PrintErr("SpeechBrain: Critical Failure. Whisper Node is null. Did you assign it in the Inspector?");
		}
	}

	private void ProcessRawSpeech(string rawText)
	{
		if (string.IsNullOrWhiteSpace(rawText)) return;
		string normalized = rawText.ToLower().Trim();

		foreach (var kvp in _vocabulary)
		{
			if (normalized.Contains(kvp.Key))
			{
				GD.Print($"SpeechBrain: Heard '{kvp.Key}'. Broadcasting action '{kvp.Value}' globally.");
				EmitSignal(SignalName.OnCommandRecognized, kvp.Value);
				break;
			}
		}
	}

	public void TurnOnMic() 
	{
		if (_whisperNode != null) _whisperNode.Set("recording", true);
	}

	public string TurnOffMic() 
	{
		if (_whisperNode != null) _whisperNode.Set("recording", false);
		return "";
	}

	public bool IsListening() 
	{
		if (_whisperNode != null) return (bool)_whisperNode.Get("recording");
		return false;
	}

	public void _on_whisper_transcribed_msg(bool isComplete, string newText)
	{
		// Still check for our keywords like "mở cửa"!
		ProcessRawSpeech(newText);

		if (isComplete)
		{
			// This is a final result! Send it to your UI.
			OnRawFinalText?.Invoke(newText);
		}
		else
		{
			// This is a partial, live-updating result! Send it to your UI.
			OnRawPartialText?.Invoke(newText);
		}
	}
}

``


## File: scripts/ModeSpawnerController.gd

``gdscript
extends Marker3D
class_name GameModeSpawner

@export var playerNode: PackedScene
@export var spectatorUI: PackedScene
var worldScene: String 

func _ready() -> void:
	if owner!= null	:
		SessionData.target_scene_path = owner.scene_file_path
	var instance_to_spawn: Node
	# Check the state. (Make sure your variable name here matches SessionData exactly!)
	if SessionData.is_spectator:
		instance_to_spawn = spectatorUI.instantiate()
		print("Mode: Spectator")
	else:
		instance_to_spawn = playerNode.instantiate()
		print("Mode: Player")
	# Safely add the chosen mode to the world
	get_parent().call_deferred("add_child", instance_to_spawn)
	
	if instance_to_spawn is Node3D:
	# Snap the player/spectator to this Marker's exact position and rotation
		instance_to_spawn.global_transform = self.global_transform
	
	# The spawner has done its job, so it can delete itself
	queue_free()

``


## File: scripts/NpcController.gd

``gdscript
extends Node3D

@export var npc_audio_player : AudioStreamPlayer3D
@export var npc_animation_player : AnimationPlayer
@export var question_1_audio : AudioStream

var current_item_id = ""
var current_hint_audio = null
var failed_attempts = 0
var is_currently_teaching = false # <--- NEW: Prevents other NPCs from reacting!

func _ready():
	var gameManager = get_node_or_null("/root/GameManager")
	if gameManager:
		gameManager.connect("speech_result", Callable(self, "_on_speech_result"))

# YOU MUST CONNECT THE CASH REGISTER'S 'item_scanned_for_teaching' SIGNAL TO THIS FUNCTION!
func _on_item_scanned_for_teaching(item_id: String, hint_audio: AudioStream):
	current_item_id = item_id
	current_hint_audio = hint_audio
	failed_attempts = 0
	is_currently_teaching = true # <--- Lock this NPC into teaching mode!
	
	print("NPC: Received item scan for ", current_item_id)
	ask_question_1()

func ask_question_1():
	if npc_audio_player and question_1_audio:
		npc_audio_player.stream = question_1_audio
		npc_audio_player.play()
		await npc_audio_player.finished
	
	var gameManager = get_node_or_null("/root/GameManager")
	if gameManager:
		gameManager.start_checkout_test(current_item_id)

func ask_question_2():
	if npc_audio_player and current_hint_audio:
		npc_audio_player.stream = current_hint_audio
		npc_audio_player.play()
		await npc_audio_player.finished
	
	var gameManager = get_node_or_null("/root/GameManager")
	if gameManager:
		gameManager.start_checkout_test(current_item_id)

func _on_speech_result(is_correct: bool):
	# If this NPC isn't the one who scanned the item, ignore the signal!
	if not is_currently_teaching:
		return
		
	if is_correct:
		print("NPC: Correct! Great job!")
		is_currently_teaching = false # Unlock NPC
		if npc_animation_player and npc_animation_player.has_animation("emote-yes"):
			npc_animation_player.play("emote-yes")
	else:
		failed_attempts += 1
		print("NPC: That's not right. Attempt ", failed_attempts)
		if npc_animation_player and npc_animation_player.has_animation("emote-no"):
			npc_animation_player.play("emote-no")
			
		if failed_attempts == 1:
			ask_question_2()
		else:
			print("NPC: Failed again. Let's move on or give the direct answer!")
			is_currently_teaching = false # Unlock NPC

``


## File: scripts/ProgressMenu.gd

``gdscript
extends Control

@onready var progress_bar = $MenuBox/MarginContainer/VBoxContainer/ProgressSection/Progress
@onready var progress_label = $MenuBox/MarginContainer/VBoxContainer/ProgressSection/HBoxContainer/ProgressLabel

@onready var count_value = $MenuBox/MarginContainer/VBoxContainer/StatsSection/CountValue
@onready var total_value = $MenuBox/MarginContainer/VBoxContainer/StatsSection/TotalValue
@onready var stars_label = $MenuBox/MarginContainer/VBoxContainer/StatsSection/StarsLabel

@onready var close_button = $MenuBox/MarginContainer/VBoxContainer/CloseButton

var count: int = 0
var total: int = 10

func _ready() -> void:
	_update_ui()
	
	close_button.pressed.connect(_on_close_button_pressed)
	close_button.mouse_entered.connect(_on_button_hover.bind(close_button))
	close_button.mouse_exited.connect(_on_button_unhover.bind(close_button))

func set_progress(new_count: int, new_total: int = -1) -> void:
	var old_count = count
	if new_total != -1:
		total = max(1, new_total)
	count = clamp(new_count, 0, total)
	
	_update_ui()
	if count > old_count:
		_bounce_label(count_value)

func increment_progress() -> void:
	set_progress(count + 1)

func _update_ui() -> void:
	# Calculate percentage
	var percent = 0.0
	if total > 0:
		percent = (float(count) / total) * 100.0
	
	# Animate the progress bar value using a Tween for a smooth, dynamic effect!
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", percent, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Update labels
	progress_label.text = str(count) + " / " + str(total) + " câu (" + str(round(percent)) + "%)"
	count_value.text = str(count)
	total_value.text = str(total)
	
	# Update stars based on count
	var stars = ""
	for i in range(count):
		stars += "⭐"
	if count == 0:
		stars = "Chưa có sao 😿"
	stars_label.text = stars

func _bounce_label(label: Label) -> void:
	label.pivot_offset = label.size / 2
	var tween = create_tween()
	tween.tween_property(label, "scale", Vector2(1.4, 1.4), 0.1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.1)

func _on_close_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.finished.connect(queue_free)

func _on_button_hover(btn: Button) -> void:
	btn.pivot_offset = btn.size / 2
	var tween = create_tween().set_parallel(true)
	tween.tween_property(btn, "scale", Vector2(1.05, 1.05), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(btn, "rotation_degrees", 1.5, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_button_unhover(btn: Button) -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(btn, "rotation_degrees", 0.0, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

``


## File: scripts/RealItemInstantiate.gd

``gdscript
extends Area3D

@export var realItem : PackedScene
@export var itemId : String = ""
@export var itemIcon : Texture2D
@export var hintAudio : AudioStream

	# 1. Godot XR Tools checks this to see if it's allowed to grab it                                                                                                                                                      
func can_pick_up(by: Node3D) -> bool:                                                                                                                                                                                  
	return true                                                                                                                                                                                                           

func request_highlight(by: Node3D, enable: bool) -> void:
	pass

	# 2. Godot XR Tools automatically calls this when you press the Grab Button!                                                                                                                                           
func pick_up(by: Node3D) -> void:                                                                                                                                                                                      
	print("DEBUG: Fake item grabbed! Spawning real item...")
	# Spawn the real item                                                                                                                                                                                                 
	var realItemInstance = realItem.instantiate()                                                                                                                                                                         
	get_tree().current_scene.add_child(realItemInstance)                                                                                                                                                                  
	realItemInstance.global_transform = global_transform
	# Trick the VR Hand into holding the Real Item instead of this fake one
	by.picked_up_object = realItemInstance
	realItemInstance.pick_up(by)

	# INJECT METADATA INTO THE REAL ITEM
	var final_id = itemId if itemId != "" else self.name
	final_id = final_id.rstrip("0123456789")
	realItemInstance.set_meta("itemId", final_id)
	realItemInstance.set_meta("hintAudio", hintAudio)

	# Delete the fake item
	queue_free()

``


## File: scripts/RefreshTokenApi.gd

``gdscript
extends Node

# Autoload script: refreshes the accessToken once, 10 minutes after login.
# Add this to Project Settings -> Autoload as "RefreshTokenApi"

var refresh_url : String = "https://103-162-31-23.sslip.io/api/auth/refresh-token"
var http_request : HTTPRequest
var refresh_timer : Timer

# Refresh once after 10 minutes
var refresh_delay_sec : float = 10 * 60

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_refresh_completed)
	
	refresh_timer = Timer.new()
	refresh_timer.wait_time = refresh_delay_sec
	refresh_timer.one_shot = true
	refresh_timer.autostart = false
	add_child(refresh_timer)
	refresh_timer.timeout.connect(_on_timer_timeout)

func start_refresh_timer():
	# Call this once after a successful login
	print_debug("RefreshTokenApi: Will refresh token in ", refresh_delay_sec, " seconds")
	refresh_timer.start()

func stop_refresh_timer():
	# Call this on logout
	refresh_timer.stop()
	print_debug("RefreshTokenApi: Timer cancelled")

func _on_timer_timeout():
	print_debug("RefreshTokenApi: 10 minutes passed, refreshing token now...")
	_do_refresh()

func _do_refresh():
	if SessionData.accessToken == "" or SessionData.refreshToken == "":
		print_debug("RefreshTokenApi: No tokens to refresh!")
		return
	
	var data_to_send = {
		"accessToken": SessionData.accessToken,
		"refreshToken": SessionData.refreshToken
	}
	var json_body = JSON.stringify(data_to_send)
	
	var headers = [
		"Authorization: Bearer " + SessionData.accessToken,
		"Content-Type: application/json",
		"accept: */*"
	]
	
	http_request.set_tls_options(TLSOptions.client_unsafe())
	http_request.request(refresh_url, headers, HTTPClient.METHOD_POST, json_body)

func _on_refresh_completed(result, responseCode, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		print_debug("RefreshTokenApi: HTTP request failed!")
		return
	
	if responseCode != 200:
		print_debug("RefreshTokenApi: Server returned ", responseCode)
		return
	
	var body_string = body.get_string_from_utf8()
	var json = JSON.parse_string(body_string)
	
	if json == null:
		print_debug("RefreshTokenApi: Failed to parse JSON")
		return
	
	if json.has("success") and json["success"] == true:
		SessionData.accessToken = json["data"]["accessToken"]
		SessionData.refreshToken = json["data"]["refreshToken"]
		print_debug("RefreshTokenApi: Tokens refreshed successfully!")
	else:
		print_debug("RefreshTokenApi: Refresh failed - ", json.get("message", "Unknown error"))

``


## File: scripts/ReplayController.gd

``gdscript
extends Node
class_name  ReplayController
@export var recorded_objects : Array[Node3D]
@export var dummy_scene : PackedScene # Drag your saved Dummy scene here in the Inspector
@onready var delay: Timer = $Delay

# File path configuration
var SAVE_PATH : String = "user://replay.json"

# Runtime tracking state
var frames : int = 0
var recording_data : Dictionary = {}
var recording : bool = false
var is_playing : bool = false
var current_dummy : Node3D = null
var linked_audio_filename: String = ""
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
	
	# Architecture Fix: When using a Staging system, get_tree().current_scene returns the Staging node.
	# We must search up the tree to find the actual loaded level (which inherits from XRToolsSceneBase)
	var active_world_path : String = ""
	var level_node = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	if level_node != null:
		active_world_path = level_node.scene_file_path
	else:
		active_world_path = get_tree().current_scene.scene_file_path # Fallback
	
	var file_payload : Dictionary = {
		"metadata": {
			"player_profile": "Hoc",
			"total_recorded_frames": frames,
			"engine_version": "Godot 4",
			"audio_file" : linked_audio_filename,
			"world_path": active_world_path
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

``


## File: scripts/respawn_hazard.gd

``gdscript
extends Area3D

## The node where the player should be teleported upon entering this hazard.
@export var respawn_point: Node3D

# We cache the transform because the Spawner deletes itself after running!
var _cached_respawn_transform: Transform3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	if respawn_point:
		_cached_respawn_transform = respawn_point.global_transform
	else:
		push_error("RespawnHazard: No respawn_point assigned on ", name)
		
	print("Respawn Hazard Ready! Monitoring for bodies...")

func _on_body_entered(body: Node3D) -> void:
	print("SOMETHING HIT THE WATER! Body name: ", body.name)
	
	# 1. Type check: Is this the player's physics capsule?
	var player_body = body as XRToolsPlayerBody
	if not player_body:
		print("It was not the XRToolsPlayerBody. It was a: ", body.get_class())
		return
		
	# 2. Validation: We check our cached transform instead of the node!
	if _cached_respawn_transform == null or _cached_respawn_transform == Transform3D():
		push_error("RespawnHazard: Cached transform is missing.")
		return
		
	print("Player detected! Teleporting...")
	
	# 3. Use the built-in XRTools teleport function. 
	player_body.teleport(_cached_respawn_transform)
	
	# Reset falling momentum
	player_body.velocity = Vector3.ZERO

``


## File: scripts/SessionData.gd

``gdscript
extends Node
#Login & Identity Data
var accessToken: String = ""
var refreshToken : String = ""
var userId: int = 0
var fullName : String = ""
var userName : String = ""
var roleName : String = ""
var isActive : bool = true


#Replay storing Path
var target_replay_path: String = ""
var target_audio_path: String = ""
var target_scene_path: String = ""
var is_spectator : bool = false

``


## File: scripts/SessionUploader.cs

``csharp
using Godot;
using System;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;

public partial class SessionUploader : Node
{
	private static readonly System.Net.Http.HttpClient client = new System.Net.Http.HttpClient();
	private readonly string apiUrl = "https://localhost:7153/api/files";
	// Called when the node enters the scene tree for the first time.
	public async void UploadSessionDataAsync(string jsonPath, string audioPath)
	{
		string absoluteJsonPath = ProjectSettings.GlobalizePath(jsonPath);
		string absoluteAudioPath = ProjectSettings.GlobalizePath(audioPath);
		try
		{

			//Setup FileStream
			using (var form = new MultipartFormDataContent())
			using (var jsonStream = File.OpenRead(absoluteJsonPath))
			using (var audioStream = File.OpenRead(absoluteAudioPath))
			{
				//Use FileStream for json
				var jsonContent = new StreamContent(jsonStream);
				jsonContent.Headers.ContentType = MediaTypeHeaderValue.Parse("application/json");
				form.Add(jsonContent, "Metadata", Path.GetFileName(absoluteJsonPath));

				//Use FileStream for audio
				var audioContent = new StreamContent(audioStream);
				audioContent.Headers.ContentType = MediaTypeHeaderValue.Parse("audio/wav");
				form.Add(audioContent, "Audio", Path.GetFileName(absoluteAudioPath));

				GD.Print("Starting upload to server...");
				HttpResponseMessage response = await client.PostAsync(apiUrl, form);
				if (response.IsSuccessStatusCode)
				{
					GD.Print($"Upload successful! Status: {response.StatusCode} ");
				}
				else GD.Print($"Upload failed! Server response with: {response.StatusCode}, message: {response.ReasonPhrase}");
			}

		}
		catch (Exception e)
		{
			GD.Print($"Exception during upload {e.Message}");
		}
	}
}

``


## File: scripts/SettingsMenu.gd

``gdscript
extends Control

@onready var master_slider = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/MasterRow/MasterSlider
@onready var master_value = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/MasterRow/HBoxContainer/MasterValue

@onready var music_slider = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/MusicRow/MusicSlider
@onready var music_value = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/MusicRow/HBoxContainer/MusicValue

@onready var sfx_slider = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/SFXRow/SFXSlider
@onready var sfx_value = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/SFXRow/HBoxContainer/SFXValue

@onready var close_button = $MenuBox/MarginContainer/VBoxContainer/CloseButton
@onready var sfx_test_player = $SFXTestPlayer

var master_bus_idx: int
var music_bus_idx: int
var sfx_bus_idx: int

func _ready() -> void:
	# Fetch bus indices dynamically
	master_bus_idx = AudioServer.get_bus_index("Master")
	music_bus_idx = AudioServer.get_bus_index("Music")
	sfx_bus_idx = AudioServer.get_bus_index("Sounds") # Sounds corresponds to SFX/Voice in default_bus_layout.tres
	
	# Load current bus volume into sliders (map decibels to linear 0.0 - 1.0)
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_idx))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_idx))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_idx))
	
	# Update labels
	_update_labels()
	
	# Connect signals
	master_slider.value_changed.connect(_on_master_value_changed)
	music_slider.value_changed.connect(_on_music_value_changed)
	
	# For SFX, we also trigger a test sound when the user drags/releases the slider
	sfx_slider.value_changed.connect(_on_sfx_value_changed)
	sfx_slider.drag_ended.connect(_on_sfx_drag_ended)
	
	close_button.pressed.connect(_on_close_button_pressed)
	close_button.mouse_entered.connect(_on_close_button_hover)
	close_button.mouse_exited.connect(_on_close_button_unhover)
	
	# Playful slider hover effects
	master_slider.mouse_entered.connect(_on_slider_hover.bind(master_slider, master_value))
	master_slider.mouse_exited.connect(_on_slider_unhover.bind(master_slider, master_value))
	
	music_slider.mouse_entered.connect(_on_slider_hover.bind(music_slider, music_value))
	music_slider.mouse_exited.connect(_on_slider_unhover.bind(music_slider, music_value))
	
	sfx_slider.mouse_entered.connect(_on_slider_hover.bind(sfx_slider, sfx_value))
	sfx_slider.mouse_exited.connect(_on_slider_unhover.bind(sfx_slider, sfx_value))

func _update_labels() -> void:
	master_value.text = str(round(master_slider.value * 100)) + "%"
	music_value.text = str(round(music_slider.value * 100)) + "%"
	sfx_value.text = str(round(sfx_slider.value * 100)) + "%"

func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_idx, linear_to_db(value))
	# Mute bus completely if slider is 0
	AudioServer.set_bus_mute(master_bus_idx, value == 0.0)
	master_value.text = str(round(value * 100)) + "%"

func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_idx, linear_to_db(value))
	AudioServer.set_bus_mute(music_bus_idx, value == 0.0)
	music_value.text = str(round(value * 100)) + "%"

func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_idx, linear_to_db(value))
	AudioServer.set_bus_mute(sfx_bus_idx, value == 0.0)
	sfx_value.text = str(round(value * 100)) + "%"

func _on_sfx_drag_ended(_value_changed: bool) -> void:
	# Play test sound on Sounds bus to preview SFX volume
	if sfx_test_player != null and sfx_slider.value > 0.0:
		sfx_test_player.play()

func _on_close_button_pressed() -> void:
	# Play close tween or hide the menu
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.finished.connect(queue_free)

func _on_close_button_hover() -> void:
	close_button.pivot_offset = close_button.size / 2
	var tween = create_tween().set_parallel(true)
	tween.tween_property(close_button, "scale", Vector2(1.05, 1.05), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(close_button, "rotation_degrees", 1.5, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_close_button_unhover() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(close_button, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(close_button, "rotation_degrees", 0.0, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_slider_hover(slider: HSlider, val_label: Label) -> void:
	val_label.pivot_offset = val_label.size / 2
	slider.pivot_offset = slider.size / 2
	var tween = create_tween().set_parallel(true)
	tween.tween_property(val_label, "scale", Vector2(1.2, 1.2), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(slider, "scale", Vector2(1.02, 1.02), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_slider_unhover(slider: HSlider, val_label: Label) -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(val_label, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(slider, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

``


## File: scripts/SpectatorCamControl.gd

``gdscript
extends Camera3D
class_name SpectatorController

@export var move_speed: float = 5.0
@export var mouse_sensitve: float = 0.05

func _input(event: InputEvent) -> void:
	# 1. Only rotate the camera if it's currently active AND the Right Mouse Button is held down
	if current and event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		
		# Rotate left/right
		rotation.y -= event.relative.x * mouse_sensitve
		
		# Rotate up/down
		rotation.x -= event.relative.y * mouse_sensitve
		
		# Clamp the up/down rotation so the camera doesn't flip completely upside down
		rotation.x = clamp(rotation.x, -PI/2, PI/2)

func _process(delta: float) -> void:
	# 2. Don't process movement if we are currently looking through the 1st-Person Dummy camera!
	if not current:
		return

	var direction = Vector3.ZERO
	
	# 3. WASD Key Input mapping
	if Input.is_physical_key_pressed(KEY_W):
		direction -= transform.basis.z
	if Input.is_physical_key_pressed(KEY_S):
		direction += transform.basis.z
	if Input.is_physical_key_pressed(KEY_A):
		direction -= transform.basis.x
	if Input.is_physical_key_pressed(KEY_D):
		direction += transform.basis.x
		
	# Fly Up and Down (E to go up, Q to go down)
	if Input.is_physical_key_pressed(KEY_E):
		direction += transform.basis.y
	if Input.is_physical_key_pressed(KEY_Q):
		direction -= transform.basis.y
		
	# Normalize to prevent moving twice as fast when pressing two keys diagonally
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		
	# 4. Apply the movement safely using delta time
	global_position += direction * move_speed * delta
	

``


## File: scripts/SpectatorDashboard.gd

``gdscript
extends Control

@export var settings_menu_scene: PackedScene
@export var progress_menu_scene: PackedScene

@onready var welcome_label = $MenuBox/MarginContainer/VBoxContainer/WelcomeLabel
@onready var settings_btn = $MenuBox/MarginContainer/VBoxContainer/ButtonsContainer/SettingsButton
@onready var progress_btn = $MenuBox/MarginContainer/VBoxContainer/ButtonsContainer/ProgressButton
@onready var logout_btn = $MenuBox/MarginContainer/VBoxContainer/ButtonsContainer/LogoutButton

func _ready() -> void:
	# Update welcome text dynamically from session data
	if SessionData.fullName != "":
		welcome_label.text = "Xin chào, " + SessionData.fullName + "! 👋"
	else:
		welcome_label.text = "Xin chào Người giám sát! 👋"
		
	# Connect signals
	settings_btn.pressed.connect(_on_settings_pressed)
	settings_btn.mouse_entered.connect(_on_button_hover.bind(settings_btn))
	settings_btn.mouse_exited.connect(_on_button_unhover.bind(settings_btn))
	
	progress_btn.pressed.connect(_on_progress_pressed)
	progress_btn.mouse_entered.connect(_on_button_hover.bind(progress_btn))
	progress_btn.mouse_exited.connect(_on_button_unhover.bind(progress_btn))
	
	logout_btn.pressed.connect(_on_logout_pressed)
	logout_btn.mouse_entered.connect(_on_button_hover.bind(logout_btn))
	logout_btn.mouse_exited.connect(_on_button_unhover.bind(logout_btn))

func _on_settings_pressed() -> void:
	if settings_menu_scene:
		var settings_instance = settings_menu_scene.instantiate()
		add_child(settings_instance)
	else:
		printerr("Settings Menu Scene is not assigned!")

func _on_progress_pressed() -> void:
	if progress_menu_scene:
		var progress_instance = progress_menu_scene.instantiate()
		add_child(progress_instance)
		
		# Set some default mock progress for the initial load if the data isn't set yet
		# In production, this can be synced with real time student progress values
		if progress_instance.has_method("set_progress"):
			progress_instance.set_progress(4, 10)
	else:
		printerr("Progress Menu Scene is not assigned!")

func _on_logout_pressed() -> void:
	# Clear session data
	SessionData.accessToken = ""
	SessionData.refreshToken = ""
	SessionData.userId = 0
	SessionData.fullName = ""
	SessionData.userName = ""
	SessionData.roleName = ""
	SessionData.isActive = false
	
	print_debug("Spectator Logged Out Successfully")
	
	# Transition back to the main Authentication Scene
	get_tree().change_scene_to_file("res://Prefabs/SpectatorPrefabs/AuthScene.tscn")

# Kids playful micro-animations (scale & tilt on hover)
func _on_button_hover(btn: Button) -> void:
	btn.pivot_offset = btn.size / 2
	var tween = create_tween().set_parallel(true)
	tween.tween_property(btn, "scale", Vector2(1.04, 1.04), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(btn, "rotation_degrees", 1.2, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_button_unhover(btn: Button) -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(btn, "rotation_degrees", 0.0, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

``


## File: scripts/SpectatorManager.gd

``gdscript
extends Node
class_name SpectatorManager

@export var dummyScene : PackedScene
@export var playerAudio : AudioStreamPlayer
@export var timeSlider : HSlider

@onready var playPauseButton = $"Control/MarginContainer/HBoxContainer/Play_Pause Button"
@onready var forward_button: Button = $"Control/MarginContainer/HBoxContainer/Forward Button"
@onready var backward_button: Button = $"Control/MarginContainer/HBoxContainer/Backward Button"
@onready var timeline_slider: HSlider = $"Control/MarginContainer/HBoxContainer/Timeline Slider"
@onready var toggle_view_button: Button = $Control/ToggleViewButton

var replay_data: Dictionary = {}
var is_playing: bool = false
var playback_time: float = 0.0
var frame_duration: float = 0.1 
var max_duration: float = 0.0
var active_dummy: Node3D = null

func _ready() -> void:
	load_spectator_data()


func _process(delta: float) -> void:
	if not is_playing:
		return
		
	# 3. Master Clock: Sync timeline to the audio hardware track
	if playerAudio.playing:
		playback_time = playerAudio.get_playback_position()
	else:
		playback_time += delta
		
	# 4. Update the visual UI slider
	timeSlider.value = playback_time
	
	# 5. Move the 3D models
	render_frame_at_time(playback_time)
	
	# 6. Stop when we reach the end
	if playback_time >= max_duration:
		is_playing = false
		playerAudio.stop()
		playback_time = max_duration
		timeSlider.value = max_duration
		playPauseButton.text = "Play"

func load_spectator_data() -> void:
	# --- LOAD JSON ---
	if FileAccess.file_exists(SessionData.target_replay_path):
		var file = FileAccess.open(SessionData.target_replay_path, FileAccess.READ)
		var parsed = JSON.parse_string(file.get_as_text())
		file.close()
		
		if parsed != null:
			replay_data = parsed["frames"]
			max_duration = int(parsed["metadata"]["total_recorded_frames"]) * frame_duration
			
			# Configure the UI Slider
			timeSlider.max_value = max_duration
			timeSlider.step = 0.01
			
			# Spawn the 3D Dummy Clone
			if active_dummy: active_dummy.queue_free()
			active_dummy = dummyScene.instantiate()
			add_child(active_dummy)
			active_dummy.global_position = Vector3(28,9,0)
			
	# --- LOAD WAV (With 44-byte Bypass) ---
	if FileAccess.file_exists(SessionData.target_audio_path):
		var file = FileAccess.open(SessionData.target_audio_path, FileAccess.READ)
		var bytes = file.get_buffer(file.get_length())
		file.close()
		
		var wav_stream = AudioStreamWAV.new()
		wav_stream.format = AudioStreamWAV.FORMAT_16_BITS
		wav_stream.mix_rate = int(AudioServer.get_mix_rate())
		wav_stream.stereo = true
		
		# Slice the text header off the raw bytes to prevent audio static!
		wav_stream.data = bytes.slice(44) 
		playerAudio.stream = wav_stream

func render_frame_at_time(time_sec: float) -> void:
	if replay_data.is_empty() or active_dummy == null:
		return
		
	# 1. Calculate exactly where we are between two frames
	var exact_frame: float = time_sec / frame_duration
	var current_idx: int = floor(exact_frame)
	var next_idx: int = current_idx + 1
	var lerp_factor: float = exact_frame - current_idx
	
	var curr_key: String = str(current_idx)
	var next_key: String = str(next_idx)
	
	if not replay_data.has(curr_key):
		return
		
	# 2. Smoothly Lerp between the current frame and the next frame
	for node_name in replay_data[curr_key].keys():
		var dummy_part = active_dummy.get_node_or_null(node_name)
		if dummy_part:
			var curr_pos_raw = replay_data[curr_key][node_name]["position"]
			var curr_rot_raw = replay_data[curr_key][node_name]["rotation"]
			var curr_pos = Vector3(curr_pos_raw["x"], curr_pos_raw["y"], curr_pos_raw["z"])
			var curr_rot = Vector3(curr_rot_raw["x"], curr_rot_raw["y"], curr_rot_raw["z"])
			
			if replay_data.has(next_key) and replay_data[next_key].has(node_name):
				var next_pos_raw = replay_data[next_key][node_name]["position"]
				var next_rot_raw = replay_data[next_key][node_name]["rotation"]
				var next_pos = Vector3(next_pos_raw["x"], next_pos_raw["y"], next_pos_raw["z"])
				var next_rot = Vector3(next_rot_raw["x"], next_rot_raw["y"], next_rot_raw["z"])
				
				dummy_part.global_position = curr_pos.lerp(next_pos, lerp_factor)
				dummy_part.global_rotation = curr_rot.lerp(next_rot, lerp_factor)
			else:
				# If we are at the very last frame, just snap to it
				dummy_part.global_position = curr_pos
				dummy_part.global_rotation = curr_rot

func _input(event: InputEvent) -> void:
	# Press SPACEBAR to quickly play/pause the replay while testing
	if event.is_action_pressed("ui_accept"): 
		if is_playing:
			is_playing = false
			playerAudio.stop()
			playPauseButton.text = "Play"
		else:
			is_playing = true
			playerAudio.play(playback_time)
			playPauseButton.text = "Pause"

func _on_timeline_slider_drag_ended(value_changed: bool) -> void:
	playback_time = timeSlider.value
	render_frame_at_time(playback_time) # Instantly snap graphics to new time
	is_playing = true
	playerAudio.play(playback_time)      # Resume audio from new time


func _on_timeline_slider_drag_started() -> void:
	is_playing = false 
	playerAudio.stop()	
	# Force the play button to pop back up without triggering the signal again
	playPauseButton.set_pressed_no_signal(false)
	playPauseButton.text = "Play"




func _on_play_pause_button_pressed() -> void:
	if playback_time >= max_duration - 0.01:
		playback_time = 0.0
		timeSlider.value = 0.0
	is_playing = !is_playing
	if is_playing : 
		playback_time = timeSlider.value
		render_frame_at_time(playback_time) # Instantly snap graphics to new time
		playerAudio.play(playback_time)      # Resume audio from new time
		playPauseButton.text = "Pause"
	else :
		playerAudio.stop()    # Resume audio from new time
		playPauseButton.text = "Play"
	

func _on_backward_button_pressed() -> void:
	#Use clamp for safe slider calculation
	playback_time = clamp(timeSlider.value - 0.5, 0.0, max_duration)
	timeSlider.value = playback_time
	render_frame_at_time(playback_time)

	if is_playing == true:
		playerAudio.play(playback_time)


func _on_forward_button_pressed() -> void:
	playback_time = clamp(timeSlider.value + 0.5, 0.0, max_duration)
	timeSlider.value = playback_time
	render_frame_at_time(playback_time)
	if is_playing == true:
		playerAudio.play(playback_time)

func _on_toggle_view_button_pressed() -> void:
	var freeCam = $SpectatorCam
	if active_dummy == null:
		return
	var dummyCam = active_dummy.find_child("FPVCam",true,false)
	if dummyCam == null:
		return
	if freeCam.current:
		# If we are in 3rd person, switch TO 1st person
		dummyCam.make_current()
		toggle_view_button.text = "Switch to 3rd Person"
		print("View: 1st Person")
	else:
		 # If we are in 1st person, switch TO 3rd person
		freeCam.make_current()
		toggle_view_button.text = "Switch to 1st Person"
		print("View: 3rd Person (Free Cam)")
		

``


## File: scripts/teleport_area.gd

``gdscript
extends Area3D

#Targer scene name
@export_file("*.tscn") var target_scene: String

@export_category("Puzzle Logic")
@export var require_unlock: bool = false
@export var portalMesh: MeshInstance3D
@export var portalAudio: AudioStreamPlayer3D
@export var successSound: AudioStream
@export var errorSound: AudioStream
@export var holoText : String = "Teleport Area"

@onready var label = $TextRingMesh/SubViewport/Label 

var isUnlocked : bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	label.text = holoText
	
	if require_unlock:
		# Initialize portal to RED (locked)
		_set_portal_color(Color(1.0, 0.0, 0.0, 0.3)) # Red
	else:
		# Automatically unlocked!
		isUnlocked = true
		_set_portal_color(Color(0.0, 0.0, 1.0, 0.3)) # Blue

func _on_body_entered(_body: Node3D) -> void:
	var playerBody := _body as XRToolsPlayerBody
	if not playerBody:
		return	
		
	if isUnlocked:
		# Portal is active, teleport the player!
		print("Portal Success! Loading target scene...")
		if portalAudio and successSound:
			portalAudio.stream = successSound
			portalAudio.play()
			
		if not target_scene or target_scene == "":
		
			return
		#Find the XRToolsSceneBase is a child node of 
		var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
		if not scene_base:
			return
			
		#Freeze player movement when enter teleport
		var movementNode = get_tree().get_nodes_in_group("movement_providers")
		for node in movementNode:
			if "enabled" in node:
				node.enabled = false

		#Start loading scene
		scene_base.load_scene(target_scene)
	else:
		# Portal is locked, play error sound
		print("Portal is locked! Cannot enter.")
		if portalAudio and errorSound:
			portalAudio.stream = errorSound
			portalAudio.play()

## Call this function from the Basket Trigger (e.g. via Signal connection)
func unlock_portal() -> void:
	if isUnlocked:
		return
		
	print("Portal Unlocked!")
	isUnlocked = true
	
	# Change color to BLUE
	_set_portal_color(Color(0.0, 0.0, 1.0, 0.3)) # Blue

func _set_portal_color(color: Color) -> void:
	if not portalMesh:
		return
		
	# Get the actual material currently on the mesh
	var mat = portalMesh.get_active_material(0)
	if not mat:
		return
		
	# Duplicate the material and set it as an override so we only change THIS specific portal's color
	if not portalMesh.material_override:
		portalMesh.material_override = mat.duplicate()
		mat = portalMesh.material_override
		
	# Now change the color based on the type of material
	if mat is StandardMaterial3D:
		mat.albedo_color = color
		mat.emission_enabled = true
		mat.emission = color
	elif mat is ShaderMaterial:
		# I noticed in your screenshot your shader uses 'hologram_color' instead of 'albedo'!
		mat.set_shader_parameter("hologram_color", color)
		# Optional: Also change scanline color if you want it to match
		# mat.set_shader_parameter("scanline_color", color)



func _on_basket_trigger_puzzle_solved() -> void:
	unlock_portal()

``


## File: scripts/text_ring_mesh.gd

``gdscript
extends MeshInstance3D

@export var spin_speed: float = 1.0

func _process(delta: float) -> void:
	# Rotates the text cylinder smoothly around the Y-axis over time
	rotate_y(spin_speed * delta)

``


## File: scripts/UnFreezePickable.gd

``gdscript
extends Node

# This grabs the XRToolsPickable node that is sitting above this node                                                                                                                                                        
@onready var pickable_parent = get_parent()                                                                                                                                                                                  
                                                                                                                                                                                                                                 
func _ready():                                                                                                                                                                                                               
	# We listen to the parent to tell us when it gets picked up
	pickable_parent.dropped.connect(_on_parent_dropped)
                                                                                                                                                                                                                                 
func _on_parent_dropped(pickable):                                                                                                                                                                                         
    # Tell the parent to permanently turn off its freeze property
	pickable_parent.freeze = false
``


## File: scripts/VoiceCommandHandler.cs

``csharp
using Godot;
using System;
using System.Collections.Generic;
using System.Xml;
 public partial class VoiceCommandHandler : Node                                                                                                                                                                              
	{                                                                                                                                                                                                                            
		[Export] public Node3D targetDoor;                                                                                                                                                                                          
																																																									
		private Dictionary<string, string> _vocab = new Dictionary<string, string>                                                                                                                                                  
		{                                                                                                                                                                                                                           
			{"mở cửa", "open_door"},                                                                                                                                                                                                    
			{"đóng cửa", "close_door"}                                                                                                                                                                                                  
		};                                                                                                                                                                                                                          
																																																								 
		public override void _Ready()                                                                                                                                                                                               
		{                                                                                                                                                                                                                           
			if (AzureSpeechManager.Instance != null) {                                                                                                                                                                                  
				AzureSpeechManager.Instance.OnSpeechRecognized += HandleSpeech;                                                                                                                                                             
			}                                                                                                                                                                                                                           
		}                                                                                                                                                                                                                           
																																																								 
		private void HandleSpeech(string rawText)                                                                                                                                                                                   
		{                                                                                                                                                                                                                           
			foreach (var kvp in _vocab)                                                                                                                                                                                                 
			{                                                                                                                                                                                                                           
				if (rawText.ToLower().Contains(kvp.Key))                                                                                                                                                                                    
				{                                                                                                                                                                                                                           
					ExecuteAction(kvp.Value);                                                                                                                                                                                                   
					break;                                                                                                                                                                                                                      
				}                                                                                                                                                                                                                           
			}                                                                                                                                                                                                                           
		}                                                                                                                                                                                                                           
																																																								 
		private void ExecuteAction(string actionId)                                                                                                                                                                                 
		{                                                                                                                                                                                                                           
			if (targetDoor == null) return;                                                                                                                                                                                             
			AnimationPlayer animPlayer = targetDoor.GetNodeOrNull<AnimationPlayer>("AnimationPlayer");                                                                                                                                  
			if (animPlayer == null) return;                                                                                                                                                                                             
																																																								 
			if (actionId == "open_door") animPlayer.Play("open");                                                                                                                                                                       
			if (actionId == "close_door") animPlayer.Play("close");                                                                                                                                                                     
		}                                                                                                                                                                                                                           
																																																								 
		public override void _ExitTree()                                                                                                                                                                                            
		{                                                                                                                                                                                                                           
			if (AzureSpeechManager.Instance != null) {                                                                                                                                                                                  
				AzureSpeechManager.Instance.OnSpeechRecognized -= HandleSpeech;                                                                                                                                                             
			}                                                                                                                                                                                                                           
		}                                                                                                                                                                                                                           
	}                              

``


## File: scripts/VoiceCommandHandler.gd

``gdscript
extends Node

@export var doorCommand: Array[String]
@export var speechManager : Node
@export var recordButton : Button

signal doorCommandOpen
signal doorCommandClose
var assignWord: String = ""
func _ready() -> void:
	if(speechManager == null):
		printerr("Node not found, make sure to assign it!!")
		return
	

	recordButton.focus_mode = Control.FOCUS_NONE
	
	if not recordButton.pressed.is_connected(_on_button_pressed):
		recordButton.pressed.connect(_on_button_pressed)
	
	if speechManager:
		speechManager.connect("OnSpeechRecognized", Callable(self, "_on_speech_recognized"))
		speechManager.connect("OnSpeechFailed", Callable(self, "_on_speech_failed"))
	else:
		printerr("ERROR: AzureSpeechManager signal not found!")

func _on_button_pressed() -> void:
	recordButton.disabled = true;
	speechManager.StartListening()

func _on_speech_recognized(text: String) -> void:
	recordButton.disabled = false
	var resultWord = text.to_lower() 
	var foundMatch = false
	
	for targetWord in doorCommand:
		var target_lower = targetWord.to_lower()
		
		if resultWord.contains(target_lower):
			foundMatch = true
			if target_lower.contains("mở cửa"):
				doorCommandOpen.emit()
			elif target_lower.contains("đóng cửa"):
				doorCommandClose.emit()
			break 
	if foundMatch:
		recordButton.modulate = Color.GREEN
	else:
		recordButton.modulate = Color.RED

func _on_speech_failed(reason:String) -> void:
	recordButton.disabled = false
	recordButton.modulate = Color.YELLOW
``


## File: scripts/welcomeScript.gd

``gdscript
extends Control

@onready var welcomeLabel = $"../LoginBox/VBoxContainer/Label2"
func _ready() -> void:
	welcomeLabel.text ="Welcome "+ SessionData.userName

``


