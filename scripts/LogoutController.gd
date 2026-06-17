extends PanelContainer

@export var logoutButton : Button
func _ready() -> void:
	if logoutButton == null :
		printerr("Node not found, make sure to assign in the inspector!")
	logoutButton.pressed.connect(_on_logout_button_pressed)
	
func _on_logout_button_pressed() -> void:
	SessionData.accessToken = ""
	SessionData.refreshToken = ""
	SessionData.userId = 0
	SessionData.fullName = ""
	SessionData.userName = ""
	SessionData.roleName = ""
	SessionData.isActive = false