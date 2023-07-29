extends Sprite2D

func _physics_process(delta: float) -> void:
	if get_viewport().get_camera_2d() != null:
		global_position.x = get_viewport().get_camera_2d().get_screen_center_position().x
		global_scale.x = get_viewport().get_camera_2d().zoom.x * 0.3
