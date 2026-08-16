extends Area3D

@export var hint_text: String = ""

func _on_body_entered(body: Node3D) -> void:
	GameManager.hint_updated.emit(hint_text)


func _on_body_exited(body: Node3D) -> void:
	GameManager.hint_updated.emit("")
