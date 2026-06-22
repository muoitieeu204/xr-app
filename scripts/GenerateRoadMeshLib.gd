@tool
extends EditorScript

func _run():
	var dir_path = "res://Assets/kenney_3d-road-tiles/Models/gLTF/"
	var dir = DirAccess.open(dir_path)
	if not dir:
		print("Could not open directory.")
		return
		
	var mesh_lib = MeshLibrary.new()
	dir.list_dir_begin()
	
	var file_name = dir.get_next()
	var item_id = 0
	
	print("Generating MeshLibrary...")
	
	while file_name != "":
		if file_name.ends_with(".gltf") and not file_name.ends_with(".import"):
			var path = dir_path + file_name
			var packed_scene = load(path)
			if packed_scene is PackedScene:
				var instance = packed_scene.instantiate()
				var meshes = _find_meshes(instance)
				
				for mesh_node in meshes:
					var mesh = mesh_node.mesh
					if mesh:
						mesh_lib.create_item(item_id)
						
						# Combine the filename and the mesh node name to make it 100% unique!
						var base_name = file_name.replace(".gltf", "")
						mesh_lib.set_item_name(item_id, base_name + "_" + mesh_node.name)
						mesh_lib.set_item_mesh(item_id, mesh)
						
						# Automatically generate Trimesh (Concave) collision
						var shape = mesh.create_trimesh_shape()
						if shape:
							mesh_lib.set_item_shapes(item_id, [shape, Transform3D.IDENTITY])
						
						item_id += 1
				instance.free()
		file_name = dir.get_next()
		
	ResourceSaver.save(mesh_lib, "res://Assets/kenney_3d-road-tiles/city_road_kit_mesh_library_fixed.tres")
	print("Success! Mesh Library generated with ", item_id, " total items!")

func _find_meshes(node: Node) -> Array[MeshInstance3D]:
	var result: Array[MeshInstance3D] = []
	if node is MeshInstance3D:
		result.append(node)
	for child in node.get_children():
		result.append_array(_find_meshes(child))
	return result
