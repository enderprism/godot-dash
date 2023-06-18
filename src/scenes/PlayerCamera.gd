extends Camera2D

@onready var player = $"../Player"
@onready var background = $"../Background2/Background"
const MIN_HEIGHT: float = -5000.0
const MAX_HEIGHT: float = 200.0
var cam_speed = 500.0
var max_dist = 200.0
var cam_offset: = Vector2(300.0, 0.0)
var x_final_offset: float
var y_final_pos: float
var y_final_offset: float
var x_final_pos: float
var horizontal_lerp_weight = 0.5

func _ready() -> void:
	position.y = 200

func _process(_delta: float) -> void:
	if player.arrow_trigger_direction == Vector2(0.0, -1.0):
		x_final_pos = lerp(position.x, player.position.x, horizontal_lerp_weight)
		x_final_offset = lerp(offset.x, cam_offset.x * player._x_direction, 0.1)
		y_final_offset = lerp(offset.y, 0.0, 0.1)
		var dist = player.position.y - position.y + cam_offset.y
		y_final_pos = player.position.y + cam_offset.y - sign(dist) * max_dist
		y_final_pos = clampf(y_final_pos, MIN_HEIGHT, MAX_HEIGHT)
		if CurrentLevel.is_camera_static.x == 0:
			offset.x = x_final_offset
			offset.y = y_final_offset
			position.x = x_final_pos
		if CurrentLevel.is_camera_static.y == 0:
			if abs(dist) > max_dist:
				position.y = lerp(position.y, y_final_pos, 0.1)
	
	elif player.arrow_trigger_direction == Vector2(-1.0, 0.0):
		y_final_pos = lerp(position.y, player.position.y, horizontal_lerp_weight)
		y_final_pos = clampf(y_final_pos, MIN_HEIGHT, MAX_HEIGHT)
		y_final_offset = lerp(offset.y, cam_offset.x * 0.75 * -player._x_direction, 0.1)
		x_final_offset = lerp(offset.x, 0.0, 0.1)
		var dist = player.position.x - position.x + cam_offset.y
		x_final_pos = player.position.x + cam_offset.y - sign(dist) * max_dist
		if CurrentLevel.is_camera_static.x == 0:
			offset.y = y_final_offset
			offset.x = x_final_offset
			position.y = y_final_pos
		if CurrentLevel.is_camera_static.y == 0:
			if abs(dist) > max_dist:
				position.x = lerp(position.x, x_final_pos, 0.1)

