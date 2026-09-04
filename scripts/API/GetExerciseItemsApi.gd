extends Node

#Need to update api, current api is for testing per lesson only 
var apiUrl: String = ApiConfig.baseUrl + "/api/lessons/%d/client-config"
var httpRequest: HTTPRequest

signal exercise_data_loaded(data: Array)
signal exercise_data_load_failed(error: String)

func _ready() -> void:
	httpRequest = HTTPRequest.new()
	add_child(httpRequest)
	httpRequest.request_completed.connect(_on_fetch_completed)

func fetch_exercise_data(lesson_id: int) -> void:
	var headers := [
		"Authorization: Bearer " + "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjEiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJhZG1pbkBnb2RvdHhyLmNvbSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiJTeXN0ZW0gQWRtaW4iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJBZG1pbiIsImV4cCI6MTc4ODYyMDg1NiwiaXNzIjoiR29kb3RYUiIsImF1ZCI6IkdvZG90WFIifQ.4kDbRmEZKMPHRg1ciaRwwak84iHyKAkqaTgqhUfidtg",
		"accept: application/json"
	]
	var url = apiUrl % lesson_id
	var response = httpRequest.request(url, headers, HTTPClient.METHOD_GET)
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
