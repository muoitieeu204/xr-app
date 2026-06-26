extends Area3D

@export var realItem : PackedScene
@export var itemId : String = ""
@export var itemIcon : Texture2D
@export var hintAudio : AudioStream

	# 1. Godot XR Tools checks this to see if it's allowed to grab it                                                                                                                                                      
func can_pick_up(by: Node3D) -> bool:                                                                                                                                                                                  
	return true                                                                                                                                                                                                           

func request_highlight(by: Node3D, enable: bool) -> void:
	pass

	# 2. Godot XR Tools automatically calls this when you press the Grab Button!                                                                                                                                           
func pick_up(by: Node3D) -> void:                                                                                                                                                                                      
	print("DEBUG: Fake item grabbed! Spawning real item...")
	# Spawn the real item                                                                                                                                                                                                 
	var realItemInstance = realItem.instantiate()                                                                                                                                                                         
	get_tree().current_scene.add_child(realItemInstance)                                                                                                                                                                  
	realItemInstance.global_transform = global_transform
	# Trick the VR Hand into holding the Real Item instead of this fake one
	by.picked_up_object = realItemInstance
	realItemInstance.pick_up(by)

	# INJECT METADATA INTO THE REAL ITEM
	var final_id = itemId if itemId != "" else self.name
	final_id = final_id.rstrip("0123456789")
	realItemInstance.set_meta("itemId", final_id)
	realItemInstance.set_meta("hintAudio", hintAudio)

	# Delete the fake item
	queue_free()
