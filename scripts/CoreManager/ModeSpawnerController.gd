extends Marker3D
class_name GameModeSpawner

@export var playerNode: PackedScene
@export var spectatorUI: PackedScene
var worldScene: String 

func _ready() -> void:
	if owner!= null	:
		SessionData.target_scene_path = owner.scene_file_path
	var instance_to_spawn: Node
	# Check the state. (Make sure your variable name here matches SessionData exactly!)
	if SessionData.is_spectator:
		instance_to_spawn = spectatorUI.instantiate()
		print("Mode: Spectator")
	else:
		instance_to_spawn = playerNode.instantiate()
		print("Mode: Player")
		var cam = instance_to_spawn.find_child("XRCamera3D", true, false)
		var leftHand = instance_to_spawn.find_child("LeftController",true,false)
		var rightHand = instance_to_spawn.find_child("RightController", true,false)
		ReplayManager.replayer.recorded_objects.assign([cam, leftHand, rightHand])

	# Safely add the chosen mode to the world
	get_parent().call_deferred("add_child", instance_to_spawn)
	await get_tree().process_frame
	
	if instance_to_spawn is Node3D:
	# Snap the player/spectator to this Marker's exact position and rotation
		instance_to_spawn.global_transform = self.global_transform
	
	# The spawner has done its job, so it can delete itself
	queue_free()
