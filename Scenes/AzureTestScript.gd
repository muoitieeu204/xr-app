extends Node

@export var speechManager : Node
@export var recordButton : Button
@export var outputLabel : Label

func _ready() -> void:
	if(speechManager == null):
		printerr("Node not found, make sure to assign it!!")
		return
	recordButton.focus_mode = Control.FOCUS_NONE
	
	if not recordButton.pressed.is_connected(_on_button_pressed):
		recordButton.pressed.connect(_on_button_pressed)
	
	if speechManager.has_signal("onspeech_recognized"):
		speechManager.connect("onspeech_recognized", OnSpeechRecognize)
	elif speechManager.has_signal("OnspeechRecognized"):
		speechManager.connect("OnspeechRecognized", OnSpeechRecognize)
	else:
		printerr("ERROR: AzureSpeechManager signal not found!")

func _on_button_pressed() -> void:
	outputLabel.text = "Status: Listening"
	recordButton.disabled = true;
	speechManager.StartListening()

func OnSpeechRecognize(text: String) -> void:
	outputLabel.text = "Status: Heard " + text
	recordButton.text = "Recording Voice"
	recordButton.disabled = false

func _exit_tree() -> void:
	if(speechManager != null):
		if speechManager.is_connected("onspeech_recognized", OnSpeechRecognize):
			speechManager.disconnect("onspeech_recognized", OnSpeechRecognize)