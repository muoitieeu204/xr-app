extends Control

@onready var slides_container = $SlidesContainer
@onready var prev_button = $PrevButton
@onready var next_button = $NextButton

var current_slide = 0

func _ready():
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

func _on_next_button_pressed():
	if slides_container and current_slide < slides_container.get_child_count() - 1:
		current_slide += 1
		update_slides()

func _on_prev_button_pressed():
	if current_slide > 0:
		current_slide -= 1
		update_slides()
