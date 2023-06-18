extends Tween

class_name CameraStaticManager

@onready var player_camera = get_node("/root/Scene/PlayerCamera")
@onready var player = get_node("/root/Scene/Player")
var camera_base_offset: Vector2 = Vector2(200.0, -225.0)
var is_static: bool
var is_pos_static: bool
var center_object_pos: Vector2
var background_static: bool
@export var active_axis: Vector2 = Vector2(1.0, 1.0)

func _ready() -> void:
	is_static = false
	is_pos_static = false

func _physics_process(delta: float) -> void:
	if is_pos_static:
		if active_axis.x == 1.0:
			player_camera.global_position.x = center_object_pos.x
		if active_axis.y == 1.0:
			player_camera.global_position.y = center_object_pos.y

func enter_static(center_object_path: String, duration: float, override: bool, offset: Vector2, disable_offset: bool):
	remove_all()
	is_static = true
	player_camera.drag_bottom_margin = 1.0
	var center_object = get_parent().get_parent().get_node(center_object_path)
	if active_axis.x == 1.0:
		interpolate_property(player_camera, "global_position:x", player_camera.global_position.x,\
		 center_object_pos.x, duration)
		center_object_pos.x = center_object.global_position.x
	if active_axis.y == 1.0:
		interpolate_property(player_camera, "global_position:y", player_camera.global_position.y,\
		 center_object_pos.y, duration)
		center_object_pos.y = center_object.global_position.y
	if center_object_pos.y < 459.9 && !override:
		center_object_pos.y = player_camera.global_position.y
	if !disable_offset:
#		interpolate_property(player_camera, "offset", player_camera.offset,\
#		 Vector2(0.0+offset.x, -225.0+offset.y), duration)
		background_static = true
	start()

func exit_static(duration: float):
	remove_all()
	is_static = false
	background_static = false
	player_camera.drag_bottom_margin = 0.0
	player_camera.limit_top = -4625
	camera_base_offset.x = 200 if player._x_direction > 0 else -200
	interpolate_property(player_camera, "position", player_camera.position,\
	 Vector2(0.0, -62.0), duration)
	interpolate_property(player_camera, "offset", player_camera.offset,\
	 camera_base_offset, duration)
	start()


func _on_CameraStaticManager_tween_completed(object: Object, key: NodePath) -> void:
	if is_static:
		is_pos_static = true
	else:
		is_pos_static = false
