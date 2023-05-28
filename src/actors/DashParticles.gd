extends Particles2D

onready var player = get_parent()

func _physics_process(delta: float) -> void:
	emitting = true if player._is_dashing else false
	if player.mini:
		scale = Vector2(0.5, 0.5)
		process_material.scale = 0.25
	else:
		scale = Vector2(1.0, 1.0)
		process_material.scale = 0.75
