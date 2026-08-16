extends Control

@onready var menuScreen = $MenuScreen
@onready var settingMenuScreen = $SettingsMenu 
@onready var resultScreen =  $ResultScene
@onready var resultScoreLabel = $ResultScene/CenterContainer/ResultBox/VBoxContainer/ScoreLabel
@onready var valScore = $ResultScene/CenterContainer/ResultBox/VBoxContainer/StatsGrid/ScoreValue
@onready var valTime = $ResultScene/CenterContainer/ResultBox/VBoxContainer/StatsGrid/TimeValue
@onready var valCorrect = $ResultScene/CenterContainer/ResultBox/VBoxContainer/StatsGrid/CorrectValue
@onready var valWrong = $ResultScene/CenterContainer/ResultBox/VBoxContainer/StatsGrid/WrongValue
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

	var retry_btn = $ResultScene/CenterContainer/ResultBox/VBoxContainer/RetryButton
	if retry_btn:
		retry_btn.pressed.connect(func():
			get_tree().paused = false
			get_tree().call_group("LevelController", "emit_signal","request_reset_scene", null)
			)
	var actualLogoutBtn = $LogoutBox/VBoxContainer/LogoutButton
	if actualLogoutBtn:
		actualLogoutBtn.pressed.connect(func():
			SessionData.accessToken = ""
			SessionData.refreshToken = ""
			SessionData.userId = 0
			SessionData.fullName = ""
			SessionData.userName = ""
			SessionData.roleName = ""
			SessionData.isActive = false
			PlayerData.clear()
			if FileAccess.file_exists("user://auth.save"):
				var dir = DirAccess.open("user://")
				dir.remove("auth.save")
			print_debug("User Logout Successfully")
			
			# Unpause the game
			get_tree().paused = false
			
			var scene_base: XRToolsSceneBase = XRTools.find_xr_ancestor(self,"*", "XRToolsSceneBase")
			if not scene_base:
				return
			scene_base.load_scene("res://Scenes/LoginScene.tscn")
		)
			
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

func show_result(score: int, time_seconds: int = 0, correct: int = 0, wrong: int = 0):
	if resultScoreLabel:
		if score <= 50:
			resultScoreLabel.text = "Chúc mừng bé đã hoàn thành bài học"
		if score >= 80:
			resultScoreLabel.text = "Chúc mừng bé đã hoàn thành bài học tốt"
		if score >= 100:
			resultScoreLabel.text = "Chúc mừng bé đã hoàn thành bài học xuất xắc"
			
	if valScore: valScore.text = str(score)
	if valTime:
		var mins = time_seconds / 60
		var secs = time_seconds % 60
		valTime.text = str(mins) + ":" + str(secs).pad_zeros(2)
	if valCorrect: valCorrect.text = str(correct)
	if valWrong: valWrong.text = str(wrong)
	
	switch_screen("result")