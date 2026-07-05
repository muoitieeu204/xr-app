extends Node
class_name MicController

@export var replayController: TelementryController

var record_effect: AudioEffectRecord
var recording: AudioStreamWAV

func _ready():
	var index = AudioServer.get_bus_index("ReplayMic")
	record_effect = AudioServer.get_bus_effect(index,0)

func start_record():
	if record_effect:
		record_effect.set_recording_active(true)
	
func stop_record_and_save():
	if record_effect and record_effect.is_recording_active():
		record_effect.set_recording_active(false)
		recording = record_effect.get_recording()
	if recording:
		var time_string = Time.get_datetime_string_from_system().replace(":", "-")
		var final_audio_name = "player_audio_" + time_string + ".wav"
		var full_save_path = "user://" + final_audio_name 
		recording.save_to_wav(full_save_path)
		print("Audio successfully saved: ", final_audio_name)
		
		if replayController != null:
			replayController.linked_audio_filename = final_audio_name
			var final_json_name = "player_replay_" + time_string + ".json"
			replayController.SAVE_PATH = "user://" + final_json_name
			replayController.stop_and_save_session()
