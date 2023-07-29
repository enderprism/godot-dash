extends Node2D

var _background_width = 2048.0
var _background_velocity = Vector2(_background_width, 0.0)

func _on_background_overflow_right() -> void:
	translate(_background_velocity*scale.y)

func _on_background_overflow_left() -> void:
	translate(-_background_velocity*scale.y)
