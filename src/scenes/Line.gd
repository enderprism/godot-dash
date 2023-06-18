extends Sprite2D

@onready var camera = get_node("../PlayerCamera")

func _physics_process(delta: float) -> void:
	position.x = camera.get_screen_center_position().x
	scale.x = camera.zoom.x * 0.75
