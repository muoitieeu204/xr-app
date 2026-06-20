extends Area3D

## The node where the player should be teleported upon entering this hazard.
@export var respawn_point: Node3D

# We cache the transform because the Spawner deletes itself after running!
var _cached_respawn_transform: Transform3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	if respawn_point:
		_cached_respawn_transform = respawn_point.global_transform
	else:
		push_error("RespawnHazard: No respawn_point assigned on ", name)
		
	print("Respawn Hazard Ready! Monitoring for bodies...")

func _on_body_entered(body: Node3D) -> void:
	print("SOMETHING HIT THE WATER! Body name: ", body.name)
	
	# 1. Type check: Is this the player's physics capsule?
	var player_body = body as XRToolsPlayerBody
	if not player_body:
		print("It was not the XRToolsPlayerBody. It was a: ", body.get_class())
		return
		
	# 2. Validation: We check our cached transform instead of the node!
	if _cached_respawn_transform == null or _cached_respawn_transform == Transform3D():
		push_error("RespawnHazard: Cached transform is missing.")
		return
		
	print("Player detected! Teleporting...")
	
	# 3. Use the built-in XRTools teleport function. 
	player_body.teleport(_cached_respawn_transform)
	
	# Reset falling momentum
	player_body.velocity = Vector3.ZERO
