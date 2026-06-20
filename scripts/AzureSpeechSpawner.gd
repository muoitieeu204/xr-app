extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if(body.is_in_group("player_body")):
		print("Player is entering trigger zone, turning on mic...");
		# In GDScript, we access C# Autoloads by getting them from the root!
		var speech_manager = get_node_or_null("/root/AzureSpeechManager")
		if speech_manager:
			speech_manager.StartListening()
