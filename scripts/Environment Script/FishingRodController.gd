extends Node

@export var pickable: XRToolsPickable
@export var bait_scene: PackedScene
@export var rod_tip: Marker3D
@export var reel_hinge: XRToolsInteractableHinge
@export var throw_multiplier: float = 1.5
@export var reel_speed: float = 0.05

var current_bait: RigidBody3D = null
var previous_tip_pos: Vector3
var tip_velocity: Vector3
var last_hinge_pos: float = 0.0


func _ready():
	# If pickable isn't set in the inspector, grab the parent node automatically
	if not pickable:
		pickable = get_parent() as XRToolsPickable

	# Connect to the parent's action_pressed signal
	if pickable:
		pickable.action_pressed.connect(_on_action_pressed)

	if reel_hinge:
		last_hinge_pos = reel_hinge.hinge_position


func _physics_process(delta):
	# 1. Track the velocity of the rod tip
	if rod_tip:
		var current_tip_pos = rod_tip.global_position
		tip_velocity = (current_tip_pos - previous_tip_pos) / delta
		previous_tip_pos = current_tip_pos

	# 2. Handle reeling in the bait
	if is_instance_valid(current_bait) and reel_hinge:
		var current_hinge_pos = reel_hinge.hinge_position
		var crank_delta = current_hinge_pos - last_hinge_pos
		last_hinge_pos = current_hinge_pos

		# If the crank is rotating forward (invert this if it reels backward)
		if crank_delta > 0.0:
			var dir_to_rod = (rod_tip.global_position - current_bait.global_position).normalized()
			current_bait.global_position += dir_to_rod * crank_delta * reel_speed


func _on_action_pressed(_pickable):
	# Cast the bait when the trigger is pressed
	cast_bait()


func cast_bait():
	if is_instance_valid(current_bait):
		current_bait.queue_free()

	if not bait_scene:
		push_warning("Bait scene not assigned!")
		return

	# Spawn new bait at the tip
	current_bait = bait_scene.instantiate()
	get_tree().root.add_child(current_bait)
	current_bait.global_position = rod_tip.global_position

	# Launch the bait using the tip's flick velocity
	current_bait.linear_velocity = tip_velocity * throw_multiplier

	# Connect to our custom bite signal
	if current_bait.has_signal("fish_bit"):
		current_bait.connect("fish_bit", _on_fish_bit)


func _on_fish_bit():
	if not pickable:
		return

	# Get the XRController3D holding the parent rod
	var controller = pickable.get_picked_up_by_controller()
	if controller:
		# Trigger haptics
		controller.trigger_haptic_pulse("haptic", 100.0, 0.8, 0.5, 0.0)
