extends Node

@export var pickable: XRToolsPickable
@export var reel_handle: XRToolsInteractableHandle
@export var bait_scene: PackedScene
@export var rod_tip: Marker3D
@export var reel_hinge: XRToolsInteractableHinge
@export var aim_raycast: RayCast3D 
@export var throw_multiplier: float = 1.5


var current_bait: RigidBody3D = null
var previous_tip_pos: Vector3
var tip_velocity: Vector3
var velocity_history: Array[Vector3] = [] # Stores our past frames
var last_hinge_pos: float = 0.0

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
	aim_raycast.force_raycast_update()
	if aim_raycast.is_colliding():
		current_bait.global_position = aim_raycast.get_collision_point()
	else: 
		current_bait.global_position = aim_raycast.to_global(aim_raycast.target_position)
	current_bait.linear_velocity = Vector3.ZERO

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
