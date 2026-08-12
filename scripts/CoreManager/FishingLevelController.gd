@tool
extends XRToolsSceneBase

@export var catchable_items: Array[PackedScene]

func spawn_item(spawn_position: Vector3):
	if catchable_items.is_empty():
		push_warning("No catchable items assigned in the FishinLevelController");
		return
	var random_item_scene = catchable_items.pick_random()
	var item_instance = random_item_scene.instantiate()
	get_tree().root.add_child(item_instance)
	item_instance.global_position = spawn_position
	print("Item spawned: ", item_instance.name)

	

