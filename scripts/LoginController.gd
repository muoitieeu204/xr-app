extends Node

var apiUrl : String = "https://localhost:7153/api/auth/login"

@onready var httpRequest = $"../HTTPRequest"
@onready var emailInput = $"../VBoxContainer/Email"
@onready var passwordInput = $"../VBoxContainer/Password"
@onready var loginButton = $"../VBoxContainer/LoginButton"
@onready var passwordToggle = $"../VBoxContainer/Password/ShowPasswordToggle"
func _ready() -> void:
	loginButton.pressed.connect(_on_login_pressed)
	httpRequest.request_completed.connect(_on_request_completed)
	passwordToggle.toggled.connect(_on_show_password_toggle)

func _on_login_pressed() -> void:
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
	httpRequest.request(apiUrl,headers,HTTPClient.METHOD_POST, json)

func _on_show_password_toggle(button_pressed:bool) -> void:
	passwordInput.secret = not button_pressed

func _on_request_completed(result, responseCode, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json["success"] == true:
		SessionData.accessToken = json["data"]["accessToken"]
		SessionData.refreshToken = json["data"]["refreshToken"]
		SessionData.userId = json["data"]["user"]["id"]
		SessionData.fullName = json["data"]["user"]["fullName"]
		SessionData.userName = json["data"]["user"]["username"]
		SessionData.roleName = json["data"]["user"]["roleName"]
		SessionData.isActive = json["data"]["user"]["isActive"]
		print_debug(JSON.stringify(json, "\t"))
		print_debug("Successfully logged in as ", SessionData.fullName)
