extends Control

@onready var master_slider = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/MasterRow/MasterSlider
@onready var master_value = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/MasterRow/HBoxContainer/MasterValue

@onready var music_slider = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/MusicRow/MusicSlider
@onready var music_value = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/MusicRow/HBoxContainer/MusicValue

@onready var sfx_slider = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/SFXRow/SFXSlider
@onready var sfx_value = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/SFXRow/HBoxContainer/SFXValue

@onready var close_button = $MenuBox/MarginContainer/VBoxContainer/CloseButton
@onready var sfx_test_player = $SFXTestPlayer

var master_bus_idx: int
var music_bus_idx: int
var sfx_bus_idx: int

func _ready() -> void:
	# Fetch bus indices dynamically
	master_bus_idx = AudioServer.get_bus_index("Master")
	music_bus_idx = AudioServer.get_bus_index("Music")
	sfx_bus_idx = AudioServer.get_bus_index("Sounds") # Sounds corresponds to SFX/Voice in default_bus_layout.tres
	
	# Load current bus volume into sliders (map decibels to linear 0.0 - 1.0)
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_idx))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_idx))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_idx))
	
	# Update labels
	_update_labels()
	
	# Connect signals
	master_slider.value_changed.connect(_on_master_value_changed)
	music_slider.value_changed.connect(_on_music_value_changed)
	
	# For SFX, we also trigger a test sound when the user drags/releases the slider
	sfx_slider.value_changed.connect(_on_sfx_value_changed)
	sfx_slider.drag_ended.connect(_on_sfx_drag_ended)
	
	close_button.pressed.connect(_on_close_button_pressed)
	close_button.mouse_entered.connect(_on_close_button_hover)
	close_button.mouse_exited.connect(_on_close_button_unhover)
	
	# Playful slider hover effects
	master_slider.mouse_entered.connect(_on_slider_hover.bind(master_slider, master_value))
	master_slider.mouse_exited.connect(_on_slider_unhover.bind(master_slider, master_value))
	
	music_slider.mouse_entered.connect(_on_slider_hover.bind(music_slider, music_value))
	music_slider.mouse_exited.connect(_on_slider_unhover.bind(music_slider, music_value))
	
	sfx_slider.mouse_entered.connect(_on_slider_hover.bind(sfx_slider, sfx_value))
	sfx_slider.mouse_exited.connect(_on_slider_unhover.bind(sfx_slider, sfx_value))

func _update_labels() -> void:
	master_value.text = str(round(master_slider.value * 100)) + "%"
	music_value.text = str(round(music_slider.value * 100)) + "%"
	sfx_value.text = str(round(sfx_slider.value * 100)) + "%"

func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_idx, linear_to_db(value))
	# Mute bus completely if slider is 0
	AudioServer.set_bus_mute(master_bus_idx, value == 0.0)
	master_value.text = str(round(value * 100)) + "%"

func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_idx, linear_to_db(value))
	AudioServer.set_bus_mute(music_bus_idx, value == 0.0)
	music_value.text = str(round(value * 100)) + "%"

func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_idx, linear_to_db(value))
	AudioServer.set_bus_mute(sfx_bus_idx, value == 0.0)
	sfx_value.text = str(round(value * 100)) + "%"

func _on_sfx_drag_ended(_value_changed: bool) -> void:
	# Play test sound on Sounds bus to preview SFX volume
	if sfx_test_player != null and sfx_slider.value > 0.0:
		sfx_test_player.play()

func _on_close_button_pressed() -> void:
	# Play close tween or hide the menu
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.finished.connect(queue_free)

func _on_close_button_hover() -> void:
	close_button.pivot_offset = close_button.size / 2
	var tween = create_tween().set_parallel(true)
	tween.tween_property(close_button, "scale", Vector2(1.05, 1.05), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(close_button, "rotation_degrees", 1.5, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_close_button_unhover() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(close_button, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(close_button, "rotation_degrees", 0.0, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_slider_hover(slider: HSlider, val_label: Label) -> void:
	val_label.pivot_offset = val_label.size / 2
	slider.pivot_offset = slider.size / 2
	var tween = create_tween().set_parallel(true)
	tween.tween_property(val_label, "scale", Vector2(1.2, 1.2), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(slider, "scale", Vector2(1.02, 1.02), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_slider_unhover(slider: HSlider, val_label: Label) -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(val_label, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(slider, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
