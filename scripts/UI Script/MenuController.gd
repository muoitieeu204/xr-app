extends Control

@onready var menuScreen = $MenuScreen
@onready var settingMenuScreen = $SettingsMenu 
@onready var resultScreen =  $ResultScene
@onready var logoutScreen = $LogoutBox

func _ready():
	switch_screen("main")
	
	# Connect the buttons from the MenuScreen to their functions automatically
	var btn_setting = $MenuScreen/MenuBox/MarginContainer/VBoxContainer/BtnSetting
	var btn_logout = $MenuScreen/MenuBox/MarginContainer/VBoxContainer/BtnLogout

	var setting_back_btn = $SettingsMenu/MenuBox/MarginContainer/VBoxContainer/CloseButton
	var logout_back_btn = $LogoutBox/VBoxContainer/ReturnButton

	if btn_setting: btn_setting.pressed.connect(switch_screen.bind("setting"))
	if btn_logout: btn_logout.pressed.connect(switch_screen.bind("logout"))
	if setting_back_btn: setting_back_btn.pressed.connect(switch_screen.bind("main"))
	if logout_back_btn: logout_back_btn.pressed.connect(switch_screen.bind("main"))

func hideAllScreens():
	menuScreen.visible = false
	settingMenuScreen.visible = false
	resultScreen.visible = false
	logoutScreen.visible = false

func switch_screen(screenName: String):
	hideAllScreens()
	match screenName:
		"main": 
			menuScreen.visible = true
		"setting":
			settingMenuScreen.visible = true
		"logout":
			logoutScreen.visible = true
		"result":
			resultScreen.visible = true
