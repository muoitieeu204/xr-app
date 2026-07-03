extends CanvasLayer

class_name ImportSessionManager

@onready var replay_dialog: FileDialog = $Control/ReplayDialog
@onready var replay_button: Button = $Control/BoxContainer/SelectReplay
@onready var accept_dialog: AcceptDialog = $Control/AcceptDialog


func _on_select_replay_pressed() -> void:
	replay_dialog.popup_centered(Vector2(800,600))

func _on_start_spectator_pressed() -> void:
	if SessionData.target_replay_path != "" and SessionData.target_audio_path != "" and SessionData.target_scene_path != "" :
		SessionData.is_spectator = true
		#Load the world from json file
		get_tree().change_scene_to_file(SessionData.target_scene_path)
		print("Successfully loading world: ", SessionData.target_scene_path)
	else:
		print("Select both files first!")
		accept_dialog.popup_centered()

func _on_replay_dialog_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()
	if parsed == null or not parsed.has("metadata"):
		accept_dialog.dialog_text = "Invalid file! This is not a replay JSON file"
		accept_dialog.popup_centered()
		return
	
	var targetAudioName = parsed["metadata"]["audio_file"]
	if parsed["metadata"].has("world_path"):
		SessionData.target_scene_path = parsed["metadata"]["world_path"]
	else:
		accept_dialog.dialog_text = "Invalid file! This JSON file do not contain world_path"
	var baseFolder = path.get_base_dir()
	var audioPath = baseFolder + "/" + targetAudioName
	if FileAccess.file_exists(audioPath):
		SessionData.target_replay_path = path
		SessionData.target_audio_path = audioPath
		replay_button.text = "Replay: " + path.get_file()
		print("Successfully link metadata audio: ", targetAudioName)
	else:
		SessionData.target_replay_path = ""
		SessionData.target_audio_path = ""
		
		accept_dialog.dialog_text = "Missing Audio! The metadata requires " + targetAudioName + "', but it is missing from the folder."
		accept_dialog.popup_centered()
		
