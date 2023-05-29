extends Camera2D

@onready var player = get_parent().get_node("Player")
@onready var background = get_parent().get_node("ParallaxBackground")
var cam_speed = 500.0
var max_dist = 200
var cam_offset: = Vector2(200.0, 0.0)
var moving_into_place: bool = false

#func _ready() -> void:
#	background.rotation_degrees = player.rotation_degrees * -1
#	background.get_node("ParallaxLayer").position.y = position.y
#	background.get_node("ParallaxLayer/Background-2").position.y -= position.y

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
	position.x = player.position.x + cam_offset.x * player._x_direction
	var dist = player.position.y - position.y + cam_offset.y
	if abs(dist) > max_dist:
		position.y = player.position.y + cam_offset.y - sign(dist) * max_dist

