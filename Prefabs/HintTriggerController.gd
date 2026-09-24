extends Area3D

@export var hint_text: String = ""

func _on_body_entered(body: Node3D) -> void:
	GameManager.hint_updated.emit(hint_text)
	if ($RadarSound == null):
		push_warning("Missing hint child node!!")
		return
	$RadarSound.play()

func _on_body_exited(body: Node3D) -> void:
	GameManager.hint_updated.emit("")
	if ($RadarSound== null):
		push_warning("Missing hint child node!!")
		return
	$RadarSound.stop()