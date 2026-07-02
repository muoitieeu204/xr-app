extends Node

var apiUrl : String = "https://103-162-31-23.sslip.io/api/results/submit"
var httpRequest : HTTPRequest

# --- ALL API PAYLOAD FIELDS ---
# (Comment out or delete the ones you don't need to send to the server)
var sessionId: String = ""
var childId: int = 1
var exerciseId: int = 1
var lessonId: int = 1
var attemptNumber: int = 1
var completionStatus: String = "Completed"
var score: int = 0
var startedAt: String = Time.get_datetime_string_from_system()
var completedAt: String = Time.get_datetime_string_from_system()  
var durationSeconds: int = 0  
var audioRecordUrl: String = ""
var replayDataUrl: String = ""
var interactionLog: String = ""
var feedbackText: String = ""
var isFinalized: bool = true
var audioStatus: String = "unavailable"
var replayStatus: String = "unavailable"
var hasReplayData: bool = false
var hasAudioData: bool = false
var pronunciationDetails: Array = []
var eventLogs: Array = []

func _ready() -> void:
	httpRequest = HTTPRequest.new()
	add_child(httpRequest)
	httpRequest.request_completed.connect(_on_request_complete)
	_on_send_result()

	
func _on_send_result() -> void:
	var data_to_send = {
		"sessionId": sessionId,
		"childId": childId,
		"exerciseId": exerciseId,
		# "lessonId": lessonId,
		"attemptNumber": attemptNumber,
		"completionStatus": completionStatus,
		"score": score,
		"startedAt": startedAt,
		"completedAt": completedAt,
		"durationSeconds": durationSeconds,
		"audioRecordUrl": audioRecordUrl,
		"replayDataUrl": replayDataUrl,
		"interactionLog": interactionLog,
		"feedbackText": feedbackText,
		"isFinalized": isFinalized,
		"audioStatus": audioStatus,
		"replayStatus": replayStatus,
		"hasReplayData": hasReplayData,
		"hasAudioData": hasAudioData,
		"pronunciationDetails": pronunciationDetails,
		"eventLogs": eventLogs
	}
	
	var json = JSON.stringify(data_to_send)
	var headers = [
		"Authorization: Bearer " + "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjI2IiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvZW1haWxhZGRyZXNzIjoiYnVkZ2V0cGM1MDBAZ21haWwuY29tIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZSI6Ik5ndXnhu4VuIFbEg24gQSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IlBhcmVudCIsImV4cCI6MTc4MzAwNjM1NSwiaXNzIjoiR29kb3RYUiIsImF1ZCI6IkdvZG90WFIifQ.62QOYxJbGHJK8cm7ueDytBihXTGl6PoYQBlEZxfmFq4",
		"accept: application/json",
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