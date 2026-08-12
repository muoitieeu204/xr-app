extends RigidBody3D

@onready var timer = $Timer

signal fish_bit

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	
func enter_water():
	print("Bait is in the water! Waiting for a bite...")
	var random_wait_time = randf_range(3.0, 10.0)
	timer.start(random_wait_time)

func _on_timer_timeout():
	print("Item Bite! Spawning item...")

	fish_bit.emit()
	get_tree().call_group("FishingLevelController", "spawn_item", global_position)
