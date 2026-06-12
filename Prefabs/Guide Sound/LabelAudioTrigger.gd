extends Label3D

@export var audioFile : AudioStreamPlayer3D



func _on_area_3d_body_entered(_body: Node3D) -> void:
	if not audioFile.playing:
		audioFile.play()
