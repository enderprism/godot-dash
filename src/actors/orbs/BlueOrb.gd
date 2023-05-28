extends GDOrb

func _setVars() -> void:
	ring_sprite_name = "BlueRing"
	rotation_speed = 0.0
	signal_receptor_entered = "_on_BlueOrb_area_entered"
	signal_receptor_exited = "_on_BlueOrb_area_exited"
