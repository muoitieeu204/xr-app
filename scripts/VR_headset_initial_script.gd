extends Node3D
@onready var replayer: ReplayController = $PlayerXR/ReplayManager/Replayer
@onready var mic_controller: MicController = $PlayerXR/ReplayManager/MicController


var xr_interface : XRInterface

func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialise successfully")
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
		get_viewport().use_xr = true
	else:
		print("OpenXR not initalise, please check if your headset is connected")

func _input(event):
	if event.is_action_pressed("record"):
		print("Start recording telementry and audio ")
		replayer.start_recording_session()
		mic_controller.start_record()
	
	if event.is_action_pressed("stop"):
		print("Stop recording telementry and audio")
		replayer.stop_and_save_session()
		mic_controller.stop_record_and_save()
		
	if event.is_action_pressed("play"):
		print("Playing back animation...")
		replayer.load_and_play_session()
