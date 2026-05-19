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
