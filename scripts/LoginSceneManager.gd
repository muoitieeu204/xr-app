extends Node3D

@export_file('*.tscn') var main_scene : String

@onready var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
signal joinButton

func _ready() -> void:
	var viewport2d = $Room/ComputerSetup/ComputerMonitor/Viewport2Din3D
	var authScene = viewport2d.get_scene_instance()
	if authScene:
		var joinButton_node = authScene.get_node("WelcomeScene/WelcomeBox/VBoxContainer/Button")
		if joinButton_node: 
			joinButton_node.pressed.connect(_on_join_button_pressed)

func _on_join_button_pressed() -> void:
	joinButton.emit()
	if scene_base:
		scene_base.load_scene(main_scene)
	else:
		print("No XRToolsSceneBase found. Falling back to direct scene load for testing...")
		get_tree().change_scene_to_file(main_scene)
