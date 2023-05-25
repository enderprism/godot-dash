extends AnimatedSprite

onready var player = $"../Player"

func _on_Player_dead() -> void:
	frame = 0
	if player.mini:
		scale = Vector2(0.3, 0.3)
		position.x = player.position.x
		position.y = player.position.y - 15
	else:
		scale = Vector2(0.6, 0.6)
		position.x = player.position.x
		position.y = player.position.y - 30
