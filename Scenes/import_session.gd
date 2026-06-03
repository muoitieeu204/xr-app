extends CanvasLayer
@onready var audio_dialog: FileDialog = $Control/AudioDialog
@onready var replay_dialog: FileDialog = $Control/ReplayDialog
@onready var replay_button: Button = $Control/BoxContainer/SelectReplay
@onready var audio_button: Button = $Control/BoxContainer/SelectAudio
@onready var accept_dialog: AcceptDialog = $Control/AcceptDialog

@export var loadScene : PackedScene



func _on_select_replay_pressed() -> void:
	replay_dialog.popup_centered(Vector2(800,600))


func _on_select_audio_pressed() -> void:
	audio_dialog.popup_centered(Vector2(800,600))


func _on_start_spectator_pressed() -> void:
	if SessionData.target_replay_path != "" and SessionData.target_audio_path != "" :
		get_tree().change_scene_to_packed(loadScene)
		print("Successfully load scene from ",loadScene.resource_path)
	else:
		print("Select both files first!")
		accept_dialog.popup_centered()

func _on_replay_dialog_file_selected(path: String) -> void:
	SessionData.target_replay_path = path
	replay_button.text = "Replay: " + path.get_file()


func _on_audio_dialog_file_selected(path: String) -> void:
	SessionData.target_audio_path = path
	audio_button.text = "Audio: " + path.get_file()
