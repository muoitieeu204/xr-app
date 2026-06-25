extends Area3D

@export var realItem : PackedScene
@export var item_id : String = ""
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

	#Tell GameManager to start the STT check
	var gameManger = get_node_or_null("/root/GameManager")
	if gameManger:
		print("DEBUG: Found GameManager! Sending item info...")
		var final_id = item_id if item_id != "" else self.name
		# If Godot added numbers to the end of the name (e.g., CartonSmall2), strip them out just in case!
		final_id = final_id.rstrip("0123456789")
		gameManger._item_pickup(final_id)
		
		# Listen for when the player drops the REAL item
		if realItemInstance.has_signal("dropped"):
			realItemInstance.connect("dropped", Callable(gameManger, "_item_dropped"))
	else:
		print("DEBUG: ERROR - GameManager NOT FOUND at /root/GameManager!")

	# Delete the fake item
	queue_free()
