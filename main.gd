@tool
extends Node3D

func _ready():
	if Engine.is_editor_hint():
		create_collisions_for_all_meshes(self)
		print("Finished generating collisions!")

func create_collisions_for_all_meshes(current_node: Node):
	for child in current_node.get_children():
		if child is MeshInstance3D:
			# Check if it already has a collision body to avoid duplicates
			var already_has_collision = false
			for grand_child in child.get_children():
				if grand_child is StaticBody3D:
					already_has_collision = true
			
			if not already_has_collision:
				# This built-in function tells Godot to do the menu action automatically
				child.create_trimesh_collision()
				
		# Keep searching down into nested children
		if child.get_child_count() > 0:
			create_collisions_for_all_meshes(child)
