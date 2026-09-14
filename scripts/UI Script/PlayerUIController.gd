extends Control


func _ready() -> void:
	GameManager.score_updated.connect(updated_score)
	GameManager.time_updated.connect(updated_time)
	GameManager.item_name_updated.connect(updated_item_name)
	GameManager.hint_updated.connect(updated_hint)

func updated_score(new_score: int):
	$MarginContainer/TopHUD/ScoreLabel.text = "Score: " + str(new_score)

func updated_time(formatted_time: int):
	$MarginContainer/TopHUD/TimeLabel.text = "Time: " + str(formatted_time)

func updated_item_name(new_item_name: String):
	$MarginContainer/BottomHUD/ItemNameLabel.text = new_item_name

func updated_hint(new_hint: String):
	$MarginContainer/MiddleHUD/HintLabel.text = new_hint