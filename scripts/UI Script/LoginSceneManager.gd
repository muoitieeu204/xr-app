@tool
extends XRToolsSceneBase

@export_file("*.tscn") var main_scene: String = "res://Scenes/CyberLoadingSpace.tscn"

func _ready() -> void:
	var viewport2d = $Room/ComputerSetup/ComputerMonitor/Viewport2Din3D
	var auth_scene = viewport2d.get_scene_instance()

	if auth_scene == null:
		push_error("LoginSceneManager: AuthScene instance not found.")
		return

	if auth_scene.has_signal("join_world_requested"):
		auth_scene.join_world_requested.connect(Callable(self, "_on_join_world_requested"))
	else:
		push_error("LoginSceneManager: AuthScene does not have join_world_requested signal.")

func _on_join_world_requested() -> void:
	print_debug("LoginSceneManager: Join requested. Loading world...")

	if main_scene.is_empty():
		push_error("LoginSceneManager: main_scene is empty.")
		return

	get_tree().change_scene_to_file(main_scene)
