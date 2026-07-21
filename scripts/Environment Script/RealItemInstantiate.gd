@tool
extends XRToolsInteractableArea

@export var realItem : PackedScene
@export var itemName : String = ""
@export var itemNameSound : AudioStream
@export var hintAudios : Array[AudioStream] = []        
	
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
	realItemInstance.set_meta("itemName", itemName)
	realItemInstance.set_meta("itemNameSound", itemNameSound)
	realItemInstance.set_meta("hintAudios", hintAudios)

	if itemNameSound:
		var audioPlayer = AudioStreamPlayer3D.new()
		audioPlayer.stream = itemNameSound
		realItemInstance.add_child(audioPlayer)
		audioPlayer.bus = "Sounds"
		audioPlayer.play()
	# Delete the fake item
	queue_free()
