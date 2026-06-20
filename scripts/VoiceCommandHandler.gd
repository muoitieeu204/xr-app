extends Node

@export var doorCommand: Array[String]
@export var speechManager : Node
@export var recordButton : Button

signal doorCommandOpen
signal doorCommandClose
var assignWord: String = ""
func _ready() -> void:
	if(speechManager == null):
		printerr("Node not found, make sure to assign it!!")
		return
	

	recordButton.focus_mode = Control.FOCUS_NONE
	
	if not recordButton.pressed.is_connected(_on_button_pressed):
		recordButton.pressed.connect(_on_button_pressed)
	
	if speechManager:
		speechManager.connect("OnSpeechRecognized", Callable(self, "_on_speech_recognized"))
		speechManager.connect("OnSpeechFailed", Callable(self, "_on_speech_failed"))
	else:
		printerr("ERROR: AzureSpeechManager signal not found!")

func _on_button_pressed() -> void:
	recordButton.disabled = true;
	speechManager.StartListening()

func _on_speech_recognized(text: String) -> void:
	recordButton.disabled = false
	var resultWord = text.to_lower() 
	var foundMatch = false
	
	for targetWord in doorCommand:
		var target_lower = targetWord.to_lower()
		
		if resultWord.contains(target_lower):
			foundMatch = true
			if target_lower.contains("mở cửa"):
				doorCommandOpen.emit()
			elif target_lower.contains("đóng cửa"):
				doorCommandClose.emit()
			break 
	if foundMatch:
		recordButton.modulate = Color.GREEN
	else:
		recordButton.modulate = Color.RED

func _on_speech_failed(reason:String) -> void:
	recordButton.disabled = false
	recordButton.modulate = Color.YELLOW