extends Area3D
class_name BasketTrigger

## Emitted when a valid object is dropped into the basket
signal puzzle_solved

@export var required_group: String = "interactable"
var _is_solved: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	print("Basket Trigger Ready!")

func _on_body_entered(body: Node3D) -> void:
	if _is_solved:
		return
		
	# Check if the object that entered is what we want
	# By default, we check if it's a RigidBody3D in the "interactable" group
	if body is RigidBody3D and (required_group == "" or body.is_in_group(required_group)):
		print("Valid object dropped in basket! Emitting puzzle_solved.")
		_is_solved = true
		puzzle_solved.emit()
