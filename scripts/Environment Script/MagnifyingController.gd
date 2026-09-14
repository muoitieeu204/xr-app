extends Node

func _on_search_area_entered(body: Area3D):
	if not body.visible:
		body.visible = true
		body.collision_layer = 4
