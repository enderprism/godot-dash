extends Node2D

var _ground_width = 1024*0.28
var _ground_velocity = Vector2(_ground_width, 0.0)

func _on_ground_overflow_right() -> void:
	translate(_ground_velocity)

func _on_ground_overflow_left() -> void:
	translate(-_ground_velocity)
