extends Area3D

func _on_body_entered(body: Node3D) -> void:
	get_tree().call_group("FishingLevelController", "FinishLevel")
