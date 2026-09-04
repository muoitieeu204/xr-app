extends Node
var apiUrl: String = ApiConfig.baseUrl + "/api/results/submit"
var httpRequest: HTTPRequest

signal results_loaded(results: Array)
signal results_load_failed(error: String)

var _fetch_request: HTTPRequest

func _ready() -> void:
	httpRequest = HTTPRequest.new()
	add_child(httpRequest)
	httpRequest.request_completed.connect(_on_request_complete)
	
	_fetch_request = HTTPRequest.new()
	add_child(_fetch_request)
	_fetch_request.request_completed.connect(_on_fetch_completed)


func fetch_results(child_id: int) -> void:
	var url := ApiConfig.baseUrl + "/api/results/by-child/" + str(child_id)
	var headers = [
		"Authorization: Bearer " + SessionData.accessToken,
		"Accept: application/json"
	]
	var err = _fetch_request.request(url, headers, HTTPClient.METHOD_GET)
	if err != OK:
		results_load_failed.emit("Không thể kết nối API Results (lỗi %d)" % err)

func _on_fetch_completed(result: int, responseCode: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		results_load_failed.emit("Lỗi kết nối mạng!")
		return
	
	if responseCode != 200:
		results_load_failed.emit("Lỗi server (HTTP %d)" % responseCode)
		return
		
	var response_text = body.get_string_from_utf8()
	var json = JSON.parse_string(response_text)
	if json == null:
		results_load_failed.emit("Phản hồi không hợp lệ từ server")
		return
		
	if json is Dictionary and json.get("success", false) == true:
		var data = json.get("data", [])
		if data is Array:
			results_loaded.emit(data)
			return
	
	results_load_failed.emit(json.get("message", "Lấy dữ liệu thất bại"))


func send_result(data_to_send: Dictionary) -> void:
	#Inject lessonId/exerciseId 
	# completedAt = Time.get_datetime_string_from_system()
	# var data_to_send = {
	# 	"sessionId": sessionId,
	# 	"childId": childId,
	# 	"attemptNumber": attemptNumber,
	# 	"completionStatus": completionStatus,
	# 	"score": score,
	# 	"startedAt": startedAt,
	# 	"completedAt": completedAt,
	# 	"durationSeconds": durationSeconds,
	# 	"interactionLog": interactionLog,
	# 	"feedbackText": feedbackText
	# }
	var json = JSON.stringify(data_to_send)
	var headers = [
		"Authorization: Bearer " + SessionData.accessToken,
		"Content-Type: application/json"
	]
	
	# httpRequest.set_tls_options(TLSOptions.client_unsafe())
	var err = httpRequest.request(apiUrl, headers, HTTPClient.METHOD_POST, json)
	if err != OK:
		print("CRITICAL ERROR: Godot refused to send! Error Code: ", err)
	else:
		print("SUCCESS: Request successfully left Godot! Waiting for server...")

func _on_request_complete(result, responseCode, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Connection error while submitting result!")
		return
		
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	if json != null and json.has("success") and json["success"] == true:
		print("Successfully submitted result! Server message: ", json["message"])
	else:
		push_error("Failed to submit result. Response Code: ", responseCode, " Body: ", body.get_string_from_utf8())
