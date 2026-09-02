extends Node3D

@export var spawn_object: Array[PackedScene]
@export var spawn_pos: Array[Vector3]

func _spawn():
	for i in range(spawn_object.size()):
		var obj = spawn_object[i]
		var spawn = obj.instantiate() as Node3D
		add_child(spawn)
		if i < spawn_pos.size():
			spawn.position = spawn_pos[i]
		else:
			spawn.position = Vector3(i * 2.0, 0, 0)
			

func spawn_item(scene: PackedScene) -> Node3D:
	if scene == null:
		push_warning("Cannot spawn null PackedScene!")
		return
	
	var instance = scene.instantiate() as Node3D
	add_child(instance)
	instance.global_position = global_position
	return instance