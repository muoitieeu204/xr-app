extends Node3D

func _on_area_3d_body_entered(_body: Node3D) -> void:
	if _body is CharacterBody3D:
		$AnimationPlayer.play("Open")


func _on_area_3d_body_exited(_body: Node3D) -> void:                                                                                                                                                               
	if _body is CharacterBody3D:
		$AnimationPlayer.play("Close")                                                                                                                                                                             
		get_tree().call_group("LevelController", "FinishLevel")                                                                                                                                                        
											  
