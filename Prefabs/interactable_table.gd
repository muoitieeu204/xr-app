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
