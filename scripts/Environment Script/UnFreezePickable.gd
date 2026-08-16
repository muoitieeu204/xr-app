extends Node

# This grabs the XRToolsPickable node that is sitting above this node                                                                                                                                                        
@onready var pickable_parent = get_parent()                                                                                                                                                                                  
                                                                                                                                                                                                                                 
func _ready():                                                                                                                                                                                                               
	# We listen to the parent to tell us when it gets picked up
	pickable_parent.dropped.connect(_on_parent_dropped)
                                                                                                                                                                                                                                 
func _on_parent_dropped(pickable):                                                                                                                                                                                         
    # Tell the parent to permanently turn off its freeze property
	pickable_parent.freeze = false