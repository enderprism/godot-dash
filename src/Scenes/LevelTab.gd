extends Control

export var used_level: PackedScene

func _ready() -> void:
	$LevelMenu/LevelButton/VBoxContainer/Label.text = name
	$LevelMenu/LevelButton._selected_level = name
