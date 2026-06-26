extends StaticBody3D

signal item_scanned_for_teaching(item_id, hint_audio)

# CONNECT YOUR ROLLER AREA3D'S 'body_entered' SIGNAL TO THIS FUNCTION!
func _on_roller_area_body_entered(body: Node3D) -> void:
	if body is RigidBody3D and body.has_meta("itemId"):
		var id = body.get_meta("itemId")
		var hint = body.get_meta("hintAudio")
		
		print("Cash Register detected: ", id)
		emit_signal("item_scanned_for_teaching", id, hint)
