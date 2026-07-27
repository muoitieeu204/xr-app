extends Node

@export var uiViewport: Node3D

func _process(delta: float) -> void:
	if uiViewport == null:
		return

	var camera = get_viewport().get_camera_3d()
	if camera == null:
		return

	var direction_to_eyes = (camera.global_position - uiViewport.global_position).normalized()
	var ui_facing_direction = uiViewport.global_transform.basis.z
	var alignment = ui_facing_direction.dot(direction_to_eyes)
	if alignment > 0.5:
		uiViewport.visible = true
	else:
		uiViewport.visible = false