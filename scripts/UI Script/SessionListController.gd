extends Control

## SessionListController — Dành cho Teacher
## Bước 1: Chọn trẻ (fetch từ API child-profiles)
## Bước 2: Hiện danh sách sessions của trẻ đó

const BASE_URL        := "https://103-162-30-111.sslip.io/api/files"
# my-students: Teacher xem học sinh trong lớp mình quản lý (Active enrollment only)
const CHILDREN_API    := "https://103-162-30-111.sslip.io/api/child-profiles/my-students"

# --- Node refs ---
@onready var child_name_label:  Label          = $Background/VBox/HeaderPanel/Header/ChildNameLabel
@onready var session_list:      VBoxContainer  = $Background/VBox/SessionContentArea/CenterContainer/SessionListCard/VBox/ScrollContainer/SessionList
@onready var loading_overlay:   Control        = $LoadingOverlay
@onready var loading_label:     Label          = $LoadingOverlay/CenterContainer/PanelContainer/LoadingLabel
@onready var error_dialog:      AcceptDialog   = $ErrorDialog
@onready var back_button:       Button         = $Background/VBox/HeaderPanel/Header/BackButton
@onready var logout_button:     Button         = $Background/VBox/HeaderPanel/Header/LogoutButton

# --- Child selector (Bước 1) ---
@onready var child_selector_panel: Control        = $ChildSelectorPanel
@onready var children_list:        VBoxContainer  = $ChildSelectorPanel/CenterContainer/ChildSelectorCard/VBox/ScrollContainer/ChildrenList
@onready var selector_loading_lbl: Label          = $ChildSelectorPanel/CenterContainer/ChildSelectorCard/VBox/LoadingLabel

# --- HTTP ---
var _http_children: HTTPRequest
var _files_api: Node

# --- State ---
var _sessions:         Array  = []
var _selected_folder_id: String = ""
var _meta_downloaded:  bool   = false
var _audio_downloaded: bool   = false
var _meta_path:        String = ""
var _audio_path:       String = ""

func _ready() -> void:
	# Tạo HTTPRequest cho danh sách trẻ
	_http_children = HTTPRequest.new()
	add_child(_http_children)
	_http_children.request_completed.connect(_on_children_completed)

	# Tạo FilesApi node
	_files_api = load("res://scripts/API/FilesApi.gd").new()
	add_child(_files_api)
	_files_api.sessions_loaded.connect(_on_sessions_loaded)
	_files_api.sessions_load_failed.connect(_on_load_failed)
	_files_api.metadata_downloaded.connect(_on_meta_downloaded)
	_files_api.audio_downloaded.connect(_on_audio_downloaded)
	_files_api.download_failed.connect(_on_download_failed)

	back_button.pressed.connect(_on_back_pressed)
	back_button.mouse_entered.connect(func(): _hover_btn(back_button, true))
	back_button.mouse_exited.connect(func():  _hover_btn(back_button, false))

	# Liên kết nút Đăng xuất
	logout_button.pressed.connect(_on_logout_pressed)
	logout_button.mouse_entered.connect(func(): _hover_btn(logout_button, true))
	logout_button.mouse_exited.connect(func():  _hover_btn(logout_button, false))

	# Bắt đầu kiểm tra: nếu đã chọn trẻ trước đó (quay lại từ spectator)
	if PlayerData.childId > 0:
		# Bỏ qua Bước 1, chuyển thẳng sang Bước 2 (Danh sách Session của bé)
		child_selector_panel.visible = false
		session_list.get_parent().get_parent().visible = true
		back_button.visible = true # Hiện nút Quay lại để về Bước 1 khi cần
		
		var class_name_text: String = "" # Tên lớp sẽ hiển thị theo header
		child_name_label.text = "📁 Buổi học của: " + PlayerData.fullName
		_show_loading("Đang tải danh sách buổi học...")
		_files_api.fetch_sessions(PlayerData.childId)
	else:
		# Bắt đầu ở Bước 1: chọn trẻ
		child_name_label.text = "Xin chào, " + SessionData.fullName + " 👋"
		back_button.visible = false # Ẩn nút Quay lại khi ở Bước 1
		_show_child_selector()

