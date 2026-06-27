extends Control

var apiUrl : String = "https://103-162-31-23.sslip.io/api/child-profiles/my-children"

@onready var httpRequest = $HTTPRequest
@onready var profilesContainer = $ProfileBox/VBoxContainer/ScrollContainer/ProfilesGrid
@onready var loadingLabel = $ProfileBox/VBoxContainer/LoadingLabel
@onready var templateButton = $ProfileBox/VBoxContainer/ScrollContainer/ProfilesGrid/TemplateButton

var children_data = []

func _ready():
	templateButton.visible = false
	loadingLabel.visible = true
	loadingLabel.text = "Đang tải danh sách..."
	
	httpRequest.request_completed.connect(_on_request_completed)
	
	# Wait until the AuthController makes this scene visible
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	if visible:
		print_debug("ChildProfileScene: NOW VISIBLE — fetching profiles...")
		# Clear old buttons if logging out and logging back in
		for child in profilesContainer.get_children():
			if child != templateButton:
				child.queue_free()
				
		loadingLabel.visible = true
		loadingLabel.text = "Đang tải danh sách..."
		fetch_child_profiles()
	else:
		print_debug("ChildProfileScene: hidden")

func fetch_child_profiles():
	print_debug("ChildProfileScene: accessToken = ", SessionData.accessToken.left(20), "...")
	# We MUST ONLY send the accessToken in the header
	var headers = [
		"Authorization: Bearer " + SessionData.accessToken,
		"accept: application/json"
	]
	
	# Allow unsafe localhost certificates in VR
	httpRequest.set_tls_options(TLSOptions.client_unsafe())
	var err = httpRequest.request(apiUrl, headers, HTTPClient.METHOD_GET)
	print_debug("ChildProfileScene: HTTP request sent, error code = ", err)

func _on_request_completed(result, responseCode, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		loadingLabel.text = "Lỗi kết nối máy chủ!"
		return
		
	if responseCode != 200:
		loadingLabel.text = "Lỗi xác thực (Mã " + str(responseCode) + ")"
		return
		
	var body_string = body.get_string_from_utf8()
	var json = JSON.parse_string(body_string)
	
	if json != null and json.has("success") and json["success"] == true:
		loadingLabel.visible = false
		children_data = json["data"]
		
		for child in children_data:
			var btn = templateButton.duplicate()
			btn.visible = true
			# Format: "Bé Gold\n(8 tuổi)"
			btn.text = "🧒 " + child["fullName"] + "\n(" + str(child["age"]) + " tuổi)"
			btn.pressed.connect(_on_profile_selected.bind(child))
			
			# Add hover animations exactly like login button
			btn.mouse_entered.connect(_on_btn_hover.bind(btn))
			btn.mouse_exited.connect(_on_btn_unhover.bind(btn))
			
			profilesContainer.add_child(btn)
	else:
		loadingLabel.text = "Không tìm thấy hồ sơ nào!"

func _on_profile_selected(child_data: Dictionary):
	# 1. MAP JSON TO AUTOLOAD SCRIPT
	PlayerData.child_id = child_data["id"]
	PlayerData.parent_user_id = child_data["userId"]
	PlayerData.full_name = child_data["fullName"]
	PlayerData.age = child_data["age"]
	PlayerData.gender = child_data["gender"]
	PlayerData.learning_level = child_data["learningLevel"]
	PlayerData.status = child_data["status"]
	
	print_debug("Selected child profile: ", PlayerData.full_name)
	
	# 2. TRANSITION TO GAME
	# Uncomment and update this to point to your actual store/game scene!
	get_tree().change_scene_to_file("res://Scenes/Worlds/StarterHub.tscn")
	print_debug("Ready to enter world!")

func _on_btn_hover(btn: Button) -> void:
	btn.pivot_offset = btn.size / 2
	var tween = create_tween()
	tween.tween_property(btn, "scale", Vector2(1.05, 1.05), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_btn_unhover(btn: Button) -> void:
	var tween = create_tween()
	tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
