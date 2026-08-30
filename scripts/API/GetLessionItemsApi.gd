extends Node

#Need to update api, current api is for testing per lesson only 
var apiUrl: String = "https://103-162-30-111.sslip.io/api/lesson-slots/1"
var httpRequest: HTTPRequest

signal exercise_data_loaded(data: Array)
signal exercise_data_load_failed(error: String)

func _ready() -> void:
	httpRequest = HTTPRequest.new()
	add_child(httpRequest)
	httpRequest.request_completed.connect(_on_fetch_completed)

func fetch_exercise_data()-> void:
	var headers := [
		"Authorization: Bearer " + SessionData.accessToken,
		"accept: application/json"
	]
	var response = httpRequest.request(apiUrl, headers, HTTPClient.METHOD_GET)
	if response != OK:
		exercise_data_load_failed.emit("Không thể kết nối API Results (lỗi %d)" % response)

func _on_fetch_completed(result: int, responseCode: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		exercise_data_load_failed.emit("Lỗi kết nối mạng!")
		return
	
	if responseCode != 200:
		exercise_data_load_failed.emit("Lỗi server (HTTP %d)" % responseCode)
		return
		
	var response_text = body.get_string_from_utf8()
	var json = JSON.parse_string(response_text)
	if json == null:
		exercise_data_load_failed.emit("Phản hồi không hợp lệ từ server")
		return
		
	if json is Dictionary and json.get("success", false) == true:
		var data = json.get("data", [])
		if data is Array:
			ExerciseData.set_data(data) 
			exercise_data_loaded.emit(data)
			return
	
	exercise_data_load_failed.emit(json.get("message", "Lấy dữ liệu thất bại"))

