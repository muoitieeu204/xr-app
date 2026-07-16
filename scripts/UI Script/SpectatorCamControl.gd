extends Camera3D
class_name SpectatorController

@export var move_speed: float = 5.0
@export var mouse_sensitve: float = 0.05

func _input(event: InputEvent) -> void:
	# 1. Only rotate the camera if it's currently active AND the Right Mouse Button is held down
	if current and event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		
		# Rotate left/right
		rotation.y -= event.relative.x * mouse_sensitve
		
		# Rotate up/down
		rotation.x -= event.relative.y * mouse_sensitve
		
		# Clamp the up/down rotation so the camera doesn't flip completely upside down
		rotation.x = clamp(rotation.x, -PI/2, PI/2)

func _process(delta: float) -> void:
	# 2. Don't process movement if we are currently looking through the 1st-Person Dummy camera!
	if not current:
		return

	var direction = Vector3.ZERO
	
	# 3. WASD Key Input mapping
	if Input.is_physical_key_pressed(KEY_W):
		direction -= transform.basis.z
	if Input.is_physical_key_pressed(KEY_S):
		direction += transform.basis.z
	if Input.is_physical_key_pressed(KEY_A):
		direction -= transform.basis.x
	if Input.is_physical_key_pressed(KEY_D):
		direction += transform.basis.x
		
	# Fly Up and Down (E to go up, Q to go down)
	if Input.is_physical_key_pressed(KEY_E):
		direction += transform.basis.y
	if Input.is_physical_key_pressed(KEY_Q):
		direction -= transform.basis.y
		
	# Normalize to prevent moving twice as fast when pressing two keys diagonally
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		
	# 4. Apply the movement safely using delta time
	global_position += direction * move_speed * delta
	
