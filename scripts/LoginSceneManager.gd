extends Node3D

func _ready():
        # 1. We must wait 1 second for the headset to finish booting up and tracking
        await get_tree().create_timer(1.0).timeout
        
        # 2. Force the VR camera to perfectly align with the XROrigin3D
        # 'true' means it will keep the player's physical height (so sitting feels correct)
        XRServer.center_on_hmd(XRServer.RESET_BUT_KEEP_TILT, true)
