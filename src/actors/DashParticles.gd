extends GPUParticles2D

@onready var player = owner

func _physics_process(delta: float) -> void:
	emitting = true if player._is_dashing else false
	if player.mini:
		scale = Vector2(0.5, 0.5)
		process_material.scale_min = 0.25
		process_material.scale_max = 0.25
	else:
		scale = Vector2(1.0, 1.0)
		process_material.scale_min = 0.75
		process_material.scale_max = 0.75
