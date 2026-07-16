extends Control

@onready var progress_bar = $MenuBox/MarginContainer/VBoxContainer/ProgressSection/Progress
@onready var progress_label = $MenuBox/MarginContainer/VBoxContainer/ProgressSection/HBoxContainer/ProgressLabel

@onready var count_value = $MenuBox/MarginContainer/VBoxContainer/StatsSection/CountValue
@onready var total_value = $MenuBox/MarginContainer/VBoxContainer/StatsSection/TotalValue
@onready var stars_label = $MenuBox/MarginContainer/VBoxContainer/StatsSection/StarsLabel

@onready var close_button = $MenuBox/MarginContainer/VBoxContainer/CloseButton

var count: int = 0
var total: int = 10

func _ready() -> void:
	_update_ui()
	
	close_button.pressed.connect(_on_close_button_pressed)
	close_button.mouse_entered.connect(_on_button_hover.bind(close_button))
	close_button.mouse_exited.connect(_on_button_unhover.bind(close_button))

func set_progress(new_count: int, new_total: int = -1) -> void:
	var old_count = count
	if new_total != -1:
		total = max(1, new_total)
	count = clamp(new_count, 0, total)
	
	_update_ui()
	if count > old_count:
		_bounce_label(count_value)

func increment_progress() -> void:
	set_progress(count + 1)

func _update_ui() -> void:
	# Calculate percentage
	var percent = 0.0
	if total > 0:
		percent = (float(count) / total) * 100.0
	
	# Animate the progress bar value using a Tween for a smooth, dynamic effect!
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", percent, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Update labels
	progress_label.text = str(count) + " / " + str(total) + " câu (" + str(round(percent)) + "%)"
	count_value.text = str(count)
	total_value.text = str(total)
	
	# Update stars based on count
	var stars = ""
	for i in range(count):
		stars += "⭐"
	if count == 0:
		stars = "Chưa có sao 😿"
	stars_label.text = stars

func _bounce_label(label: Label) -> void:
	label.pivot_offset = label.size / 2
	var tween = create_tween()
	tween.tween_property(label, "scale", Vector2(1.4, 1.4), 0.1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.1)

func _on_close_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.finished.connect(queue_free)

func _on_button_hover(btn: Button) -> void:
	btn.pivot_offset = btn.size / 2
	var tween = create_tween().set_parallel(true)
	tween.tween_property(btn, "scale", Vector2(1.05, 1.05), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(btn, "rotation_degrees", 1.5, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_button_unhover(btn: Button) -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(btn, "rotation_degrees", 0.0, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
