extends GDOrb

func _setVars() -> void:
	ring_sprite_name = "GreenRing"
	rotation_speed = 5.0
	signal_receptor_entered = "_on_GreenOrb_area_entered"
	signal_receptor_exited = "_on_GreenOrb_area_exited"
