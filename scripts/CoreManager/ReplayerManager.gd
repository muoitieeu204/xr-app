extends Node

# Grab the child nodes so we can control them easily                                                                                                                                                                         
@onready var replayer = $Replayer                                                                                                                                                                                            
@onready var micController = $MicController                                                                                                                                                                                 
																																																								 
# A clean helper function to start both at exactly the same time                                                                                                                                                             
func start_recording():
	print("My children are: ", get_children())
	if replayer == null:
		printerr("replayer variable is null!")
	else:	                                                                                                                                                                                                      
		replayer.start_recording_session()
	if micController != null:                                                                                                                                                                       
		micController.start_record()                                                                                                                                                                                            
																																																								 
# A clean helper function to stop and save both                                                                                                                                                                              
func stop_recording():
	micController.stop_record_and_save()
																																																																																															  
func log_interaction(event_text: String):                                                                                                                                                                                    
	replayer.log_event_to_replay(event_text)
