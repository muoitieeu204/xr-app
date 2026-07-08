extends Node3D

@export var npc_audio_player : AudioStreamPlayer3D
@export var npc_animation_player : AnimationPlayer
@export var question_1_audio : AudioStream

var current_item_id = ""
var current_hint_audio = null
var failed_attempts = 0
static var activeTeacher = null

func _ready():
	var gameManager = get_node_or_null("/root/GameManager")
	if gameManager:
		gameManager.connect("speech_result", Callable(self, "_on_speech_result"))

# YOU MUST CONNECT THE CASH REGISTER'S 'item_scanned_for_teaching' SIGNAL TO THIS FUNCTION!
func _on_item_scanned_for_teaching(item_id: String, hint_audio: AudioStream):
	activeTeacher = self
	current_item_id = item_id
	current_hint_audio = hint_audio
	failed_attempts = 0
	
	print("NPC: Received item scan for ", current_item_id)
	ask_question_1()

func ask_question_1():
	if npc_audio_player and question_1_audio:
		npc_audio_player.stream = question_1_audio
		npc_audio_player.play()
		await npc_audio_player.finished
	
	var gameManager = get_node_or_null("/root/GameManager")
	if gameManager:
		gameManager.start_checkout_test(current_item_id)

func ask_question_2():
	if npc_audio_player and current_hint_audio:
		npc_audio_player.stream = current_hint_audio
		npc_audio_player.play()
		await npc_audio_player.finished
	
	var gameManager = get_node_or_null("/root/GameManager")
	if gameManager:
		gameManager.start_checkout_test(current_item_id)

func _on_speech_result(is_correct: bool):
	# If this NPC isn't the one who scanned the item, ignore the signal!
	if activeTeacher != self:
		return
		
	if is_correct:
		print("NPC: Correct! Great job!")
		if npc_animation_player and npc_animation_player.has_animation("emote-yes"):
			npc_animation_player.play("emote-yes")
			_on_child_correct_answer()
	else:
		failed_attempts += 1
		print("NPC: That's not right. Attempt ", failed_attempts)
		if npc_animation_player and npc_animation_player.has_animation("emote-no"):
			npc_animation_player.play("emote-no")
			_on_child_wrong_answer()

		if failed_attempts == 1:
			ask_question_2()
		else:
			print("NPC: Failed again. Let's move on or give the direct answer!")

func _on_child_correct_answer():
	get_tree().call_group("LevelController", "CorrectAnswer", 10)   

func _on_child_wrong_answer():
	get_tree().call_group("LevelController", "WrongAnswer", 5)   