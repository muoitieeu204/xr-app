extends Node

var apiUrl: String = ApiConfig.baseUrl + "/api/lessons"
var httpRequest: HTTPRequest

signal lesson_data_loaded(data: Array)
signal lesson_data_load_failed(error: String)

func _ready() -> void:
    httpRequest = HTTPRequest.new()
    add_child(httpRequest)
    httpRequest.request_completed.connect(_on_fetch_completed)

func fetch_lesson_data() -> void:
    var headers := [
        "Authorization: Bearer " + SessionData.accessToken,
		"accept: application/json"
    ]
    var response = httpRequest.request(apiUrl, headers, HTTPClient.METHOD_GET)
    if response != OK:
        lesson_data_load_failed.emit("Không thể kết nối API Results (lỗi %d)" % response)
    
func _on_fetch_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
    if result != HTTPRequest.RESULT_SUCCESS:
        lesson_data_load_failed.emit("Lỗi kết nối mạng!")
        return

    if response_code != 200:
        lesson_data_load_failed.emit("Lỗi server (HTTP %d)" % response_code)
        return
    
    var response_text = body.get_string_from_utf8()
    var json = JSON.parse_string(response_text)

    if json == null:
        lesson_data_load_failed.emit("Phản hồi không hợp lệ từ server")
        return
	
    if json is Dictionary and json.get("success", false) == true:
        var data = json.get("data", [])
        if data is Dictionary:
            var items = data.get("items", [])
            if items is Array:
                LessonData.set_data(items)
                lesson_data_loaded.emit(items)
                return
            
    lesson_data_load_failed.emit(json.get("message", "Lấy dữ liệu thất bại"))