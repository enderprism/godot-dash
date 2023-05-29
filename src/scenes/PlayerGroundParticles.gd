extends GPUParticles2D

@onready var player = get_parent()
var _base_position = position

func _physics_process(delta: float) -> void:
	emitting = true if player.is_on_floor() || player.is_on_wall() else false
	if player.arrow_trigger_direction == Vector2(0.0, -1.0):
		if player.UP_DIRECTION.y == -1:
			if !player.gamemode == "wave": position.y = _base_position.y + 56
			else: position.y = _base_position.y + 26
		else:
			if !player.gamemode == "wave": position.y = _base_position.y - 56
			else: position.y = _base_position.y - 26
	if player.arrow_trigger_direction == Vector2(-1.0, 0.0):
		if player.gravity > 0:
			if !player.gamemode == "wave": position.x = _base_position.x + 56
			else: position.x = _base_position.x + 26
		else:
			if !player.gamemode == "wave": position.x = _base_position.x - 56
			else: position.x = _base_position.x - 26
