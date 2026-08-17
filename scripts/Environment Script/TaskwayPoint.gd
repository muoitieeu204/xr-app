extends Node3D

@export var indicator_sound: AudioStreamPlayer3D

func _ready() -> void:
	# If you didn't check 'Autoplay' on the audio node, this forces it to play!
	if indicator_sound and not indicator_sound.playing:
		indicator_sound.play()

func _on_area_3d_body_entered(body: Node3D) -> void:
	queue_free()
