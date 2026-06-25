extends Node

var itemDictionary = {
	"CartonSmall": "carton",
	"ChipBag" : "red wine",
	"ChipBagRed": "red chip bag"
}

var currentHeldItemId = ""
var validScannedItem = []

func _ready() -> void:
	var speechManager = get_node_or_null("/root/AzureSpeechManager")
	if speechManager:
		speechManager.OnSpeechRecognized.connect(_on_speech_recognized)

func _item_pickup(itemId: String):
	currentHeldItemId = itemId
	print("Player pickup: ", itemId, "- Please say the name!")
	var speechManager = get_node_or_null("/root/AzureSpeechManager")
	if speechManager:
		speechManager.StartListening()

func _item_dropped(pickable = null):
	print("Player dropped the item. Stopping check.")
	currentHeldItemId = ""
	var speechManager = get_node_or_null("/root/AzureSpeechManager")
	if speechManager and speechManager.has_method("StopListening"):
		speechManager.StopListening()

func _on_speech_recognized(text:String):
	var targetWord = itemDictionary.get(currentHeldItemId, "")
	if targetWord != "" and text.to_lower().contains(targetWord):
		validScannedItem.append(currentHeldItemId)
	else:
		print("Incorrect! You said: ", text)