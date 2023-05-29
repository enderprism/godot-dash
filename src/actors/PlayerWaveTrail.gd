extends GPUParticles2D

@onready var player = get_parent().get_parent()

func _physics_process(delta: float) -> void:
	if player.gamemode == "wave":
		emitting = true
		speed_scale = 1
	else:
		emitting = false
		speed_scale = 15
	if player.mini:
		scale = Vector2(0.5, 0.5)
		process_material.scale = 0.55
	else:
		scale = Vector2(1.0, 1.0)
		process_material.scale = 1.1*0.6