# =======================================================================
# BƯỚC 1 — CHỌN TRẺ
# =======================================================================
func _show_child_selector() -> void:
	child_selector_panel.visible = true
	session_list.get_parent().get_parent().visible = false  # ẩn session list area
	selector_loading_lbl.text = "Đang tải danh sách học sinh..."
	selector_loading_lbl.visible = true

	# Xoá cũ
	for c in children_list.get_children():
		c.queue_free()

	# Fetch danh sách trẻ
	var headers := PackedStringArray([
		"Authorization: Bearer " + SessionData.accessToken,
		"accept: application/json"
	])
	_http_children.request(CHILDREN_API, headers, HTTPClient.METHOD_GET)

func _on_children_completed(result: int, code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	selector_loading_lbl.visible = false

	if result != HTTPRequest.RESULT_SUCCESS or code != 200:
		selector_loading_lbl.text = "Lỗi tải danh sách học sinh (HTTP %d)" % code
		selector_loading_lbl.visible = true
		return

	var json = JSON.parse_string(body.get_string_from_utf8())
	var children: Array = []

	# my-students trả về: { success, data: { items: [...] } } (PagedResponse)
	if json is Dictionary and json.has("data"):
		var data = json["data"]
		if data is Dictionary and data.has("items"):
			children = data["items"]
		elif data is Array:
			children = data  # fallback nếu API trả mảng thẳng

	if children.is_empty():
		selector_loading_lbl.text = "Không có học sinh nào trong lớp của bạn."
		selector_loading_lbl.visible = true
		return

	for child in children:
		var btn := Button.new()
		var name_text:  String = str(child.get("fullName", "Không tên"))
		var age_text:   String = str(child.get("age", "?"))
		var class_name_text: String = str(child.get("classroomName", ""))
		if class_name_text.is_empty():
			btn.text = "  👤  %s  (%s tuổi)" % [name_text, age_text]
		else:
			btn.text = "  👤  %s  (%s tuổi)   🏫 %s" % [name_text, age_text, class_name_text]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.custom_minimum_size = Vector2(0, 52)
		
		# Thiết kế style chuẩn VoxCresco cho nút học sinh
		var style_normal = StyleBoxFlat.new()
		style_normal.bg_color = Color(0.976471, 0.980392, 0.984314, 1)
		style_normal.border_width_bottom = 3
		style_normal.border_color = Color(0.92, 0.93, 0.95, 1)
		style_normal.corner_radius_top_left = 10
		style_normal.corner_radius_top_right = 10
		style_normal.corner_radius_bottom_right = 10
		style_normal.corner_radius_bottom_left = 10
		style_normal.content_margin_left = 16
		
		var style_hover = style_normal.duplicate()
		style_hover.bg_color = Color(0.92, 0.96, 0.96, 1)
		style_hover.border_color = Color(0.305882, 0.67451, 0.686275, 0.5)

		var style_pressed = style_normal.duplicate()
		style_pressed.bg_color = Color(0.305882, 0.67451, 0.686275, 1)
		style_pressed.border_color = Color(0.223529, 0.552941, 0.564706, 1)
		
		btn.add_theme_stylebox_override("normal", style_normal)
		btn.add_theme_stylebox_override("hover", style_hover)
		btn.add_theme_stylebox_override("pressed", style_pressed)
		btn.add_theme_stylebox_override("focus", style_hover)
		
		btn.add_theme_color_override("font_color", Color(0.12, 0.16, 0.22, 1))
		btn.add_theme_color_override("font_hover_color", Color(0.06, 0.45, 0.47, 1))
		btn.add_theme_color_override("font_pressed_color", Color(1, 1, 1, 1))
		btn.add_theme_font_size_override("font_size", 15)
		
		btn.mouse_entered.connect(func(): _hover_btn(btn, true))
		btn.mouse_exited.connect(func():  _hover_btn(btn, false))
		btn.pressed.connect(_on_child_selected.bind(child))
		children_list.add_child(btn)

func _on_child_selected(child_data: Dictionary) -> void:
	# Set PlayerData từ my-students response
	PlayerData.childId      = int(child_data.get("id", 0))
	PlayerData.fullName     = str(child_data.get("fullName", ""))
	PlayerData.age          = int(child_data.get("age", 0))
	PlayerData.learningLevel = str(child_data.get("learningLevel", ""))

	var class_name_text: String = str(child_data.get("classroomName", ""))

	# Chuyển sang Bước 2
	child_selector_panel.visible = false
	session_list.get_parent().get_parent().visible = true
	back_button.visible = true # Hiện nút quay lại khi chuyển sang Bước 2
	if class_name_text.is_empty():
		child_name_label.text = "📁 Buổi học của: " + PlayerData.fullName
	else:
		child_name_label.text = "📁 %s — %s" % [class_name_text, PlayerData.fullName]

	_show_loading("Đang tải danh sách buổi học...")
	_files_api.fetch_sessions(PlayerData.childId)

# =======================================================================
# BƯỚC 2 — DANH SÁCH SESSIONS
# =======================================================================
func _on_sessions_loaded(sessions: Array) -> void:
	_sessions = sessions
	_hide_loading()
	_build_session_cards()

func _on_load_failed(error: String) -> void:
	_hide_loading()
	error_dialog.dialog_text = "Lỗi tải danh sách:\n" + error
	error_dialog.popup_centered()

func _build_session_cards() -> void:
	for child in session_list.get_children():
		child.queue_free()

	if _sessions.is_empty():
		var lbl := Label.new()
		lbl.text = "Chưa có buổi học nào được ghi lại."
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lbl.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		session_list.add_child(lbl)
		return

	for session in _sessions:
		session_list.add_child(_create_session_card(session))

func _create_session_card(session: Dictionary) -> PanelContainer:
	var folder_id:  String = str(session.get("folderId", session.get("id", "?")))
	var created_at: String = str(session.get("createdAt", session.get("uploadedAt", "")))
	if created_at.length() >= 16:
		created_at = created_at.substr(0, 10) + "  " + created_at.substr(11, 5)

	var card := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color                     = Color(0.976471, 0.980392, 0.984314, 1)
	style.border_width_left            = 4
	style.border_color                 = Color(0.305882, 0.67451, 0.686275, 1) # Viền trái màu ngọc bích
	style.corner_radius_top_left       = 12
	style.corner_radius_top_right      = 12
	style.corner_radius_bottom_left    = 12
	style.corner_radius_bottom_right   = 12
	style.content_margin_left          = 16
	style.content_margin_top           = 14
	style.content_margin_right         = 16
	style.content_margin_bottom        = 14
	card.add_theme_stylebox_override("panel", style)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 16)
	card.add_child(hbox)

	var icon_lbl := Label.new()
	icon_lbl.text = "🎥"
	icon_lbl.add_theme_font_size_override("font_size", 26)
	hbox.add_child(icon_lbl)

	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(vbox)

	var name_lbl := Label.new()
	name_lbl.text = PlayerData.fullName
	name_lbl.add_theme_font_size_override("font_size", 16)
	name_lbl.add_theme_color_override("font_color", Color(0.066667, 0.094118, 0.152941, 1))
	vbox.add_child(name_lbl)

	var date_lbl := Label.new()
	date_lbl.text = "📅 %s   🗂 %s" % [created_at, folder_id]
	date_lbl.add_theme_font_size_override("font_size", 12)
	date_lbl.add_theme_color_override("font_color", Color(0.48, 0.52, 0.58, 1))
	vbox.add_child(date_lbl)

	var play_btn := Button.new()
	play_btn.text = "▶  Xem lại"
	play_btn.custom_minimum_size = Vector2(110, 40)
	
	# Style nút Xem lại ngọc bích chuẩn VoxCresco
	var btn_normal = StyleBoxFlat.new()
	btn_normal.bg_color = Color(0.305882, 0.67451, 0.686275, 1)
	btn_normal.border_width_bottom = 3
	btn_normal.border_color = Color(0.223529, 0.552941, 0.564706, 1)
	btn_normal.corner_radius_top_left = 8
	btn_normal.corner_radius_top_right = 8
	btn_normal.corner_radius_bottom_right = 8
	btn_normal.corner_radius_bottom_left = 8
	
	var btn_hover = btn_normal.duplicate()
	btn_hover.bg_color = Color(0.36, 0.74, 0.75, 1)
	
	var btn_pressed = btn_normal.duplicate()
	btn_pressed.bg_color = Color(0.223529, 0.552941, 0.564706, 1)
	btn_pressed.border_width_bottom = 1
	
	play_btn.add_theme_stylebox_override("normal", btn_normal)
	play_btn.add_theme_stylebox_override("hover", btn_hover)
	play_btn.add_theme_stylebox_override("pressed", btn_pressed)
	play_btn.add_theme_stylebox_override("focus", btn_hover)
	
	play_btn.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	play_btn.add_theme_font_size_override("font_size", 14)
	
	play_btn.mouse_entered.connect(func(): _hover_btn(play_btn, true))
	play_btn.mouse_exited.connect(func():  _hover_btn(play_btn, false))
	play_btn.pressed.connect(_on_session_selected.bind(folder_id))
	hbox.add_child(play_btn)

	return card

