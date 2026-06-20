@tool
extends EditorScenePostImport

# This function runs automatically on every file you import
func _post_import(scene):
	add_collisions(scene)
	return scene

func add_collisions(node):
	# If the node is a mesh, automatically generate a collision box for it
	if node is MeshInstance3D:
		node.create_trimesh_collision()
		
	# Check all nested children just in case
	for child in node.get_children():
		add_collisions(child)
