@tool
extends XRToolsSceneBase

func _ready() -> void:
	GetAllLessonApi.lesson_data_loaded.connect(_on_data_loaded)
	GetAllLessonApi.lesson_data_load_failed.connect(_on_data_failed)
	GetAllLessonApi.fetch_lesson_data()

func _on_data_loaded(lesson_data: Array) -> void:
	print("✅ Starter Hub successfully pre-loaded %d lessons!" % lesson_data.size())

func _on_data_failed(error_msg: String) -> void:
	push_error("❌ API Fetch Failed: " + error_msg)