# =======================================================================
# DOWNLOAD & LAUNCH
# =======================================================================
func _on_session_selected(folder_id: String) -> void:
	_selected_folder_id = folder_id
	_meta_downloaded    = false
	_audio_downloaded   = false
	_meta_path          = ""
	_audio_path         = ""

	_show_loading("Đang tải dữ liệu buổi học...")
	_files_api.download_metadata(PlayerData.childId, folder_id)
	_files_api.download_audio(PlayerData.childId, folder_id)

func _on_meta_downloaded(path: String) -> void:
	_meta_path       = path
	_meta_downloaded = true
	_check_downloads_complete()

func _on_audio_downloaded(path: String) -> void:
	_audio_path       = path
	_audio_downloaded = true
	_check_downloads_complete()

func _on_download_failed(error: String) -> void:
	_hide_loading()
	error_dialog.dialog_text = "Lỗi tải file:\n" + error
	error_dialog.popup_centered()

func _check_downloads_complete() -> void:
	if not (_meta_downloaded and _audio_downloaded):
		return

	_hide_loading()

	var file := FileAccess.open(_meta_path, FileAccess.READ)
	if file == null:
		error_dialog.dialog_text = "Không đọc được file metadata!"
		error_dialog.popup_centered()
		return

	var parsed = JSON.parse_string(file.get_as_text())
	file.close()

	if parsed == null or not parsed.has("metadata"):
		error_dialog.dialog_text = "File metadata không hợp lệ!"
		error_dialog.popup_centered()
		return

	var world_path: String = parsed["metadata"].get("world_path", "")
	if world_path.is_empty():
		error_dialog.dialog_text = "Metadata không có world_path!"
		error_dialog.popup_centered()
		return

	SessionData.target_replay_path = _meta_path
	SessionData.target_audio_path  = _audio_path
	SessionData.target_scene_path  = world_path
	SessionData.is_spectator       = true

	print("SessionList: Launching spectator → ", world_path)
	get_tree().change_scene_to_file(world_path)

