extends Node3D
                                                                                                                                                                                                                            
func _ready():
        # Grab the XRTools Staging root node                                                                                                                                                                                   
        var staging = get_parent()
                                                                                                                                                                                                                               
        # Connect to the staging signals                                                                                                                                                                                       
        if staging.has_signal("switching_to_loading_scene"):
            staging.switching_to_loading_scene.connect(_show_ship)
                                                                                                                                                                                                                                   
        if staging.has_signal("scene_loaded"):
            staging.scene_loaded.connect(_hide_ship)
                                                                                                                                                                                                                                   
        # (Optional) If the game starts directly into a scene without a loading phase,                                                                                                                                         
        # you might want to call _hide_ship() here manually, but usually XRTools handles this.                                                                                                                                 
                                                                                                                                                                                                                            
func _show_ship(_user_data = null):
        visible = true
        # Turns collisions and physics back ON                                                                                                                                                                                 
        process_mode = Node.PROCESS_MODE_INHERIT
                                                                                                                                                                                                                            
func _hide_ship(_scene = null, _user_data = null):
        visible = false
        # Turns collisions and physics OFF so they don't block the player in the main game
        process_mode = Node.PROCESS_MODE_DISABLED