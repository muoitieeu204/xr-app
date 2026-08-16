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
