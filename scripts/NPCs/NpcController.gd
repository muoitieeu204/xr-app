extends Node3D

@export_group("NPC Character")
@export var npc_audio_player: AudioStreamPlayer3D
@export var npc_animation_player: AnimationPlayer
@export var question_1_audio: AudioStream
@export var correct_audio: Array[AudioStream]
@export var wrong_audio: Array[AudioStream]
@export var body_to_breathe: Node3D # Assign the Skeleton3D or Mesh here in the inspector

@export_group("NPC Guide")
@export var npc_record_indicator: MeshInstance3D
@export var npc_label_indicator: Label3D

var breath_time: float = 0.0

var current_item_id = ""
var current_hint_audio = null
var current_item_name_audio = null
var failed_attempts = 0
static var activeTeacher = null
var chunkIndex: int = 0
var isFinalChunk: bool = false

func _ready():
	var gameManager = get_node_or_null("/root/GameManager")
	if gameManager:
		gameManager.connect("speech_result", Callable(self, "_on_speech_result"))
		gameManager.connect("play_npc_teaching_audio", Callable(self, "_on_play_npc_teaching_audio"))
	if npc_record_indicator:
		npc_record_indicator.visible = false
	if npc_label_indicator:
		npc_label_indicator.visible = false
func _process(delta):
	# Procedurally animate breathing so they don't look like a statue
	if body_to_breathe:
		breath_time += delta
		var breath = sin(breath_time * 2.5) # Speed of breathing
		# Subtle stretch and squash
		body_to_breathe.scale.y = 1.0 + (breath * 0.015)
		body_to_breathe.scale.x = 1.0 + (breath * 0.005)
		body_to_breathe.scale.z = 1.0 + (breath * 0.005)

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

	var micController = get_tree().get_first_node_in_group("MicController")
	if micController:
		micController.start_chunk_record()
	
		#Wait 0.5s to start capture child voice before start record
		await get_tree().create_timer(0.5).timeout

	var gameManager = get_node_or_null("/root/GameManager")
	if gameManager:
		gameManager.start_checkout_test(current_item_id)
	if micController:
		npc_record_indicator.visible = true
	if npc_label_indicator:
		npc_label_indicator.visible = true
		npc_label_indicator.text = "🗣️ " + current_item_id

func ask_question_2():
	if npc_audio_player and current_hint_audio:
		npc_audio_player.stream = current_hint_audio
		npc_audio_player.play()
		await npc_audio_player.finished
	
	var micController = get_tree().get_first_node_in_group("MicController")
	if micController:
		micController.start_chunk_record()
		
		#Wait 0.5s to start capture child voice before start record
		await get_tree().create_timer(0.5).timeout

	var gameManager = get_node_or_null("/root/GameManager")
	if gameManager:
		gameManager.start_checkout_test(current_item_id)
	if micController:
		npc_record_indicator.visible = true
	if npc_label_indicator:
		npc_label_indicator.visible = true
		npc_label_indicator.text = "🗣️ " + current_item_id

func _on_speech_result(is_correct: bool):
	# If this NPC isn't the one who scanned the item, ignore the signal!
	if activeTeacher != self:
		return
	
	#Wait 0.5s to capture the end of child voice before stop record 
	await get_tree().create_timer(0.5).timeout
	var micController = get_tree().get_first_node_in_group("MicController")
	if micController:
		var savedPath = await micController.stop_chunk_record_and_save()
		npc_record_indicator.visible = false
		if savedPath != "":
			isFinalChunk = is_correct or (failed_attempts >= 1)
			FilesChunksApi.UploadChunkAsync(PlayerData.childId, SessionData.sessionId, chunkIndex, savedPath, isFinalChunk, SessionData.accessToken)
			chunkIndex += 1
	if is_correct:
		print("NPC: Correct! Great job!")
		if npc_audio_player and correct_audio.size() > 0:
			npc_audio_player.stream = correct_audio.pick_random()
			npc_audio_player.play()
		if npc_animation_player and npc_animation_player.has_animation("emote-yes"):
			npc_animation_player.play("emote-yes")
		_on_child_correct_answer()
		if npc_label_indicator:
			npc_label_indicator.visible = true
			npc_label_indicator.text = "✅" + " bé đã nói đúng rồi"
	else:
		failed_attempts += 1
		print("NPC: That's not right. Attempt ", failed_attempts)
		if npc_audio_player and wrong_audio.size() > 0:
			npc_audio_player.stream = wrong_audio.pick_random()
			npc_audio_player.play()
			if npc_animation_player and npc_animation_player.has_animation("emote-no"):
				npc_animation_player.play("emote-no")
			await npc_audio_player.finished
		_on_child_wrong_answer()
		if npc_label_indicator:
			npc_label_indicator.visible = true
			npc_label_indicator.text = "❌" + " bé đã nói sai rồi "
		if failed_attempts == 1:
			ask_question_2()
		else:
			print("NPC: Failed again. Let's move on or give the direct answer!")
	#Delay 2s before hide text 
	await get_tree().create_timer(2).timeout
	if npc_label_indicator:
		npc_label_indicator.visible = false
		npc_label_indicator.text = ""

func _on_child_correct_answer():
	get_tree().call_group("LevelController", "CorrectAnswer", 10, current_item_id)

func _on_child_wrong_answer():
	pass

func _on_play_npc_teaching_audio(audio_stream: AudioStream):
	if npc_audio_player and audio_stream:
		if not npc_audio_player.playing:
			npc_audio_player.stream = audio_stream
			npc_audio_player.play()