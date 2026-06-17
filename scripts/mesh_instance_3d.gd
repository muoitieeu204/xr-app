extends MeshInstance3D

var scrollSpeed: float = 0.25

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if material_override != null:
		material_override.uv1_offset.x += scrollSpeed * delta
