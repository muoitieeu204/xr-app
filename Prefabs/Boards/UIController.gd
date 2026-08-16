extends Control

@onready var titleLabel : Label = $MarginContainer/VBoxContainer/Label2
@export var titleLabelText : String = "Please say: "
@export var targetWord : String = "":
	set(value):
		targetWord = value
		# When the Viewport pushes the new word, update the label immediately!
		if is_inside_tree() and titleLabel != null:
			titleLabel.text = titleLabelText

# This grabs the node with the AzureSpeechChecker.gd script
@onready var speechChecker = %CheckerBoardController

func _ready() -> void:
	if titleLabel == null:
		printerr("ERROR: titleLabel is empty! Please assign it in the Inspector on the right.")
		
	# 1. Update the label just in case
	if titleLabel != null:
		titleLabel.text = titleLabelText
		
	# 2. Safety check to make sure the Checker node exists
	if speechChecker == null:
		printerr("ERROR: Could not find %CheckerBoardController! Did you set it as a Unique Node?")
		return
		
	# 3. PASS the word to the checker!
	speechChecker.assignWord = targetWord
