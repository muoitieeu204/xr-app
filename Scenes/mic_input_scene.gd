extends Control
@onready var mic_controller: MicController = $MicController




func _on_start_button_pressed() -> void:
	print("Start record")
	mic_controller.start_record()


func _on_stop_button_pressed() -> void:
	print("Stop record and save")
	mic_controller.stop_record_and_save()
