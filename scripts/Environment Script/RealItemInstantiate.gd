@tool
extends XRToolsInteractableArea

@export var realItem: PackedScene
@export var itemName: String = ""
@export var itemNameSound: AudioStream
@export var hintAudios: Array[AudioStream] = []

func _ready() -> void:
	if not self.pointer_event.is_connected(_on_pointer_event):
		self.pointer_event.connect(_on_pointer_event)
		
func can_pick_up(by: Node3D) -> bool:
	return true

func request_highlight(by: Node3D, enable: bool) -> void:
	pass

	# 2. Godot XR Tools automatically calls this when you press the Grab Button!                                                                                                                                           
func pick_up(by: Node3D) -> void:
	itemName = itemName.strip_edges()
	# If hand already holding something, drop it first
	if is_instance_valid(by.get("picked_up_object")) and by.get("picked_up_object") != self:
		if by.has_method("drop_object"):
			by.drop_object()

	print("DEBUG: Fake item grabbed! Spawning real item...")
	# Spawn the real item                                                                                                                                                                                                 
	var realItemInstance = realItem.instantiate()
	get_parent().add_child(realItemInstance)
	realItemInstance.global_transform = global_transform
	realItemInstance.add_to_group("pickable")
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
	
	GameManager.item_name_updated.emit(itemName)
	realItemInstance.dropped.connect(func(_pickable): GameManager.item_name_updated.emit(""))
	realItemInstance.grabbed.connect(func(_pickable, _by): GameManager.item_name_updated.emit(itemName))
	get_tree().call_group("LevelController", "item_grabbed_for_tutorial")

	if has_meta("multimesh_id"):
		var mm_id = get_meta("multimesh_id")
		var mm = get_parent().get_node_or_null("MultiMeshInstance3D")
		if mm and mm.multimesh:
			mm.multimesh.set_instance_transform(mm_id, Transform3D(Basis().scaled(Vector3.ZERO), Vector3.ZERO))
	# Delete the fake item
	queue_free()

func _on_pointer_event(event: XRToolsPointerEvent):
	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		var controller = event.pointer.get_parent()
		for child in controller.get_children():
			if child is XRToolsFunctionPickup:
				if child.has_method("_pick_up_object"):
					child._pick_up_object(self)
				else:
					pick_up(child)
				return
