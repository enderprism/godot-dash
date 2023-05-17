extends GDOrb

func _setVars() -> void:
	ring_sprite_name = "YellowRing"
	rotation_speed = 0.0
	signal_receptor_entered = "_on_YellowOrb_area_entered"
	signal_receptor_exited = "_on_YellowOrb_area_exited"
