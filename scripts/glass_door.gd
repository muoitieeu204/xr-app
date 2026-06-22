extends Node3D

func _on_area_3d_body_entered(_body: Node3D) -> void:
	$AnimationPlayer.play("Open")


func _on_area_3d_body_exited(_body: Node3D) -> void:                                                                                                                                                               
	if $Area3D.get_overlapping_bodies().size() == 0:                                                                                                                                                                         
		$AnimationPlayer.play("Close")                                                                                                                                                                                       
                                              
