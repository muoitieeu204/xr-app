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
		
