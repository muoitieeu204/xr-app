extends Control

var apiUrl: String = "https://103-162-30-111.sslip.io/api/auth/login"
# var apiUrl : String = "https://localhost:7153/api/auth/login"

@onready var httpRequest = $LoginBox/HTTPRequest
@onready var emailInput = $LoginBox/VBoxContainer/Email
@onready var passwordInput = $LoginBox/VBoxContainer/Password
@onready var loginButton = $LoginBox/VBoxContainer/LoginButton
@onready var passwordToggle = $LoginBox/VBoxContainer/Password/ShowPasswordToggle
@onready var errorLabel = $LoginBox/VBoxContainer/ErrorLabel
@onready var forgotButton = $LoginBox/VBoxContainer/ForgotButton
@onready var welcomeLabel = $WelcomeScene/WelcomeBox/VBoxContainer/Label2
@onready var logoutButton = $LogoutBox/VBoxContainer/LogoutButton
@onready var joinWorldButton = $WelcomeScene/WelcomeBox/VBoxContainer/Button

# New Forgot Password Nodes
@onready var forgotPasswordBox = get_node_or_null("ForgotPasswordBox")
@onready var forgotBackButton = get_node_or_null("ForgotPasswordBox/VBoxContainer/BackButton")

@onready var childProfileScene = get_node_or_null("ChildProfileBox")

@onready var rememberMeCheckbox = get_node_or_null("LoginBox/VBoxContainer/RememberMe")

signal join_world_requested

func _ready() -> void:
	loginButton.pressed.connect(_on_login_pressed)
	httpRequest.request_completed.connect(_on_request_completed)
	passwordToggle.toggled.connect(_on_show_password_toggle)
	welcomeLabel.text = SessionData.fullName
	
	forgotButton.pressed.connect(_on_forgot_password_pressed)
	
	# Kids playful micro-animations (scale & tilt on hover)
	loginButton.mouse_entered.connect(_on_login_hover)
	loginButton.mouse_exited.connect(_on_login_unhover)
	forgotButton.mouse_entered.connect(_on_forgot_hover)
	forgotButton.mouse_exited.connect(_on_forgot_unhover)
	
	if joinWorldButton != null:
		joinWorldButton.pressed.connect(_on_join_world_pressed)
		joinWorldButton.mouse_entered.connect(_on_join_hover)
		joinWorldButton.mouse_exited.connect(_on_join_unhover)
		
	if forgotPasswordBox != null and forgotBackButton != null:
		forgotBackButton.pressed.connect(_on_forgot_back_pressed)
		forgotBackButton.mouse_entered.connect(_on_forgot_back_hover)
		forgotBackButton.mouse_exited.connect(_on_forgot_back_unhover)
		forgotPasswordBox.visible = false

	if childProfileScene != null:
		childProfileScene.visible = false
		var cpLogout = childProfileScene.get_node_or_null("ProfileBox/VBoxContainer/LogoutButton")
		if cpLogout != null:
			cpLogout.pressed.connect(_on_logout_button_pressed)

	$LoginBox.visible = true
	$WelcomeScene.visible = false
	$LogoutBox.visible = false

	if logoutButton == null:
		printerr("Node not found, make sure to assign in the inspector!")
	else:
		logoutButton.pressed.connect(_on_logout_button_pressed)
		
		_check_auto_login()

func _check_auto_login():
	if FileAccess.file_exists("user://auth.save"):
		var file = FileAccess.open("user://auth.save", FileAccess.READ)
		var saved_email = file.get_line()
		var saved_password = file.get_line()
		file.close()
		
		if saved_email != "" and saved_password != "":
			print_debug("Found saved credentials, auto-logging in...")
			emailInput.text = saved_email
			passwordInput.text = saved_password
			if rememberMeCheckbox != null:
				rememberMeCheckbox.button_pressed = true
			_on_login_pressed()

func _on_login_pressed() -> void:
	print_debug("Login button was pressed! Sending request...")
	if errorLabel != null:
		errorLabel.visible = false
		
	loginButton.disabled = true
	if forgotButton != null:
		forgotButton.disabled = true
	
	var emailText = emailInput.text
	var passwordText = passwordInput.text
	var data_to_send = {
		"email": emailText,
		"password": passwordText
	}
	var json = JSON.stringify(data_to_send)
	var headers = [
		"accept: text/plain",
		"Content-Type: application/json"
	]
	
	# Allow unsafe localhost certificates in VR
	# httpRequest.set_tls_options(TLSOptions.client_unsafe())
	httpRequest.request(apiUrl, headers, HTTPClient.METHOD_POST, json)

func _on_show_password_toggle(button_pressed: bool) -> void:
	passwordInput.secret = not button_pressed

