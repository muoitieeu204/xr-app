extends PanelContainer

@onready var main_warning_container = $VBoxContainer
@onready var take_off_headset_screen = $TakeOffHeadsetScreen
@onready var yes_button = $VBoxContainer/YesButton
@onready var continue_button = $VBoxContainer/ContinueButton

func _ready():
	GameManager.health_warning_triggered.connect(_show_health_warning)

func _show_health_warning():
	process_mode = Node.PROCESS_MODE_INHERIT
	var viewport_3d = get_parent().get_parent()
	if viewport_3d:
		viewport_3d.process_mode = Node.PROCESS_MODE_INHERIT
		viewport_3d.show()
		
	take_off_headset_screen.hide()
	main_warning_container.show()

func _on_yes_button_pressed():
	# Hide the main warning UI and show the "take off headset" text
	main_warning_container.hide()
	take_off_headset_screen.show()

func _on_continue_button_pressed():
	# Just dismiss the warning screen by hiding it
	var viewport_3d = get_parent().get_parent()
	if viewport_3d:
		process_mode = Node.PROCESS_MODE_DISABLED
		viewport_3d.hide()
