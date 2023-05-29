extends Node2D

var _background_width = 2048.0
var _background_velocity = Vector2(_background_width, 0.0)

@onready var player_camera = get_node("/root/Scene/Player/Camera2D")
@onready var player = get_node("/root/Scene/Player")
@onready var scene = get_node("/root/Scene/")
var initial_offset: float

#func _ready() -> void:
#	if get_node("/root/Scene/Player") != null:
#		initial_offset = player_camera.get_camera_position().y

#func _physics_process(delta: float) -> void:
#	if has_node("/root/Scene/Player") && !CurrentLevel.is_background_static && !player._is_dead:
#		if player.arrow_trigger_direction == Vector2(0.0, -1.0):
#			if player._x_direction > 0:
#				position.x += player.speed.x / 100
#			else:
#				position.x -= player.speed.x / 100
#		position.y = (player_camera.get_camera_position().y + initial_offset) * 0.75

func _on_background_overflow_right() -> void:
	translate(_background_velocity*scale.y)

func _on_background_overflow_left() -> void:
	translate(-_background_velocity*scale.y)
