extends Node

var apiUrl : String = "https://103-162-31-23.sslip.io/api/results/submit"
var httpRequest : HTTPRequest

# --- ALL API PAYLOAD FIELDS ---
# var sessionId: String = ""
# var childId: int = 0
# var exerciseId: int = 0
# var lessonId: int = 0
# var attemptNumber: int = 0
# var completionStatus: String = ""
# var score: int = 0
# var startedAt: String = ""
# var completedAt: String = ""  
# var durationSeconds: int = 0
# var interactionLog: String = ""
# var feedbackText: String = ""


func _ready() -> void:
	httpRequest = HTTPRequest.new()
	add_child(httpRequest)
	httpRequest.request_completed.connect(_on_request_complete)

func _level_type(data: Dictionary) -> void:
	if LevelController.isLesson == true:
		data["lessonId"] = LevelController.levelId
	else: 
		data["exerciseId"] = LevelController.levelId

func send_result(data_to_send:Dictionary) -> void:
	#Inject lessonId/exerciseId 
	_level_type(data_to_send)
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
	
	httpRequest.set_tls_options(TLSOptions.client_unsafe())
	httpRequest.request(apiUrl, headers, HTTPClient.METHOD_POST, json)

func _on_request_complete(result, responseCode, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Connection error while submitting result!")
		return
		
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	if json != null and json.has("success") and json["success"] == true:
		print("Successfully submitted result! Server message: ", json["message"])
	else:
		push_error("Failed to submit result. Response Code: ", responseCode, " Body: ", body.get_string_from_utf8())