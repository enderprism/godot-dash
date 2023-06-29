extends Node2D

@onready var _ground_width = 1.5 * 4096 * $GroundSprites/Ground1.scale.x * $GroundSprites.scale.x

func _on_ground_overflow_right() -> void:
	position.x += _ground_width

func _on_ground_overflow_left() -> void:
	position.x -= _ground_width
