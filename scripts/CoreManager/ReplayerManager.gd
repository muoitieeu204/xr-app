extends Node

# Grab the child nodes so we can control them easily                                                                                                                                                                         
@onready var replayer = $Replayer                                                                                                                                                                                            
@onready var micController = $MicController                                                                                                                                                                                 
                                                                                                                                                                                                                                 
# A clean helper function to start both at exactly the same time                                                                                                                                                             
func start_recording():                                                                                                                                                                                                      
	replayer.start_recording_session()                                                                                                                                                                                       
	micController.start_record()                                                                                                                                                                                            
                                                                                                                                                                                                                                 
# A clean helper function to stop and save both                                                                                                                                                                              
func stop_recording():
	replayer.stop_and_save_session()
	micController.stop_record_and_save()
                                                                                                                                                                                                                                 
# A clean helper function to pass the log down to the replayer                                                                                                                                                               
func log_interaction(event_text: String):                                                                                                                                                                                    
	replayer.log_event_to_replay(event_text)