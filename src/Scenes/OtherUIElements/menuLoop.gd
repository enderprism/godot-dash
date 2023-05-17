extends AudioStreamPlayer

func play_menuloop() -> void:
	playing = true

func stop_menuloop() -> void:
	playing = false

func is_playing_menuloop() -> bool:
	return playing
