extends Node

var response_data: Array[Dictionary] = []

func clear() -> void:
	response_data.clear()

func set_data(data_array: Array) -> void:
	clear()
	for slot in data_array:
		if slot is Dictionary:
			response_data.append(slot)
	print("✅ LessonData stored %d slots in raw API format!" % response_data.size())