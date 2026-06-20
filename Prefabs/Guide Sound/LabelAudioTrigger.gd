extends Label3D

@export var audioFile : AudioStreamPlayer3D



func _on_area_3d_body_entered(_body: Node3D) -> void:
	# 1. Stop all other voice lines
	get_tree().call_group("VoiceLines", "stop")
	
	# 2. Play this new speaker
	if audioFile != null:
		audioFile.play()
	else:
		$AudioStreamPlayer3D.play()
	
