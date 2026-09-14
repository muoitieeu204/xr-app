extends Node

var items: Array[Dictionary] = []

func clear() -> void:
	items.clear()

func set_data(data_array: Array) -> void:
	clear()
	for slot in data_array:
		if slot is Dictionary:
			items.append(slot)
	print("✅ ExerciseData stored %d slots in raw API format!" % items.size())