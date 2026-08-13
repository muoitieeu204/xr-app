extends Node

@export var pickable: XRToolsPickable
@export var reel_handle: XRToolsInteractableHandle
@export var bait_scene: PackedScene
@export var rod_tip: Marker3D
@export var reel_hinge: XRToolsInteractableHinge
@export var throw_multiplier: float = 1.5
@export var min_cranks: int = 1
@export var max_cranks: int = 3
@export var reel_sound: AudioStreamPlayer3D

#Variables for bait spawn
var current_bait: RigidBody3D = null
var last_hinge_pos: float = 0.0

#Variable for reeling phase
var is_reeling:bool = false
var target_crank: int = 0
var current_crank: int = 0
var crank_progress: float = 0.0
var click_progress: float = 0.0

# Variables for the fishing line
var line_mesh_instance: MeshInstance3D
var line_mesh: ImmediateMesh


func _ready():
	# If pickable isn't set in the inspector, grab the parent node automatically
	if not pickable:
		pickable = get_parent() as XRToolsPickable

	# Connect to the parent's action_pressed signal
	if pickable:
		reel_handle.action_pressed.connect(_on_action_pressed)

	if reel_hinge:
		last_hinge_pos = reel_hinge.hinge_position

	# --- NEW: Setup the fishing line visually ---
	line_mesh = ImmediateMesh.new()
	line_mesh_instance = MeshInstance3D.new()
	line_mesh_instance.mesh = line_mesh
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED # Unlit so we can see it easily
	mat.albedo_color = Color(1, 1, 1, 0.5) # Semi-transparent white line
	line_mesh_instance.material_override = mat
	
	# Add the line to the root of the game so it draws in world space
	get_tree().root.call_deferred("add_child", line_mesh_instance)

func _physics_process(delta: float) -> void:
	if is_instance_valid(current_bait) and current_bait.get("is_bitten") == true:
		var rod_velocity = pickable.linear_velocity
		if rod_velocity.y > 3.0:
			print("Successfull yank! Start reeling!")
			current_bait.is_bitten = false

			is_reeling = true
			target_crank = randi_range(min_cranks,max_cranks)
			current_crank = 0
			crank_progress = 0.0
			if reel_hinge:
				last_hinge_pos = reel_hinge.hinge_position
	
	if is_reeling and reel_hinge:
		var current_pos = reel_hinge.hinge_position
		var moved_amount = abs(current_pos- last_hinge_pos)
		if moved_amount > 180.0:
			moved_amount = 0

		crank_progress += moved_amount
		click_progress += moved_amount
		last_hinge_pos = current_pos

		if click_progress >= 30.0:
			click_progress = 0.0
			if reel_sound:
				if not reel_sound.playing:
					reel_sound.pitch_scale = randf_range(0.9,1.1)
					reel_sound.play()
			var controller = pickable.get_picked_up_by_controller()
			if controller:
				controller.trigger_haptic_pulse("haptic", 10, 0.1, 0.05, 0.0)

		if crank_progress >= 360.0:
			current_crank +=1
			crank_progress = 0.0
			print("Cranked: ", current_pos, "/ ", target_crank)
			var controller = pickable.get_picked_up_by_controller()
			if controller:
				controller.trigger_haptic_pulse("haptic", 50.0,0.5,0.1,0.0)
			if current_crank >= target_crank:
				print("Reeling Finished! Item Caught!")
				is_reeling = false
				get_tree().call_group("FishingLevelController", "spawn_item", Vector3.ZERO)
				if is_instance_valid(current_bait):
					current_bait.queue_free()

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
	
	var forward_direction = rod_tip.global_transform.basis.z
	# Make the wire curv
	var arc_direction = (forward_direction + (Vector3.UP * 0.5)).normalized()

	current_bait.apply_central_impulse(arc_direction * throw_multiplier * 10.0)

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


func _process(_delta):
	# Always clear the old line drawing first
	line_mesh.clear_surfaces()
	
	# If we have a bait in the water, draw a line to it
	if is_instance_valid(current_bait) and rod_tip:
		line_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
		line_mesh.surface_add_vertex(rod_tip.global_position)
		line_mesh.surface_add_vertex(current_bait.global_position)
		line_mesh.surface_end()
