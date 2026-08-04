extends Node

@onready var statusLabel = $VBoxContainer/StatusLabel
@onready var recordBtn = $VBoxContainer/StartRecordingButton
@onready var chunkBtn = $VBoxContainer/StartChunkRecordButton

@export var micController: Node
@export var micNode: AudioStreamPlayer

var chunkIndex: int = 0
var isFinalChunk: bool = false

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
			chunkBtn.pressed = false

func _on_start_chunk_record_toggled(toggled_on: bool) -> void:
	if toggled_on:
		statusLabel.text = "Status: Chunk" + str(chunkIndex) + " Recording"
		micController.start_chunk_record()
	else:
		statusLabel.text = "Status: Session Recording"
		micController.stop_chunk_record_and_save()
	
func _on_chunk_ready_to_upload():
	var isFinalChunk = not recordBtn.pressed
	print("Ready to upload chunk: ", chunkIndex, " Final: ", isFinalChunk)
