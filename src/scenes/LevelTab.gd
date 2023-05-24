extends Control

func _ready() -> void:
	$LevelMenu/LevelButton/VBoxContainer/Label.text = name
	$LevelMenu/LevelButton._selected_level = name
