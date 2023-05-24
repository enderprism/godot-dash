extends Sprite

onready var camera = get_node("../Player/Camera2D")

func _physics_process(delta: float) -> void:
	position.x = camera.get_camera_screen_center().x
	scale.x = camera.zoom.x * 0.75
