extends Marker3D

@export var spawnPoint : Marker3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player_body"):
		body.global_position = spawnPoint.global_position
