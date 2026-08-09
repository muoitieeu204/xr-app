extends Control

## SessionListController — Dành cho Teacher
## Bước 1: Chọn trẻ (fetch từ API child-profiles)
## Bước 2: Hiện danh sách sessions của trẻ đó

const BASE_URL        := "https://103-162-30-111.sslip.io/api/files"
# /my-children chỉ dành cho Parent → dùng /child-profiles cho Teacher
const CHILDREN_API    := "https://103-162-30-111.sslip.io/api/child-profiles?pageSize=100"

# --- Node refs ---
@onready var child_name_label:  Label          = $Background/VBox/Header/ChildNameLabel
@onready var session_list:      VBoxContainer  = $Background/VBox/ScrollContainer/SessionList
@onready var loading_overlay:   Control        = $LoadingOverlay
@onready var loading_label:     Label          = $LoadingOverlay/LoadingLabel
@onready var error_dialog:      AcceptDialog   = $ErrorDialog
@onready var back_button:       Button         = $Background/VBox/Header/BackButton

# --- Child selector (Bước 1) ---
@onready var child_selector_panel: Control        = $ChildSelectorPanel
@onready var children_list:        VBoxContainer  = $ChildSelectorPanel/VBox/ScrollContainer/ChildrenList
@onready var selector_loading_lbl: Label          = $ChildSelectorPanel/VBox/LoadingLabel

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

	# Bắt đầu ở Bước 1: chọn trẻ
	child_name_label.text = "Xin chào, " + SessionData.fullName + " 👋"
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

	# /api/child-profiles trả về: { success, data: { items: [...] } }
	# /api/child-profiles/my-children trả về: { success, data: [...] }
	if json is Dictionary and json.has("data"):
		var data = json["data"]
		if data is Array:
			children = data                          # my-children format
		elif data is Dictionary and data.has("items"):
			children = data["items"]                 # pagedResponse format
	elif json is Array:
		children = json                              # direct array fallback

	if children.is_empty():
		selector_loading_lbl.text = "Không có học sinh nào."
		selector_loading_lbl.visible = true
		return

	for child in children:
		var btn := Button.new()
		var name_text: String = str(child.get("fullName", "Không tên"))
		var age_text:  String = str(child.get("age", "?"))
		btn.text = "👤  %s  (%s tuổi)" % [name_text, age_text]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.custom_minimum_size = Vector2(0, 48)
		btn.mouse_entered.connect(func(): _hover_btn(btn, true))
		btn.mouse_exited.connect(func():  _hover_btn(btn, false))
		btn.pressed.connect(_on_child_selected.bind(child))
		children_list.add_child(btn)

func _on_child_selected(child_data: Dictionary) -> void:
	# Set PlayerData
	PlayerData.childId      = int(child_data.get("id", 0))
	PlayerData.fullName     = str(child_data.get("fullName", ""))
	PlayerData.age          = int(child_data.get("age", 0))

	# Chuyển sang Bước 2
	child_selector_panel.visible = false
	session_list.get_parent().get_parent().visible = true
	child_name_label.text = "📁 Buổi học của: " + PlayerData.fullName

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
		lbl.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
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
	style.bg_color                     = Color(0.13, 0.15, 0.20, 1.0)
	style.border_width_left            = 3
	style.border_color                 = Color(0.3, 0.6, 1.0, 1.0)
	style.corner_radius_top_left       = 10
	style.corner_radius_top_right      = 10
	style.corner_radius_bottom_left    = 10
	style.corner_radius_bottom_right   = 10
	style.content_margin_left          = 16
	style.content_margin_top           = 12
	style.content_margin_right         = 16
	style.content_margin_bottom        = 12
	card.add_theme_stylebox_override("panel", style)

	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 16)
	card.add_child(hbox)

	var icon_lbl := Label.new()
	icon_lbl.text = "🎬"
	icon_lbl.add_theme_font_size_override("font_size", 28)
	hbox.add_child(icon_lbl)

	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(vbox)

	var name_lbl := Label.new()
	name_lbl.text = PlayerData.fullName
	name_lbl.add_theme_font_size_override("font_size", 15)
	name_lbl.add_theme_color_override("font_color", Color(0.9, 0.95, 1.0))
	vbox.add_child(name_lbl)

	var date_lbl := Label.new()
	date_lbl.text = "📅 %s   🗂 %s" % [created_at, folder_id]
	date_lbl.add_theme_font_size_override("font_size", 12)
	date_lbl.add_theme_color_override("font_color", Color(0.55, 0.65, 0.8))
	vbox.add_child(date_lbl)

	var play_btn := Button.new()
	play_btn.text = "▶  Xem lại"
	play_btn.custom_minimum_size = Vector2(110, 38)
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
		child_selector_panel.visible = true
		session_list.get_parent().get_parent().visible = false
	else:
		# Đang ở Bước 1 → quay về Login
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
