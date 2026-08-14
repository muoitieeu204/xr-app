extends RigidBody3D

@export var splash_vfx: PackedScene
@export var splash_sfx: AudioStreamPlayer3D

@onready var timer = $Timer

var is_bitten: bool = false

signal fish_bit

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	
func enter_water():
	print("Bait is in the water! Waiting for a bite...")

	if splash_vfx:
		var splash = splash_vfx.instantiate()
		get_tree().root.add_child(splash)
		splash.global_position = global_position
		splash.global_position.y += 2
		splash.scale = Vector3(1, 1, 1)
		if splash_sfx:
			splash_sfx.play()
		
	var random_wait_time = randf_range(3.0, 10.0)
	timer.start(random_wait_time)

func _on_timer_timeout():
	print("Fish Bite! Signal pulling now...")
	is_bitten = true
	fish_bit.emit()
	#TODO: Add spash animation and Warning indicator
