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
	