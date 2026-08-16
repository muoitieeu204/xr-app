extends Node

## FilesApi — Wrap các endpoint /api/files
## Dùng làm Autoload HOẶC gọi trực tiếp từ scene

const BASE_URL := "https://103-162-30-111.sslip.io/api/files"

signal sessions_loaded(sessions: Array)
signal sessions_load_failed(error: String)
signal metadata_downloaded(save_path: String)
signal audio_downloaded(save_path: String)
signal download_failed(error: String)

var _http_list: HTTPRequest
var _http_meta: HTTPRequest
var _http_audio: HTTPRequest

func _ready() -> void:
	_http_list  = _make_http()
	_http_meta  = _make_http()
	_http_audio = _make_http()
	_http_list.request_completed.connect(_on_list_completed)
	_http_meta.request_completed.connect(_on_meta_completed)
	_http_audio.request_completed.connect(_on_audio_completed)

func _make_http() -> HTTPRequest:
	var h := HTTPRequest.new()
	add_child(h)
	return h

func _auth_headers() -> PackedStringArray:
	return PackedStringArray([
		"Authorization: Bearer " + SessionData.accessToken,
		"accept: application/json"
	])

# ------------------------------------------------------------------
# GET /api/files/{childProfileId}
# ------------------------------------------------------------------
func fetch_sessions(child_profile_id: int) -> void:
	var url := BASE_URL + "/" + str(child_profile_id)
	var err := _http_list.request(url, _auth_headers(), HTTPClient.METHOD_GET)
	if err != OK:
		sessions_load_failed.emit("Không thể gửi yêu cầu (lỗi %d)" % err)

func _on_list_completed(result: int, code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or code != 200:
		sessions_load_failed.emit("Lỗi server (HTTP %d)" % code)
		return
	var json = JSON.parse_string(body.get_string_from_utf8())
	if json == null:
		sessions_load_failed.emit("Phản hồi không hợp lệ từ server")
		return
	# Tuỳ API trả về: { "data": [...] } hoặc mảng thẳng
	var list: Array = []
	if json is Array:
		list = json
	elif json is Dictionary and json.has("data"):
		list = json["data"]
	sessions_loaded.emit(list)

# ------------------------------------------------------------------
# GET /api/files/{childProfileId}/{folderId}/downloadmetadata
# Lưu thẳng bytes xuống user://
# ------------------------------------------------------------------
var _meta_save_path: String = ""

func download_metadata(child_profile_id: int, folder_id: String) -> void:
	_meta_save_path = "user://session_meta_%s.json" % folder_id
	var url := "%s/%d/%s/downloadmetadata" % [BASE_URL, child_profile_id, folder_id]
	var err := _http_meta.request(url, _auth_headers(), HTTPClient.METHOD_GET)
	if err != OK:
		download_failed.emit("Không thể download metadata (lỗi %d)" % err)

func _on_meta_completed(result: int, code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or code != 200:
		download_failed.emit("Lỗi download metadata (HTTP %d)" % code)
		return
	var file := FileAccess.open(_meta_save_path, FileAccess.WRITE)
	if file == null:
		download_failed.emit("Không thể ghi file metadata")
		return
	file.store_buffer(body)
	file.close()
	print("FilesApi: metadata saved → ", _meta_save_path)
	metadata_downloaded.emit(_meta_save_path)

# ------------------------------------------------------------------
# GET /api/files/{childProfileId}/{folderId}/downloadaudio
# Lưu thẳng bytes xuống user://
# ------------------------------------------------------------------
var _audio_save_path: String = ""

func download_audio(child_profile_id: int, folder_id: String) -> void:
	_audio_save_path = "user://session_audio_%s.wav" % folder_id
	var url := "%s/%d/%s/downloadaudio" % [BASE_URL, child_profile_id, folder_id]
	var err := _http_audio.request(url, _auth_headers(), HTTPClient.METHOD_GET)
	if err != OK:
		download_failed.emit("Không thể download audio (lỗi %d)" % err)

func _on_audio_completed(result: int, code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or code != 200:
		download_failed.emit("Lỗi download audio (HTTP %d)" % code)
		return
	var file := FileAccess.open(_audio_save_path, FileAccess.WRITE)
	if file == null:
		download_failed.emit("Không thể ghi file audio")
		return
	file.store_buffer(body)
	file.close()
	print("FilesApi: audio saved → ", _audio_save_path)
	audio_downloaded.emit(_audio_save_path)