func _on_request_completed(result, responseCode, headers, body):
	print_debug("Request completed! Result code: ", result, " HTTP Status: ", responseCode)
	
	loginButton.disabled = false
	if forgotButton != null:
		forgotButton.disabled = false
	
	if result != HTTPRequest.RESULT_SUCCESS:
		print_debug("HTTP Request failed completely! Make sure server is running.")
		return
		
	if responseCode == 401:
		print_debug("Unauthorized: Incorrect email or password.")
		if errorLabel != null:
			errorLabel.text = "Sai email hoặc password."
			errorLabel.visible = true
		return
		
	var body_string = body.get_string_from_utf8()
	var json = JSON.parse_string(body_string)
	
	if json == null:
		print_debug("Failed to parse JSON response: ", body_string)
		return
		
	if json.has("success") and json["success"] == true:
		SessionData.accessToken = json["data"]["accessToken"]
		SessionData.refreshToken = json["data"]["refreshToken"]
		SessionData.userId = json["data"]["user"]["id"]
		SessionData.fullName = json["data"]["user"]["fullName"]
		SessionData.roleName = json["data"]["user"]["roleName"]
		SessionData.isActive = json["data"]["user"]["isActive"]
		print_debug(JSON.stringify(json, "\t"))
		print_debug("Successfully logged in as ", SessionData.fullName)
		RefreshTokenApi.start_refresh_timer()
		# Save credentials if Remember Me is checked
		if rememberMeCheckbox != null and rememberMeCheckbox.button_pressed:
			var file = FileAccess.open("user://auth.save", FileAccess.WRITE)
			file.store_line(emailInput.text)
			file.store_line(passwordInput.text)
			file.close()

		welcomeLabel.text = SessionData.fullName
		$LoginBox.visible = false
		$WelcomeScene.visible = false
		$LogoutBox.visible = false

		# --- ROLE-BASED ROUTING ---
		if SessionData.roleName == "Teacher":
			# Teacher: chuyển thẳng sang SessionListScene (chọn trẻ trong đó)
			print_debug("AuthController: Teacher detected → SessionListScene")
			get_tree().change_scene_to_file("res://Prefabs/UI/SessionListScene.tscn")
		elif childProfileScene != null:
			# Parent / Student: chọn hồ sơ trẻ như bình thường
			childProfileScene.visible = true
		else:
			$WelcomeScene.visible = true
			print_debug("WARNING: ChildProfileScene not found!")
	else:
		# If the API returned a failure (wrong password, etc.)
		print_debug("API returned success: false")
		if errorLabel != null:
			var msg = "Lỗi đăng nhập."
			if json.has("message"):
				msg = json["message"]
			errorLabel.text = msg
			errorLabel.visible = true
		
func _on_logout_button_pressed() -> void:
	SessionData.accessToken = ""
	SessionData.refreshToken = ""
	SessionData.userId = 0
	SessionData.fullName = ""
	SessionData.userName = ""
	SessionData.roleName = ""
	SessionData.isActive = false
	PlayerData.clear()
	print_debug("User Logout Successfully")
	
	# Clear auto-login save file
	if FileAccess.file_exists("user://auth.save"):
		var dir = DirAccess.open("user://")
		dir.remove("auth.save")
		emailInput.text = ""
		passwordInput.text = ""
		if rememberMeCheckbox != null:
			rememberMeCheckbox.button_pressed = false
	
	#Stop the refreshTokenApi
	RefreshTokenApi.stop_refresh_timer()
	$LoginBox.visible = true
	$WelcomeScene.visible = false
	$LogoutBox.visible = false
	if childProfileScene != null:
		childProfileScene.visible = false

func _on_login_hover() -> void:
	loginButton.pivot_offset = loginButton.size / 2
	var tween = create_tween().set_parallel(true)
	tween.tween_property(loginButton, "scale", Vector2(1.05, 1.05), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(loginButton, "rotation_degrees", 1.5, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_login_unhover() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(loginButton, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(loginButton, "rotation_degrees", 0.0, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_forgot_hover() -> void:
	forgotButton.pivot_offset = forgotButton.size / 2
	var tween = create_tween()
	tween.tween_property(forgotButton, "scale", Vector2(1.08, 1.08), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_forgot_unhover() -> void:
	var tween = create_tween()
	tween.tween_property(forgotButton, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_join_world_pressed() -> void:
	print_debug("Join World pressed! Loading world...")
	join_world_requested.emit()
func _on_join_hover() -> void:
	if joinWorldButton != null:
		joinWorldButton.pivot_offset = joinWorldButton.size / 2
		var tween = create_tween().set_parallel(true)
		tween.tween_property(joinWorldButton, "scale", Vector2(1.05, 1.05), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(joinWorldButton, "rotation_degrees", 1.5, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_join_unhover() -> void:
	if joinWorldButton != null:
		var tween = create_tween().set_parallel(true)
		tween.tween_property(joinWorldButton, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(joinWorldButton, "rotation_degrees", 0.0, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

# --- FORGOT PASSWORD LOGIC ---

func _on_forgot_password_pressed() -> void:
	if forgotPasswordBox != null:
		$LoginBox.visible = false
		forgotPasswordBox.visible = true
	else:
		print_debug("WARNING: ForgotPasswordBox not found! You need to drag ForgotPasswordScreen.tscn into your scene!")

func _on_forgot_back_pressed() -> void:
	if forgotPasswordBox != null:
		forgotPasswordBox.visible = false
		$LoginBox.visible = true

func _on_forgot_back_hover() -> void:
	if forgotBackButton != null:
		forgotBackButton.pivot_offset = forgotBackButton.size / 2
		var tween = create_tween()
		tween.tween_property(forgotBackButton, "scale", Vector2(1.05, 1.05), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_forgot_back_unhover() -> void:
	if forgotBackButton != null:
		var tween = create_tween()
		tween.tween_property(forgotBackButton, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
