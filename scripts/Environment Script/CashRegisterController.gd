extends StaticBody3D

signal item_scanned_for_teaching(item_id, hint_audio)

# CONNECT YOUR ROLLER AREA3D'S 'body_entered' SIGNAL TO THIS FUNCTION!
func _on_roller_area_body_entered(body: Node3D) -> void:
	if body is XRToolsPickable:
		body.freeze = true
	if body is RigidBody3D and body.has_meta("itemName"):
		var id = body.get_meta("itemName")
		var hintArray = body.get_meta("hintAudios")
		var hint = hintArray.pick_random()
		
		print("Cash Register detected: ", id)
		emit_signal("item_scanned_for_teaching", id, hint)
