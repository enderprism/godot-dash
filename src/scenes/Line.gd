extends Sprite2D

@onready var camera = get_node("/root/Scene/PlayerCamera")

func _physics_process(delta: float) -> void:
	if has_node("/root/Scene/PlayerCamera"):
		global_position.x = camera.get_screen_center_position().x
		global_scale.x = camera.zoom.x * 0.3
