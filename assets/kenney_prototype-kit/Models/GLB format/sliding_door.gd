extends Node3D


@onready var animation_player = $AnimationPlayer
var is_open = false

# This function runs when the door hears the button's signal
func _on_button_pressed(_button):
	if not is_open:
		open_door()

func open_door():
	is_open = true
	print("Signal received! Playing sliding door animation...")
	
	# Make sure "open" exactly matches the animation name in your AnimationPlayer!
	animation_player.play("close")
