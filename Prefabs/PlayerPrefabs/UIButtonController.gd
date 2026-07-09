extends Node

@export var pauseMenuViewport: Node3D
@export var taskMenuViewport: Node3D

func _on_left_controller_button_pressed(button_name: String):                                                                                                                                                                
    match button_name:                                                                                                                                                         
        "menu-button":
            var is_currently_paused = get_tree().paused                                                                                                                                                                                 
                                                                                                                                                                                                                                        
            if is_currently_paused:                                                                                                                                                                                                     
                # UNPAUSE
                get_tree().paused = false
                $PauseMenuViewport.visible = false
            else:
                # PAUSE
                get_tree().paused = true
                $PauseMenuViewport.visible = true    
        "ax_button":
            if taskMenuViewport:
                taskMenuViewport.visible = !taskMenuViewport.visible