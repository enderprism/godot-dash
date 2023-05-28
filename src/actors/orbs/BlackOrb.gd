extends GDOrb

func _setVars() -> void:
	ring_sprite_name = "BlackRing"
	rotation_speed = 5.0
	signal_receptor_entered = "_on_BlackOrb_area_entered"
	signal_receptor_exited = "_on_BlackOrb_area_exited"
