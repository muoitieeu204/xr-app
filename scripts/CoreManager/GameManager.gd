extends Node

var currentHeldItemId = ""
var validScannedItem = []

signal speech_result(is_correct: bool)
signal profile_selected
func _ready() -> void:
	var speechManager = get_node_or_null("/root/AzureSpeechManager")
	if speechManager:
		speechManager.OnSpeechRecognized.connect(_on_speech_recognized)

func start_checkout_test(itemId: String):
	currentHeldItemId = itemId
	print("GameManager: Checkout test started for: ", itemId)
	var speechManager = get_node_or_null("/root/AzureSpeechManager")
	if speechManager:
		speechManager.StartListening()

func stop_checkout_test():
	print("GameManager: Checkout test stopped.")
	currentHeldItemId = ""
	var speechManager = get_node_or_null("/root/AzureSpeechManager")
	if speechManager and speechManager.has_method("StopListening"):
		speechManager.StopListening()

func _on_speech_recognized(text:String):
	if currentHeldItemId != "":
		var cleanText = text.to_lower().replace(",","").replace(".","").replace("?","").replace("!","")
		var cleanTarget = currentHeldItemId.to_lower()
		if cleanText.contains(cleanTarget):
			print("Correct! Word matched: ", currentHeldItemId)
			validScannedItem.append(currentHeldItemId)
			emit_signal("speech_result", true)
		else:
			print("Incorrect! You said: ", text, " | We cleaned it it to: ", cleanText)
			emit_signal("speech_result", false) 