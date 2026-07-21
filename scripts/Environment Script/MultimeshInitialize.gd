class_name MultimeshIntilize extends Node3D

func _ready() -> void:
	call_deferred("multimeshConverter")

#Load the multimesh onto the fridge
func multimeshConverter():
	var meshGroup = {}
	findAndGroupItems(self, meshGroup)
	for mesh in meshGroup:
		var items = meshGroup[mesh]
		buildMultiMesh(mesh,items)

#Recursive func that digs through the fridge to find fake items
func findAndGroupItems(currentNode: Node, meshGroup: Dictionary):
	for child in currentNode.get_children():
		if child is Area3D and "realItem" in child:
			var visualMeshNode = findFirstMeshIntance(child)
			
			if visualMeshNode and visualMeshNode.mesh:
				var mesh = visualMeshNode.mesh
				if not meshGroup.has(mesh):
					meshGroup[mesh] = []
				
				# These need to be OUTSIDE the 'if' statement so they run for EVERY item
				# We save BOTH the item node and the exact visual transform to perfectly match scale/rotation
				meshGroup[mesh].append({
					"item": child,
					"visual_transform": visualMeshNode.global_transform
				})
				visualMeshNode.visible = false
		findAndGroupItems(child,meshGroup)

#Create a single MultiMeshInstance3D for a stack of items
func buildMultiMesh(mesh: Mesh, items: Array):
	var mmi = MultiMeshInstance3D.new()
	var mm = MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.instance_count = items.size()
	mm.mesh = mesh
	mmi.multimesh = mm
	mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	mmi.top_level = true
	add_child(mmi)
	for i in range(items.size()):
		var data = items[i]
		# Use the visual_transform to perfectly match the original visual size and position!
		mm.set_instance_transform(i, data["visual_transform"])

func findFirstMeshIntance(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var result = findFirstMeshIntance(child)

		if result:
			return result
		
	return null