extends RigidBody3D

@onready var timer = $Timer

var is_bitten: bool = false
signal fish_bit

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	
func enter_water():
	print("Bait is in the water! Waiting for a bite...")
	var random_wait_time = randf_range(3.0, 10.0)
	timer.start(random_wait_time)

func _on_timer_timeout():
	print("Fish Bite! Signal pulling now...")
	is_bitten = true
	fish_bit.emit()
	#TODO: Add spash animation and Warning indicator
