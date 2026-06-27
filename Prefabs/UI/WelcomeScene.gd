extends Control

@onready var welcomeLabel: Label = $WelcomeBox/VBoxContainer/Label2
@onready var joinButton: Button = $WelcomeBox/VBoxContainer/Button

func _ready() -> void:
	visibility_changed.connect(Callable(self, "_on_visibility_changed"))
	joinButton.pressed.connect(Callable(self, "_on_join_button_pressed"))

	if visible:
		_update_welcome_label()

func _on_visibility_changed() -> void:
	if visible:
		_update_welcome_label()

func _update_welcome_label() -> void:
	var child_name := PlayerData.full_name.strip_edges()

	if child_name.is_empty():
		welcomeLabel.text = "Hello!"
	else:
		welcomeLabel.text = "Hello " + child_name + "!"

func _on_join_button_pressed() -> void:
	GameManager.profile_selected.emit()