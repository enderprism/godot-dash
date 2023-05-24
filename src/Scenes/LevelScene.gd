extends Node2D

export var levels: Array

func _ready() -> void:
	$GUI/JumpButtonTouchscreen.position = Vector2(0.0, 155.0)
	$GUI/JumpButtonTouchscreen.scale = Vector2(OS.get_window_size().x/512, (OS.get_window_size().y-430)/512)
	if $Player.is_platformer:
		$"GUI/platformer-controls".show()
		if $Player.gamemode == "wave":
			$GUI/JumpButtonTouchscreen2.position = Vector2(609.0, 804.0)
			$GUI/JumpButtonTouchscreen2.scale.x = OS.get_window_size().x/512 - 609/512
		else:
			$GUI/JumpButtonTouchscreen2.position = Vector2(435.0, 804.0)
			$GUI/JumpButtonTouchscreen2.scale.x = OS.get_window_size().x/512 - 435/512
	else:
		$"GUI/platformer-controls".hide()
		$GUI/JumpButtonTouchscreen2.position = Vector2(0.0, 804.0)
		$GUI/JumpButtonTouchscreen2.scale.x = OS.get_window_size().x/512
	$PauseLayer/PauseMenu.rect_size = OS.get_window_size()
	$GUI/JumpButtonTouchscreen.position = Vector2(155.0, 0.0)
	$GUI/JumpButtonTouchscreen3.scale = Vector2(OS.get_window_size().x/512, 0.303)
	CurrentLevel.scene_to_go = "null"
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	MenuLoop.stop_menuloop()
	enable_selected_level(CurrentLevel.current_level)

func disable_level(node):
	node.queue_free()

func enable_selected_level(selected_level) -> void:
	for level in levels:
		if level != selected_level:
			disable_level($Levels.get_node(level))
		else:
			$Levels.get_node(level).visible = true
			$Player.is_platformer = $Levels.get_node(level).platformer
			$LevelMusic.set_stream($Levels.get_node(level).level_music)
			$LevelMusic.play($Levels.get_node(level).music_start)

func _physics_process(delta: float) -> void:
	$"GUI/platformer-controls".visible = $Player.is_platformer
	if $Player.is_platformer:
		if $Player.gamemode == "wave":
			$GUI/JumpButtonTouchscreen2.position = Vector2(609.0, 804.0)
			$GUI/JumpButtonTouchscreen2.scale.x = OS.get_window_size().x/512 - 609/512
		else:
			$GUI/JumpButtonTouchscreen2.position = Vector2(435.0, 804.0)
			$GUI/JumpButtonTouchscreen2.scale.x = OS.get_window_size().x/512 - 435/512
	else:
		$GUI/JumpButtonTouchscreen2.position = Vector2(0.0, 804.0)
		$GUI/JumpButtonTouchscreen2.scale.x = OS.get_window_size().x/512
	$"GUI/platformer-controls/platformer-down".visible = $Player.is_platformer && $Player.gamemode == "wave"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -(50-CurrentLevel.music_volume*50))
