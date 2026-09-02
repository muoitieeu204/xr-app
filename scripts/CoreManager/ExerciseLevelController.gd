extends Node3D

@export var item_slot_spawner: Array[Marker3D] = []
@export var item_catalog: Dictionary[String, PackedScene] = {
		"trái chuối": preload("res://Assets/3D Models For Supermarket/Fruits/FakeBanana.tscn"),
		"kẹo kitkat": preload("res://Assets/3D Models For Supermarket/Junk Foods/FakeKitKat.tscn")
}

func _ready() -> void:
	#Mock sessionToken test
	SessionData.accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjEiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJhZG1pbkBnb2RvdHhyLmNvbSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiJTeXN0ZW0gQWRtaW4iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJBZG1pbiIsImV4cCI6MTc4ODQ1MTQ5NywiaXNzIjoiR29kb3RYUiIsImF1ZCI6IkdvZG90WFIifQ.51zxZc_Zw4eMs5ikAZp70ieSLE1v8xbQG73fjCUVT8Q"
	GetLessionItemsApi.exercise_data_loaded.connect(_on_data_loaded)
	GetLessionItemsApi.exercise_data_load_failed.connect(_on_data_failed)
	print("🔍 Requesting exercise data from API...")
	GetLessionItemsApi.fetch_exercise_data()

# ponytail: Clean tab-based indentation prevents parser errors when handling nested loops and Dictionary type checking.
func _on_data_loaded(_data: Array) -> void:
	for slot_info in ExerciseData.items:
		var slot_name: String = str(slot_info.get("slotName", ""))
		var raw_asset = slot_info.get("itemAsset")
		var asset_dict: Dictionary = raw_asset if raw_asset is Dictionary else {}
		var item_name: String = str(asset_dict.get("ItemName", ""))
		if item_catalog.has(item_name):
			var packed_scene: PackedScene = item_catalog[item_name]
			var spawn_marker = find_child(slot_name, true, false)
			if spawn_marker and spawn_marker.has_method("spawn_item"):
				spawn_marker.spawn_item(packed_scene)

func _on_data_failed(error_msg: String) -> void:
	push_error("❌ API Fetch Failed: " + error_msg)
