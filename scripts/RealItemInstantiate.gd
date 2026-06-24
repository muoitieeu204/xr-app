extends Area3D                                                                                                                                                                                                         
                                                                                                                                                                                                                           
@export var realItem : PackedScene                                                                                                                                                                                     
                                                                                                                                                                                                                           
    # 1. Godot XR Tools checks this to see if it's allowed to grab it                                                                                                                                                      
func can_pick_up(by: Node3D) -> bool:                                                                                                                                                                                  
	return true                                                                                                                                                                                                           

func request_highlight(by: Node3D, enable: bool) -> void:
	pass

    # 2. Godot XR Tools automatically calls this when you press the Grab Button!                                                                                                                                           
func pick_up(by: Node3D) -> void:                                                                                                                                                                                      
        # Spawn the real item                                                                                                                                                                                                 
	var realItemInstance = realItem.instantiate()                                                                                                                                                                         
	get_tree().current_scene.add_child(realItemInstance)                                                                                                                                                                  
	realItemInstance.global_transform = global_transform
        # Trick the VR Hand into holding the Real Item instead of this fake one
	by.picked_up_object = realItemInstance
	realItemInstance.pick_up(by)    
        # Delete the fake item
	queue_free()