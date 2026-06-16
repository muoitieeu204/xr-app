extends Node3D


@onready var animation_player = $AnimationPlayer
var is_open = false

# This function runs when the door hears the button's signal

func _on_interactable_area_button_button_pressed(button: Variant) -> void:
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
	

func _on_voice_command_handler_door_command_open() -> void:
	open_door()


func _on_voice_command_handler_door_command_close() -> void:
	close_door()
