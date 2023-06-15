extends Node2D

var _ground_width = 1024*0.28
var _ground_velocity = Vector2(_ground_width, 0.0)

func _on_ground_overflow_right() -> void:
	position.x += _ground_velocity.x

func _on_ground_overflow_left() -> void:
	position.x -= _ground_velocity.x
