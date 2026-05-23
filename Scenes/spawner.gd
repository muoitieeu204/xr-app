extends Node3D

@export var spawn_object: Array[PackedScene]
@export var spawn_pos : Array[Vector3]
# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn()

func _spawn():
	for i in range(spawn_object.size()):
		var obj = spawn_object[i]
		var spawn = obj.instantiate() as Node3D
		add_child(spawn)
		if i < spawn_pos.size():
			spawn.position= spawn_pos[i]
		else :
			spawn.position = Vector3(i * 2.0, 0 , 0)
			
