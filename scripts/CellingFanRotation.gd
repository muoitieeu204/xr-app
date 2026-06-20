extends Node3D

@export var rotationSpeed : float = 3.0

func _process(delta: float) -> void:
	rotate_y(rotationSpeed * delta )	
