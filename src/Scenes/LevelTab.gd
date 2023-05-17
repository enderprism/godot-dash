extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LevelMenu/LevelButton/VBoxContainer/Label.text = name
	$LevelMenu/LevelButton._selected_level = name
