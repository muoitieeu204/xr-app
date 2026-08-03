extends Control

# 1. Grab all the Slider and Label nodes
@onready var master_slider = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/MasterRow/MasterSlider
@onready var master_value_label = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/MasterRow/HBoxContainer/MasterValue

@onready var music_slider = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/MusicRow/MusicSlider
@onready var music_value_label = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/MusicRow/HBoxContainer/MusicValue

@onready var sfx_slider = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/SFXRow/SFXSlider
@onready var sfx_value_label = $MenuBox/MarginContainer/VBoxContainer/VolumeSliders/SFXRow/HBoxContainer/SFXValue

@onready var health_warning_check = $MenuBox/MarginContainer/VBoxContainer/HealthWarningRow/HealthWarningCheck
var config = ConfigFile.new()
var savePath = "user://settings.cfg"

func _ready() -> void:
	# 2. Connect the slider movement to our custom functions below
	if master_slider: master_slider.value_changed.connect(_on_master_slider_changed)
	if music_slider: music_slider.value_changed.connect(_on_music_slider_changed)
	if sfx_slider: sfx_slider.value_changed.connect(_on_sfx_slider_changed)
	if health_warning_check: health_warning_check.toggled.connect(_on_health_warning_check_toggled)
	loadSettings()

# 3. Update the Master Volume
func _on_master_slider_changed(value: float) -> void:
	# Update the text label (e.g., 0.5 becomes "50%")
	master_value_label.text = str(int(value * 100)) + "%"
	
	# Find the Master Audio Bus and convert the 0-1 value into Decibels
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	saveSetting()

# 4. Update the Music Volume
func _on_music_slider_changed(value: float) -> void:
	music_value_label.text = str(int(value * 100)) + "%"
	var bus_index = AudioServer.get_bus_index("Music")
	if bus_index != -1: # Ensure you actually have a bus named "Music" created at the bottom of your Godot window!
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	saveSetting()
	
# 5. Update the SFX Volume
func _on_sfx_slider_changed(value: float) -> void:
	sfx_value_label.text = str(int(value * 100)) + "%"
	var bus_index = AudioServer.get_bus_index("Sounds")
	if bus_index != -1: # Ensure you actually have a bus named "SFX"
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	saveSetting()

func _on_health_warning_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		health_warning_check.modulate = Color("4ed688") # Green
	else:
		health_warning_check.modulate = Color("ff8e8e") # Red
	saveSetting()

func saveSetting():
	config.set_value("Audio", "Master", master_slider.value)
	config.set_value("Audio", "Music", music_slider.value)
	config.set_value("Audio", "Sounds", sfx_slider.value)
	config.set_value("Game", "HealthWarning", health_warning_check.button_pressed)
	config.save(savePath)

func loadSettings():
	if config.load(savePath) == OK:
		master_slider.value = config.get_value("Audio", "Master", 1.0)
		music_slider.value = config.get_value("Audio", "Music", 1.0)
		sfx_slider.value = config.get_value("Audio", "Sounds", 1.0)
		if health_warning_check:
			var is_enabled = config.get_value("Game", "HealthWarning", true)
			health_warning_check.button_pressed = is_enabled
			health_warning_check.modulate = Color("4ed688") if is_enabled else Color("ff8e8e")