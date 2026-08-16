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
	loadingLabel.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	if loadingLabel.label_settings == null:
		loadingLabel.label_settings = LabelSettings.new()

	show_status_message("Đang tải danh sách bé yêu... 🎈", false)

	httpRequest.request_completed.connect(_on_request_completed)
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed() -> void:
	if visible:
		for child in profilesContainer.get_children():
			if child != templateButton:
				child.queue_free()

		show_status_message("Đang tải danh sách bé yêu... 🎈", false)
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
		show_status_message("❌ Lỗi kết nối máy chủ! Hãy kiểm tra mạng nhé.", true)
		return

	if responseCode != 200:
		show_status_message("❌ Lỗi xác thực tài khoản phụ huynh! (Mã " + str(responseCode) + ")", true)
		return

	var json = JSON.parse_string(body.get_string_from_utf8())

	if json != null and json.has("success") and json["success"] == true:
		children_data = json["data"]
		
		if children_data.size() == 0:
			show_status_message("🧸 Tài khoản chưa có hồ sơ bé yêu nào cả!", true)
			return
			
		show_status_message("Chọn bé yêu để vào thế giới chơi nhé! 👇", false)

		for child in children_data:
			var btn: Button = templateButton.duplicate()
			btn.visible = true
			btn.text = str(child.get("fullName", "")) + "\n(" + str(child.get("age", "")) + " tuổi)"
			btn.pressed.connect(_on_profile_selected.bind(child))
			btn.mouse_entered.connect(_on_btn_hover.bind(btn))
			btn.mouse_exited.connect(_on_btn_unhover.bind(btn))
			profilesContainer.add_child(btn)
	else:
		show_status_message("🧸 Không tìm thấy hồ sơ của bé!", true)

func _on_profile_selected(child_data: Dictionary) -> void:
	_enable_profile_buttons(false)
	show_status_message("Đang chuẩn bị lớp học cho bé... 🔍", false)

	var child_id = int(child_data.get("id", 0))
	var check_url = "https://103-162-30-111.sslip.io/api/enrollments/child/" + str(child_id)

	var check_http = HTTPRequest.new()
	add_child(check_http)
	check_http.request_completed.connect(self._on_enrollment_check_completed.bind(child_data, check_http))

	var headers := [
		"Authorization: Bearer " + SessionData.accessToken,
		"accept: application/json"
	]
	check_http.request(check_url, headers, HTTPClient.METHOD_GET)

func _on_enrollment_check_completed(result: int, responseCode: int, headers: PackedStringArray, body: PackedByteArray, child_data: Dictionary, http_node: HTTPRequest) -> void:
	http_node.queue_free() # Clean up dynamic node

	if result != HTTPRequest.RESULT_SUCCESS:
		_enable_profile_buttons(true)
		show_status_message("❌ Lỗi kết nối kiểm tra lớp học!", true)
		return

	if responseCode != 200:
		_enable_profile_buttons(true)
		show_status_message("❌ Không thể kiểm tra lớp học! (Mã " + str(responseCode) + ")", true)
		return

	var json = JSON.parse_string(body.get_string_from_utf8())
	if json != null and json.has("success") and json["success"] == true:
		var enrollments = json["data"]
		var has_active_class = false
		for enrollment in enrollments:
			var status = enrollment.get("status", "")
			if status == "Active" or status == "active":
				has_active_class = true
				break

		if has_active_class:
			# Save data to PlayerData and proceed
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

			loadingLabel.visible = false
			visible = false
			welcomeScene.visible = true
		else:
			_enable_profile_buttons(true)
			show_status_message("🧸 Bé " + str(child_data.get("fullName", "")) + " chưa được kích hoạt lớp học nhé!", true)
	else:
		_enable_profile_buttons(true)
		show_status_message("❌ Lỗi kiểm tra dữ liệu lớp học!", true)

func _enable_profile_buttons(enabled: bool) -> void:
	for btn in profilesContainer.get_children():
		if btn is Button and btn != templateButton:
			btn.disabled = not enabled
			var target_alpha = 1.0 if enabled else 0.5
			var tween = create_tween()
			tween.tween_property(btn, "modulate:a", target_alpha, 0.2)

func show_status_message(msg: String, is_error: bool = false) -> void:
	loadingLabel.text = msg
	loadingLabel.visible = true
	
	if loadingLabel.label_settings == null:
		loadingLabel.label_settings = LabelSettings.new()
	
	var settings = loadingLabel.label_settings
	if is_error:
		settings.font_color = Color(0.85, 0.25, 0.25) # Soft warm red
		settings.font_size = 20 # Make it slightly larger and readable
		settings.outline_color = Color(1.0, 1.0, 1.0) # White outline for game contrast
		settings.outline_size = 6
		
		# Dynamic Juice: Shake the entire ProfileBox card
		var card = get_node_or_null("ProfileBox")
		if card:
			var original_pos = card.position
			var tween = create_tween()
			for i in range(4):
				var offset = Vector2(randf_range(-10, 10), 0)
				tween.tween_property(card, "position", original_pos + offset, 0.04)
			tween.tween_property(card, "position", original_pos, 0.04)
	else:
		settings.font_color = Color(0.15, 0.5, 0.55) # Clean teal/blue
		settings.font_size = 18
		settings.outline_color = Color(1.0, 1.0, 1.0)
		settings.outline_size = 4

func _on_btn_hover(btn: Button) -> void:
	btn.pivot_offset = btn.size / 2
	var tween := create_tween()
	tween.tween_property(btn, "scale", Vector2(1.05, 1.05), 0.15)

func _on_btn_unhover(btn: Button) -> void:
	var tween := create_tween()
	tween.tween_property(btn, "scale", Vector2.ONE, 0.15)
