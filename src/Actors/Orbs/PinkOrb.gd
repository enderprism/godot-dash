extends GDOrb

func _setVars() -> void:
	ring_sprite_name = "PinkRing"
	rotation_speed = 0.0
	signal_receptor_entered = "_on_PinkOrb_area_entered"
	signal_receptor_exited = "_on_PinkOrb_area_exited"
