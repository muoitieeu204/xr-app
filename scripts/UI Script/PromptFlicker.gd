extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(self, "modulate:a", 0.3,0.8).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate:a", 1.0,0.8).set_trans(Tween.TRANS_SINE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
