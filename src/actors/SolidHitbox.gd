extends CollisionShape2D

class_name SolidHitbox

@onready var player
@export var _shape_x: float = 122
@export var _shape_y: float = 122

func _ready() -> void:
	if CurrentLevel.in_editor:
		player = get_node("/root/LevelEditor/GameScene/Player")
	else:
		player = get_node("/root/Scene/Player")
	one_way_collision = true

func _physics_process(_delta: float) -> void:
	if player:
		if player.is_platformer:
			one_way_collision = false
		else:
			if player.arrow_trigger_direction == Vector2(0.0, -1.0):
				if fmod(abs(global_rotation_degrees), 90.0) > 45.0:
					shape.size = Vector2(_shape_y, _shape_x)
					shape.size = Vector2(_shape_y, _shape_x)
					shape.size = Vector2(_shape_y, _shape_x)
				if player.gravity < 0:
					global_rotation_degrees = 180
				else:
					global_rotation_degrees = 0
			elif player.arrow_trigger_direction == Vector2(-1.0, 0.0):
				if fmod(abs(global_rotation_degrees), 90.0) > 45.0:
					get_shape().set_size(Vector2(_shape_x, _shape_y))
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
