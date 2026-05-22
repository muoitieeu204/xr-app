extends Node3D
@onready var replayer: Node = $Replayer

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
