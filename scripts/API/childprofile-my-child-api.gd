extends Control

var apiUrl: String = "https://103-162-30-111.sslip.io/api/child-profiles/my-children"

@export var welcome_scene_path: NodePath = ^"../WelcomeScene"

@onready var httpRequest: HTTPRequest = $HTTPRequest
@onready var profilesContainer: GridContainer = $ProfileBox/VBoxContainer/ScrollContainer/ProfilesGrid
@onready var loadingLabel: Label = $ProfileBox/VBoxContainer/LoadingLabel
@onready var templateButton: Button = $ProfileBox/VBoxContainer/ScrollContainer/ProfilesGrid/TemplateButton
@onready var welcomeScene: Control = get_node_or_null(welcome_scene_path)
var interactionLog : TextDirection

var children_data: Array = []

func _ready() -> void:
	templateButton.visible = false
	loadingLabel.visible = true
	loadingLabel.text = "Dang tai danh sach..."

	httpRequest.request_completed.connect(_on_request_completed)
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed() -> void:
	if visible:
		for child in profilesContainer.get_children():
			if child != templateButton:
				child.queue_free()

		loadingLabel.visible = true
		loadingLabel.text = "Dang tai danh sach..."
		fetch_child_profiles()

func fetch_child_profiles() -> void:
	var headers := [
		"Authorization: Bearer " + SessionData.accessToken,
		"accept: application/json"
	]

	# httpRequest.set_tls_options(TLSOptions.client_unsafe())
	httpRequest.request(apiUrl, headers, HTTPClient.METHOD_GET)

func _on_request_completed(result: int, responseCode: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		loadingLabel.text = "Loi ket noi may chu!"
		return

	if responseCode != 200:
		loadingLabel.text = "Loi xac thuc (Ma " + str(responseCode) + ")"
		return

	var json = JSON.parse_string(body.get_string_from_utf8())

	if json != null and json.has("success") and json["success"] == true:
		loadingLabel.visible = false
		children_data = json["data"]

		for child in children_data:
			var btn: Button = templateButton.duplicate()
			btn.visible = true
			btn.text = str(child.get("fullName", "")) + "\n(" + str(child.get("age", "")) + " tuoi)"
			btn.pressed.connect(_on_profile_selected.bind(child))
			btn.mouse_entered.connect(_on_btn_hover.bind(btn))
			btn.mouse_exited.connect(_on_btn_unhover.bind(btn))
			profilesContainer.add_child(btn)
	else:
		loadingLabel.text = "Khong tim thay ho so nao!"

func _on_profile_selected(child_data: Dictionary) -> void:
	PlayerData.childId = int(child_data.get("id", 0))
	PlayerData.parentUserId = int(child_data.get("userId", 0))
	PlayerData.fullName = str(child_data.get("fullName", ""))
	PlayerData.age = int(child_data.get("age", 0))
	PlayerData.gender = str(child_data.get("gender", ""))
	PlayerData.learningLevel = str(child_data.get("learningLevel", ""))
	PlayerData.status = str(child_data.get("status", ""))

	if welcomeScene == null:
		push_error("WelcomeScene not found at path: " + str(welcome_scene_path))
		return

	visible = false
	welcomeScene.visible = true

func _on_btn_hover(btn: Button) -> void:
	btn.pivot_offset = btn.size / 2
	var tween := create_tween()
	tween.tween_property(btn, "scale", Vector2(1.05, 1.05), 0.15)

func _on_btn_unhover(btn: Button) -> void:
	var tween := create_tween()
	tween.tween_property(btn, "scale", Vector2.ONE, 0.15)
