extends Node

func _on_body_entered(body: Node3D) -> void:
	if body is XRToolsPlayerBody:
		print("Player entered the finish zone! Ending level...")
		get_tree().call_group("ExerciseLevelController", "FinishLevel")
