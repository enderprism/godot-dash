extends AnimatedSprite

onready var player = $"../Player"

func _on_Player_started_dashing() -> void:
	frame = 0
	if player.mini:
		scale = Vector2(0.3, 0.3)
		position.x = player.position.x
		position.y = player.position.y - 15
	else:
		scale = Vector2(0.75, 0.75)
		position.x = player.position.x
		position.y = player.position.y - 30
