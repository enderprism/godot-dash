extends Node2D

@onready var player = get_node("../Player")

func _physics_process(delta: float) -> void:
#	if player.arrow_trigger_direction == Vector2(0.0, -1.0):
#		rotation_degrees = 0.0
#	elif player.arrow_trigger_direction == Vector2(-1.0, 0.0):
#		rotation_degrees = -90.0
	pass

func _on_Player_spider_jumped(distance) -> void:
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play("default")
	if player.arrow_trigger_direction == Vector2(0.0, -1.0):
		var y_offset: float
		var dash_scale: float = (distance * 0.5) / 365
		scale = Vector2(0.5, dash_scale)
		if player._spider_orb_opposite_gravity:
			if player.UP_DIRECTION.y < 0:
				y_offset = 0
				rotation_degrees = 0
				$AnimatedSprite2D.flip_v = true
			else:
				y_offset = 0.0
				rotation_degrees = 180
				$AnimatedSprite2D.flip_v = false
		elif player.UP_DIRECTION.y < 0:
			y_offset = 0.0
			rotation_degrees = 0
			$AnimatedSprite2D.flip_v = true
		else:
			y_offset = 60.0
			rotation_degrees = 180
			$AnimatedSprite2D.flip_v = false
		position = Vector2(player.position.x * player._icon_direction,
		player.position.y - y_offset)
	elif player.arrow_trigger_direction == Vector2(-1.0, 0.0):
		var y_offset: float
		var dash_scale: float = (distance * 0.5) / 365
		scale = Vector2(0.5, dash_scale)
		if player._spider_orb_opposite_gravity:
			if player.UP_DIRECTION.y < 0:
				y_offset = 0
				rotation_degrees = -90
				$AnimatedSprite2D.flip_v = true
			else:
				y_offset = 0.0
				rotation_degrees = 90
				$AnimatedSprite2D.flip_v = false
		elif player._x_direction > 0:
			if player.UP_DIRECTION.y < 0:
				y_offset = -60.0
				rotation_degrees = -90
				$AnimatedSprite2D.flip_v = true
			else:
				y_offset = 60.0
				rotation_degrees = 90
				$AnimatedSprite2D.flip_v = false
		elif player._x_direction < 0:
			if player.UP_DIRECTION.y < 0:
				y_offset = -60.0
				rotation_degrees = -90
				$AnimatedSprite2D.flip_v = false
			else:
				y_offset = 60.0
				rotation_degrees = 90
				$AnimatedSprite2D.flip_v = true
		position = Vector2(player.position.x - y_offset,
		player.get_node("Hitbox").global_position.y)
		player._jump_direction = 0
