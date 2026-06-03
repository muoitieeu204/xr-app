extends Node
class_name MicController

var record_effect: AudioEffectRecord
var recording: AudioStreamWAV
const savePath : String = "user://player_audio.wav"

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
		#var time_string = Time.get_datetime_string_from_system().replace(":","-")
		#var save_path = savePath + time_string+".wav"
		var save_path = savePath
		recording.save_to_wav(save_path)
		print("Save to path: ", ProjectSettings.globalize_path(savePath))
		
