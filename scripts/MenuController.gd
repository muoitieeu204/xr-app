extends Control

@onready var menuScreen = $MenuScreen
@onready var progressScreen = $ProgressMenu
@onready var settingMenuScreen = $SettingsMenu # Fixed typo from $SettingMenu
@onready var resultScreen =  $ResultScene
@onready var logoutScreen = $LogoutBox

func _ready():
	switchSreens("main")
	
	# 2. Connect the buttons from the MenuScreen to their functions automatically
	var btn_progress = $MenuScreen/MenuBox/MarginContainer/VBoxContainer/BtnProgress
	var btn_setting = $MenuScreen/MenuBox/MarginContainer/VBoxContainer/BtnSetting
	var btn_logout = $MenuScreen/MenuBox/MarginContainer/VBoxContainer/BtnLogout

	var progress_back_btn = $ProgressMenu/MenuBox/MarginContainer/VBoxContainer/CloseButton
	var setting_back_btn = $SettingsMenu/MenuBox/MarginContainer/VBoxContainer/CloseButton
	var logout_back_btn = $LogoutBox/VBoxContainer/ReturnButton

	if btn_progress: btn_progress.pressed.connect(switchSreens.bind("progress"))
	if btn_setting: btn_setting.pressed.connect(switchSreens.bind("setting"))
	if btn_logout: btn_logout.pressed.connect(switchSreens.bind("logout"))
	if progress_back_btn: progress_back_btn.pressed.connect(switchSreens.bind("main"))
	if setting_back_btn: setting_back_btn.pressed.connect(switchSreens.bind("main"))
	if logout_back_btn: logout_back_btn.pressed.connect(switchSreens.bind("main"))

func hideAllScreens():
	menuScreen.visible = false
	progressScreen.visible = false
	settingMenuScreen.visible = false
	resultScreen.visible = false
	logoutScreen.visible = false

func switchSreens(screenName: String):
	hideAllScreens()
	match screenName:
		"main": 
			menuScreen.visible = true
		"progress":
			progressScreen.visible = true
		"setting":
			settingMenuScreen.visible = true
		"logout":
			logoutScreen.visible = true

# --- NAVIGATION FUNCTIONS ---

func show_menu_screen():
	hideAllScreens()
	menuScreen.visible = true

func show_progress_screen():
	hideAllScreens()
	progressScreen.visible = true

func show_setting_screen():
	hideAllScreens()
	settingMenuScreen.visible = true

func show_logout_screen():
	hideAllScreens()
	logoutScreen.visible = true

func show_result_screen():
	hideAllScreens()
	resultScreen.visible = true
