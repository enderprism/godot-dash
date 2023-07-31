extends Sprite2D

var scale_multiplier: float = 1.0

func _physics_process(delta: float) -> void:
	if get_viewport().get_camera_2d() != null:
		global_position.x = get_viewport().get_camera_2d().get_screen_center_position().x
		global_scale.x = 1/get_viewport().get_camera_2d().zoom.x * 0.4 * scale_multiplier
