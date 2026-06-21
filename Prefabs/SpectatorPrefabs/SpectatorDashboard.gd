extends Control

@export var settings_menu_scene: PackedScene
@export var progress_menu_scene: PackedScene

@onready var welcome_label = $MenuBox/MarginContainer/VBoxContainer/WelcomeLabel
@onready var settings_btn = $MenuBox/MarginContainer/VBoxContainer/ButtonsContainer/SettingsButton
@onready var progress_btn = $MenuBox/MarginContainer/VBoxContainer/ButtonsContainer/ProgressButton
@onready var logout_btn = $MenuBox/MarginContainer/VBoxContainer/ButtonsContainer/LogoutButton

func _ready() -> void:
	# Update welcome text dynamically from session data
	if SessionData.fullName != "":
		welcome_label.text = "Xin chào, " + SessionData.fullName + "! 👋"
	else:
		welcome_label.text = "Xin chào Người giám sát! 👋"
		
	# Connect signals
	settings_btn.pressed.connect(_on_settings_pressed)
	settings_btn.mouse_entered.connect(_on_button_hover.bind(settings_btn))
	settings_btn.mouse_exited.connect(_on_button_unhover.bind(settings_btn))
	
	progress_btn.pressed.connect(_on_progress_pressed)
	progress_btn.mouse_entered.connect(_on_button_hover.bind(progress_btn))
	progress_btn.mouse_exited.connect(_on_button_unhover.bind(progress_btn))
	
	logout_btn.pressed.connect(_on_logout_pressed)
	logout_btn.mouse_entered.connect(_on_button_hover.bind(logout_btn))
	logout_btn.mouse_exited.connect(_on_button_unhover.bind(logout_btn))

func _on_settings_pressed() -> void:
	if settings_menu_scene:
		var settings_instance = settings_menu_scene.instantiate()
		add_child(settings_instance)
	else:
		printerr("Settings Menu Scene is not assigned!")

func _on_progress_pressed() -> void:
	if progress_menu_scene:
		var progress_instance = progress_menu_scene.instantiate()
		add_child(progress_instance)
		
		# Set some default mock progress for the initial load if the data isn't set yet
		# In production, this can be synced with real time student progress values
		if progress_instance.has_method("set_progress"):
			progress_instance.set_progress(4, 10)
	else:
		printerr("Progress Menu Scene is not assigned!")

func _on_logout_pressed() -> void:
	# Clear session data
	SessionData.accessToken = ""
	SessionData.refreshToken = ""
	SessionData.userId = 0
	SessionData.fullName = ""
	SessionData.userName = ""
	SessionData.roleName = ""
	SessionData.isActive = false
	
	print_debug("Spectator Logged Out Successfully")
	
	# Transition back to the main Authentication Scene
	get_tree().change_scene_to_file("res://Prefabs/SpectatorPrefabs/AuthScene.tscn")

# Kids playful micro-animations (scale & tilt on hover)
func _on_button_hover(btn: Button) -> void:
	btn.pivot_offset = btn.size / 2
	var tween = create_tween().set_parallel(true)
	tween.tween_property(btn, "scale", Vector2(1.04, 1.04), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(btn, "rotation_degrees", 1.2, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_button_unhover(btn: Button) -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(btn, "rotation_degrees", 0.0, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
