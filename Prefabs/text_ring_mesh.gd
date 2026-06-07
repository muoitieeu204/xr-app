extends MeshInstance3D

@export var spin_speed: float = 1.0

func _process(delta: float) -> void:
	# Rotates the text cylinder smoothly around the Y-axis over time
	rotate_y(spin_speed * delta)
