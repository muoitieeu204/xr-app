extends Node
class_name MicController

signal audio_saved
signal chunk_audio_saved(saved_path: String)

@export var replayController: TelementryController

var record_effect: AudioEffectRecord
var chunk_record_effect: AudioEffectRecord
var recording: AudioStreamWAV
var chunk_recording: AudioStreamWAV
var threadSavePath : String = ""
var chunkThreadSavePath: String = ""
func _ready():
	var index = AudioServer.get_bus_index("ReplayMic")
	record_effect = AudioServer.get_bus_effect(index,0)

	if AudioServer.get_bus_effect_count(index) > 1:
		chunk_record_effect = AudioServer.get_bus_effect(index,1)

func start_record():
	if record_effect:
		record_effect.set_recording_active(true)

func start_chunk_record():
	if chunk_record_effect:
		chunk_record_effect.set_recording_active(true)
	
func stop_record_and_save():
	if record_effect and record_effect.is_recording_active():
		record_effect.set_recording_active(false)
		recording = record_effect.get_recording()
	if recording:
		var time_string = Time.get_datetime_string_from_system().replace(":", "-")
		var final_audio_name = "player_audio_" + str(PlayerData.childId) + "_" + time_string + ".wav"
		var full_save_path = "user://" + final_audio_name 
		threadSavePath = full_save_path
		WorkerThreadPool.add_task(_thread_save_audio)
		
		if replayController != null:
			replayController.linked_audio_filename = final_audio_name
			var final_json_name = "player_replay_" + str(PlayerData.childId) + "_"  + time_string + ".json"
			replayController.SAVE_PATH = "user://" + final_json_name
			replayController.stop_and_save_session()
			await replayController.saveCompleted #Add await signal for the thread
			await self.audio_saved
			var uploader = get_node_or_null("/root/SessionUploader")
			uploader.UploadSessionDataAsync("user://"+final_json_name, full_save_path, SessionData.accessToken, PlayerData.childId)

func stop_chunk_record_and_save() -> String:
	if chunk_record_effect and chunk_record_effect.is_recording_active():
		chunk_record_effect.set_recording_active(false)
		chunk_recording = chunk_record_effect.get_recording()
	if chunk_recording:
		var time_string = Time.get_datetime_string_from_system().replace(":", "-")
		var final_chunk_audio_name = "player_audio_chunk_" + str(PlayerData.childId) + "_" + time_string + ".wav"
		var full_save_path = "user://" + final_chunk_audio_name
		chunkThreadSavePath = full_save_path	
		WorkerThreadPool.add_task(_thread_save_chunk_audio)
		var savedPath = await  self.chunk_audio_saved
		return savedPath
	return ""

func _thread_save_audio() -> void:
	recording.save_to_wav(threadSavePath)
	print("Audio successfully saved in background")
	call_deferred("emit_signal", "audio_saved")

func _thread_save_chunk_audio() -> void:
	chunk_recording.save_to_wav(chunkThreadSavePath)
	print("Audio chunk successfully saved in background")
	call_deferred("emit_signal", "chunk_audio_saved",chunkThreadSavePath)