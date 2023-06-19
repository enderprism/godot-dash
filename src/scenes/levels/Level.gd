extends Node2D
class_name Level

@export var level_music: AudioStream
@export var music_start: float
@export var level_end_time: float
@export var time_based_percentage: bool
@export var platformer: bool

func _ready() -> void:
#	scale = Vector2(0.5, 0.5)
	if level_end_time != 0.0:
		LevelProgress.set_end_time(level_end_time)
