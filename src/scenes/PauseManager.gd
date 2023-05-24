extends Node2D

export var Stream: AudioStream

func _ready() -> void:
	$BackgroundMusic.set_stream(Stream)
	$BackgroundMusic.playing = true

""""
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_parent().get_node("PauseMenu/PauseMenuCamera").current = true
		if get_parent().get_node("PauseMenu/PauseMenuCamera").current:
			get_tree().paused = !get_tree().paused
"""
