@tool
extends Node3D

@export var item_scene: PackedScene:
	set(val):
		item_scene = val
		update_multimesh()

@export var item_count: int = 5:
	set(val):
		item_count = val
		update_multimesh()

@export var spacing: Vector3 = Vector3(-0.2, 0, 0):
	set(val):
		spacing = val
		update_multimesh()

@export var mesh_scale: Vector3 = Vector3(0.01, 0.01, 0.01):
	set(val):
		mesh_scale = val
		update_multimesh()

@export var mesh_rotation: Vector3 = Vector3(0, 0, 0): # Rotation in DEGREES
	set(val):
		mesh_rotation = val
		update_multimesh()

@onready var multi_mesh = $MultiMeshInstance3D

func _ready():
	update_multimesh()
	
	if not Engine.is_editor_hint() and item_scene != null:
		for i in range(item_count):
			var local_pos = spacing * i
			var interactive_item = item_scene.instantiate()
			add_child(interactive_item)
			interactive_item.position = local_pos
			
			for child in interactive_item.get_children():
				if child is MeshInstance3D:
					child.queue_free()
			
			interactive_item.set_meta("multimesh_id", i)

func update_multimesh():
	if not is_inside_tree(): return
	if multi_mesh == null: multi_mesh = get_node_or_null("MultiMeshInstance3D")
	if multi_mesh == null or multi_mesh.multimesh == null: return
	
	multi_mesh.multimesh.instance_count = item_count
	
	var rad_rot = mesh_rotation * (PI / 180.0)
	var scaled_basis = Basis.from_euler(rad_rot).scaled(mesh_scale)
	
	for i in range(item_count):
		var local_pos = spacing * i
		var final_transform = Transform3D(scaled_basis, local_pos)
		multi_mesh.multimesh.set_instance_transform(i, final_transform)
