extends Node

# Autoload script: refreshes the accessToken once, 10 minutes after login.
# Add this to Project Settings -> Autoload as "RefreshTokenApi"

var refresh_url : String = "https://103-162-31-23.sslip.io/api/auth/refresh-token"
var http_request : HTTPRequest
var refresh_timer : Timer

# Refresh once after 10 minutes
var refresh_delay_sec : float = 9 * 60

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_refresh_completed)
	
	refresh_timer = Timer.new()
	refresh_timer.wait_time = refresh_delay_sec
	refresh_timer.one_shot = true
	refresh_timer.autostart = false
	add_child(refresh_timer)
	refresh_timer.timeout.connect(_on_timer_timeout)

func start_refresh_timer():
	# Call this once after a successful login
	print_debug("RefreshTokenApi: Will refresh token in ", refresh_delay_sec, " seconds")
	refresh_timer.start()

func stop_refresh_timer():
	# Call this on logout
	refresh_timer.stop()
	print_debug("RefreshTokenApi: Timer cancelled")

func _on_timer_timeout():
	print_debug("RefreshTokenApi: 10 minutes passed, refreshing token now...")
	_do_refresh()

func _do_refresh():
	if SessionData.accessToken == "" or SessionData.refreshToken == "":
		print_debug("RefreshTokenApi: No tokens to refresh!")
		return
	
	var data_to_send = {
		"accessToken": SessionData.accessToken,
		"refreshToken": SessionData.refreshToken
	}
	var json_body = JSON.stringify(data_to_send)
	
	var headers = [
		"Authorization: Bearer " + SessionData.accessToken,
		"Content-Type: application/json",
		"accept: */*"
	]
	
	http_request.set_tls_options(TLSOptions.client_unsafe())
	http_request.request(refresh_url, headers, HTTPClient.METHOD_POST, json_body)

func _on_refresh_completed(result, responseCode, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		print_debug("RefreshTokenApi: HTTP request failed!")
		return
	
	if responseCode != 200:
		print_debug("RefreshTokenApi: Server returned ", responseCode)
		return
	
	var body_string = body.get_string_from_utf8()
	var json = JSON.parse_string(body_string)
	
	if json == null:
		print_debug("RefreshTokenApi: Failed to parse JSON")
		return
	
	if json.has("success") and json["success"] == true:
		SessionData.accessToken = json["data"]["accessToken"]
		SessionData.refreshToken = json["data"]["refreshToken"]
		print_debug("RefreshTokenApi: Tokens refreshed successfully!")
	else:
		print_debug("RefreshTokenApi: Refresh failed - ", json.get("message", "Unknown error"))
