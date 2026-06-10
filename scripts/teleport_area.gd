extends Area3D

#Targer scene name
@export_file("*.tscn") var target_scene: String

@export_category("Puzzle Logic")
@export var require_unlock: bool = false
@export var portalMesh: MeshInstance3D
@export var portalAudio: AudioStreamPlayer3D
@export var successSound: AudioStream
@export var errorSound: AudioStream

var isUnlocked : bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	if require_unlock:
		# Initialize portal to RED (locked)
		_set_portal_color(Color(1.0, 0.0, 0.0)) # Red
	else:
		# Automatically unlocked!
		isUnlocked = true
		_set_portal_color(Color(0.0, 0.0, 1.0)) # Blue

func _on_body_entered(_body: Node3D) -> void:
	var playerBody := _body as XRToolsPlayerBody
	if not playerBody:
		return	
		
	if isUnlocked:
		# Portal is active, teleport the player!
		print("Portal Success! Loading target scene...")
		if portalAudio and successSound:
			portalAudio.stream = successSound
			portalAudio.play()
			
		if not target_scene or target_scene == "":
			return
			
		#Find the XRToolsSceneBase is a child node of 
		var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
		if not scene_base:
			return
		
		#Start loading scene
		scene_base.load_scene(target_scene)
	else:
		# Portal is locked, play error sound
		print("Portal is locked! Cannot enter.")
		if portalAudio and errorSound:
			portalAudio.stream = errorSound
			portalAudio.play()

## Call this function from the Basket Trigger (e.g. via Signal connection)
func unlock_portal() -> void:
	if isUnlocked:
		return
		
	print("Portal Unlocked!")
	isUnlocked = true
	
	# Change color to BLUE
	_set_portal_color(Color(0.0, 0.0, 1.0)) # Blue

func _set_portal_color(color: Color) -> void:
	if not portalMesh:
		return
		
	# Get the actual material currently on the mesh
	var mat = portalMesh.get_active_material(0)
	if not mat:
		return
		
	# Duplicate the material and set it as an override so we only change THIS specific portal's color
	if not portalMesh.material_override:
		portalMesh.material_override = mat.duplicate()
		mat = portalMesh.material_override
		
	# Now change the color based on the type of material
	if mat is StandardMaterial3D:
		mat.albedo_color = color
		mat.emission_enabled = true
		mat.emission = color
	elif mat is ShaderMaterial:
		# I noticed in your screenshot your shader uses 'hologram_color' instead of 'albedo'!
		mat.set_shader_parameter("hologram_color", color)
		# Optional: Also change scanline color if you want it to match
		# mat.set_shader_parameter("scanline_color", color)