# =======================================================================
# UI Helpers
# =======================================================================
func _on_back_pressed() -> void:
	if child_selector_panel.visible == false:
		# Đang ở Bước 2 → quay về Bước 1
		PlayerData.childId = 0 # Reset lại childId để quay lại danh sách chọn bình thường
		child_selector_panel.visible = true
		session_list.get_parent().get_parent().visible = false
		child_name_label.text = "Xin chào, " + SessionData.fullName + " 👋"
		back_button.visible = false # Ẩn nút quay lại ở Bước 1
	else:
		# Đang ở Bước 1 → quay về Login
		_on_logout_pressed()

func _on_logout_pressed() -> void:
	# Báo hiệu cho AuthController ở LoginScene biết cần đăng xuất sạch sẽ
	SessionData.pending_logout = true
	
	# Reset thông tin học sinh ở PlayerData
	PlayerData.childId = 0
	PlayerData.fullName = ""
	PlayerData.age = 0
	PlayerData.learningLevel = ""
	
	print("Redirecting to LoginScene for clean logout...")
	get_tree().change_scene_to_file("res://Scenes/LoginScene.tscn")

func _show_loading(text: String) -> void:
	loading_overlay.visible = true
	loading_label.text      = text

func _hide_loading() -> void:
	loading_overlay.visible = false

func _hover_btn(btn: Button, entering: bool) -> void:
	btn.pivot_offset = btn.size / 2
	var target := Vector2(1.05, 1.05) if entering else Vector2.ONE
	var tween  := create_tween()
	tween.tween_property(btn, "scale", target, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
