extends Node

@onready var statusLabel = $VBoxContainer/StatusLabel
@onready var recordBtn = $VBoxContainer/StartRecordingButton
@onready var chunkBtn = $VBoxContainer/StartChunkRecordButton

@export var micController: Node
@export var micNode: AudioStreamPlayer

var chunkIndex: int = 0
var isFinalChunk: bool = false

var childProfileId: int = 0
var sessionId: String = "TestSession2"
var chunkSavePath: String = ""
var token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjUiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJidWRnZXRwYzUwMEBnbWFpbC5jb20iLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiTXVvaVRpZWV1IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiUGFyZW50IiwiZXhwIjoxNzg1OTM4NDIyLCJpc3MiOiJHb2RvdFhSIiwiYXVkIjoiR29kb3RYUiJ9.eeuwpJiupC6C63jtIg_Xc_3lY55dJuQTZ5OPYpP39W8"

func _on_start_recording_toggled(toggled_on: bool) -> void:
	chunkBtn.disabled = not toggled_on
	if toggled_on:
		statusLabel.text = "Status: Session Recording"
		chunkIndex = 0
		micController.start_record()
	else:
		statusLabel.text = "Status: Idle"
		micController.stop_record_and_save()
		if chunkBtn.button_pressed:
			chunkBtn.button_pressed = false

func _on_start_chunk_record_toggled(toggled_on: bool) -> void:
	if toggled_on:
		statusLabel.text = "Status: Chunk " + str(chunkIndex) + " Recording"
		micController.start_chunk_record()
	else:
		statusLabel.text = "Status: Session Recording"
		var savedPath = await micController.stop_chunk_record_and_save()
		if savedPath == "":
			printerr("Error: No chunk was recorded or saved!")
			return
		chunkSavePath = savedPath
		_on_chunk_ready_to_upload()
		chunkIndex += 1
func _on_chunk_ready_to_upload():
	isFinalChunk = not recordBtn.pressed
	print("Ready to upload chunk: ", chunkIndex, " Final: ", isFinalChunk)
	FilesChunksApi.UploadChunkAsync(childProfileId, sessionId, chunkIndex, chunkSavePath, isFinalChunk, token)
