@tool
extends XRToolsSceneBase

var xr_interface: XRInterface

#func _ready():
	#xr_interface = XRServer.find_interface("OpenXR")
	#if xr_interface and xr_interface.is_initialized():
		#print("OpenXR initialise successfully")
		#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		#
		#get_viewport().use_xr = true
	#else:
		#print("OpenXR not initalise, please check if your headset is connected")

func _input(event):
	# Dynamically search the scene for these nodes right when the key is pressed
	# find_child(name, recursive, owned)
	var replayer = find_child("Replayer", true, false)
	var mic_controller = find_child("MicController", true, false)

	if event.is_action_pressed("record"):
		if replayer and mic_controller:
			print("Start recording telemetry and audio")
			replayer.start_recording_session()
			mic_controller.start_record()
		else:
			print("Could not record: Player nodes not found (Are you in Spectator mode?)")
	
	if event.is_action_pressed("stop"):
		if mic_controller:
			print("Stop recording telemetry and audio")
			mic_controller.stop_record_and_save()
			
	if event.is_action_pressed("play"):
		if replayer:
			print("Playing back animation...")
			replayer.load_and_play_session()
	
	# if event.is_action_pressed("ui_accept"):
	# 	test_the_upload()
	
# func test_the_upload() -> void:
# 	print("Trigger upload function...")
# 	var jsonPath = "user://temp_replay_2026-06-03T23-05-10.json"
# 	var audioPath = "user://player_audio_2026-06-06T00-39-55.wav"
	
# 	# Call the uploader node using get_node_or_null to prevent crashes if it's missing
# 	var test_node = get_node_or_null("/root/SessionUploader")
# 	if test_node:
# 		test_node.UploadSessionDataAsync(jsonPath, audioPath)
# 	else: 
# 		print("Error: Cannot find SessionUploader node")
