extends GDOrb

func _setVars() -> void:
	ring_sprite_name = "RedRing"
	rotation_speed = 0.0
	signal_receptor_entered = "_on_RedOrb_area_entered"
	signal_receptor_exited = "_on_RedOrb_area_exited"
