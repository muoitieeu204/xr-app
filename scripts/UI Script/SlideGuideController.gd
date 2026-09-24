extends Control

@export var slide_audios: Array[AudioStream]
@export var audio_trigger: Area3D

@onready var slides_container = $SlidesContainer
@onready var prev_button = $PrevButton
@onready var next_button = $NextButton
@onready var guide_audio_node = $GuideAudio

var current_slide = 0
var has_triggered_audio: bool = false

func _ready():
	if audio_trigger:
		audio_trigger.body_entered.connect(_on_audio_trigger_entered)
		audio_trigger.body_exited.connect(_on_audio_trigger_exited)
	# Update the UI as soon as it loads
	update_slides()

func update_slides():
	if not slides_container:
		return
		
	var total_slides = slides_container.get_child_count()
	if total_slides == 0:
		return
		
	# Loop through every image. If the index matches our current slide, show it. Otherwise, hide it!
	for i in range(total_slides):
		slides_container.get_child(i).visible = (i == current_slide)
		
	# Disable the Prev button if we are on the first page
	if prev_button:
		prev_button.disabled = (current_slide == 0)
	
	# Disable the Next button if we are on the very last page
	if next_button:
		next_button.disabled = (current_slide == total_slides - 1)
	if guide_audio_node and slide_audios.size() > current_slide and has_triggered_audio:
		var current_audio = slide_audios[current_slide]
		if current_audio != null:
			guide_audio_node.stream = current_audio
			guide_audio_node.play()
			
func _on_next_button_pressed():
	if slides_container and current_slide < slides_container.get_child_count() - 1:
		current_slide += 1
		update_slides()

func _on_prev_button_pressed():
	if current_slide > 0:
		current_slide -= 1
		update_slides()

func _on_audio_trigger_entered(_body):
	if not has_triggered_audio:
		has_triggered_audio = true
		update_slides()

func _on_audio_trigger_exited(_body):
	has_triggered_audio = false
	if guide_audio_node.playing:
		guide_audio_node.stop()