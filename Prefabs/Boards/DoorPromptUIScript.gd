extends Control

@onready var statusLabel = %Label
@onready var recordButton = %Button
                                                                                                                                                                                                                                 
func _ready() -> void:
        # Connect to Azure so we can update the UI when speech is done!                                                                                                                                                          
        var speech_manager = get_node_or_null("/root/AzureSpeechManager")
        if speech_manager:
            speech_manager.connect("OnSpeechRecognized", Callable(self , "_on_speech_recognized"))
            speech_manager.connect("OnSpeechFailed", Callable(self , "_on_speech_failed"))
                                                                                                                                                                                                                                 
        if statusLabel:
            statusLabel.text = "Press the button and say: Mở cửa"
                                                                                                                                                                                                                                 
    # Connect your Godot Button's 'pressed' signal to this!                                                                                                                                                                      
func _on_record_button_pressed() -> void:
        recordButton.disabled = true
        statusLabel.text = "Listening... Speak now!"
        statusLabel.modulate = Color.WHITE
                                                                                                                                                                                                                                 
        get_node("/root/AzureSpeechManager").StartListening()
                                                                                                                                                                                                                                 
func _on_speech_recognized(spoken_text: String) -> void:
        recordButton.disabled = false
                                                                                                                                                                                                                                 
        var text_lower = spoken_text.to_lower()
        if text_lower.contains("mở cửa") or text_lower.contains("đóng cửa"):
            statusLabel.text = "Command Executed!"
            statusLabel.modulate = Color.GREEN
        else:
            statusLabel.text = "Wrong command. You said: " + spoken_text
            statusLabel.modulate = Color.RED
                                                                                                                                                                                                                                 
func _on_speech_failed(reason: String) -> void:
        recordButton.disabled = false
        statusLabel.text = "Could not hear you. Try again!"
        statusLabel.modulate = Color.YELLOW
