extends Control

@onready var welcomeLabel = $"../LoginBox/VBoxContainer/Label2"
func _ready() -> void:
	welcomeLabel.text ="Welcome "+ SessionData.userName
