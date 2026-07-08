extends PanelContainer

@export var pending_icon : Texture2D
@export var completed_icon : Texture2D

@onready var task_list_container = $VBoxContainer/TaskListContainer

# Call this function from your LevelController whenever a task is completed!
func update_tasks(all_tasks: Array[String], completed_tasks: Array[String]) -> void:
	# 1. Clear the old list to prevent duplicates
	for child in task_list_container.get_children():
		child.queue_free()
		
	# 2. Build the new list line by line
	for task in all_tasks:
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 16)
		
		# Setup the Icon
		var icon_rect = TextureRect.new()
		icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon_rect.custom_minimum_size = Vector2(32, 32)
		icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		# Setup the Text
		var label = Label.new()
		label.text = task
		label.add_theme_font_size_override("font_size", 24)
		
		# Check if the task is done
		if completed_tasks.has(task):
			icon_rect.texture = completed_icon
			label.add_theme_color_override("font_color", Color("9ca3af")) # Gray out completed text
		else:
			icon_rect.texture = pending_icon
			label.add_theme_color_override("font_color", Color("111827")) # Dark text for pending
			
		# Add them to the screen
		hbox.add_child(icon_rect)
		hbox.add_child(label)
		task_list_container.add_child(hbox)
