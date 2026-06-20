extends Node

@export var speechManager : Node
@export var recordButton : Button
@export var outputLabel : Label

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
	outputLabel.text = "Status: Listening"
	recordButton.disabled = true;
	speechManager.StartListening()

func _on_speech_recognized(text: String) -> void:
	recordButton.disabled = false
	recordButton.text = "Press to Speak"
	var resultWord = text.to_lower()
	var targetWord = assignWord.to_lower()
	if resultWord.contains(targetWord):
		outputLabel.text = "Correct! You said: " + text
		recordButton.text = "Correct"
		recordButton.modulate = Color.GREEN
	else:
		outputLabel.text = "Wrong! You said: " + text
		recordButton.modulate = Color.RED

func _on_speech_failed(reason:String) -> void:
	recordButton.disabled = false
	recordButton.text = "Press to Speak"
	outputLabel.text = "Cannot hear you clearly, please try again!"
	outputLabel.modulate = Color.YELLOW 
	recordButton.modulate = Color.YELLOW