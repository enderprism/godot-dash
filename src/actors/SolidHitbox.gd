extends CollisionShape2D

class_name SolidHitbox

onready var player = get_node("/root/Scene/Player")

func _ready() -> void:
	one_way_collision = true

func _physics_process(_delta: float) -> void:
	if player.is_platformer:
		one_way_collision = false
	else:
		if player.arrow_trigger_direction == Vector2(0.0, -1.0):
			if player.gravity < 0:
				global_rotation_degrees = 180
			else:
				global_rotation_degrees = 0
		elif player.arrow_trigger_direction == Vector2(-1.0, 0.0):
			if player._x_direction > 0:
				if player.gravity < 0:
					global_rotation_degrees = 90
				else:
					global_rotation_degrees = -90
			else:
				if player.gravity < 0:
					global_rotation_degrees = 90
				else:
					global_rotation_degrees = -90
