extends AnimationPlayer

class_name TriggerManager

onready var player_camera = get_node("/root/Scene/Player/Camera2D")
onready var player = get_node("/root/Scene/Player")
onready var scene = get_node("/root/Scene")
onready var background = get_node("/root/Scene/Background")
onready var ground = get_node("/root/Scene/Ground")
var bg_base_color = Color("46a0ff")
var ground_base_color = Color("4a44ff")
var camera_base_offset: Vector2 = Vector2(200.0, -225.0)
var override_offset: bool = true
#var debug_time: float

export var zoom: Vector2 = Vector2(1.0, 1.0)
export var offset: Vector2 = Vector2(0.0, 0.0)
export var offset_v: float = -0.72
export var rotation_degrees: float
export var arrow_trigger_angle: float
export var background_color: Color = Color("46a0ff")
export var ground_color: Color = Color("4a44ff")

func _ready() -> void:
	player_camera.offset = camera_base_offset

func _physics_process(delta: float) -> void:
	background.modulate = background_color
	ground.modulate = ground_color
	player_camera.zoom = Vector2(zoom.x * 0.75, zoom.y * 0.75)
	player_camera.global_rotation_degrees = rotation_degrees
	scene.rotation_degrees = arrow_trigger_angle
#	debug_time += delta
#	override_offset = true if not CurrentLevel.is_camera_static else false
	if override_offset:
		player_camera.offset = offset + camera_base_offset
	camera_base_offset.x = 200 if player._x_direction > 0 else -200
