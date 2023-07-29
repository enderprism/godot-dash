extends Node2D

@export var levels: Array

func _ready() -> void:
	$TouchControlsGUI/JumpButtonTouchscreen.position = Vector2(0.0, 155.0)
	$TouchControlsGUI/JumpButtonTouchscreen.scale = Vector2(get_window().get_size().x/512, (get_window().get_size().y-430)/512)
	if $Player.is_platformer:
		$"TouchControlsGUI/platformer-controls".show()
		if $Player.gamemode == "wave":
			$TouchControlsGUI/JumpButtonTouchscreen2.position = Vector2(609.0, 804.0)
			$TouchControlsGUI/JumpButtonTouchscreen2.scale.x = get_window().get_size().x/512 - 609/512
		else:
			$TouchControlsGUI/JumpButtonTouchscreen2.position = Vector2(435.0, 804.0)
			$TouchControlsGUI/JumpButtonTouchscreen2.scale.x = get_window().get_size().x/512 - 435/512
	else:
		$"TouchControlsGUI/platformer-controls".hide()
		$TouchControlsGUI/JumpButtonTouchscreen2.position = Vector2(0.0, 804.0)
		$TouchControlsGUI/JumpButtonTouchscreen2.scale.x = get_window().get_size().x/512
	$PauseLayer/PauseMenu.size = get_window().get_size()
	$TouchControlsGUI/JumpButtonTouchscreen.position = Vector2(155.0, 0.0)
	$TouchControlsGUI/JumpButtonTouchscreen3.scale = Vector2(get_window().get_size().x/512, 0.303)
	CurrentLevel.scene_to_go = "null"
	MenuLoop.stop_menuloop()
	if self == get_tree().current_scene:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		enable_selected_level()

func disable_level(node):
	node.queue_free()

#func enable_selected_level(selected_level) -> void:
#	for level in levels:
#		if level != selected_level:
#			disable_level($Levels.get_node(level))
#		else:
#			$Levels.get_node(level).visible = true
#			$Player.is_platformer = $Levels.get_node(level).platformer
#			$LevelMusic.set_stream($Levels.get_node(level).level_music)
#			$LevelMusic.play($Levels.get_node(level).music_start)

func enable_selected_level() -> void:
	var packed_level = ResourceLoader.load(CurrentLevel.current_level_scene.resource_path, "", 0)
	var instanciated_level = packed_level.instantiate()
	$Levels.add_child(instanciated_level)
	var _level = $Levels.get_child(0)
	_level.scale = Vector2(0.5, 0.5)
	$Player.is_platformer = _level.platformer
	$LevelMusic.set_stream(_level.level_music)
	$LevelMusic.play(_level.music_start)

func _physics_process(delta: float) -> void:
	$"TouchControlsGUI/platformer-controls".visible = $Player.is_platformer
	if $Player.is_platformer:
		if $Player.gamemode == "wave":
			$TouchControlsGUI/JumpButtonTouchscreen2.position = Vector2(609.0, 804.0)
			$TouchControlsGUI/JumpButtonTouchscreen2.scale.x = get_window().get_size().x/512 - 609/512
		else:
			$TouchControlsGUI/JumpButtonTouchscreen2.position = Vector2(435.0, 804.0)
			$TouchControlsGUI/JumpButtonTouchscreen2.scale.x = get_window().get_size().x/512 - 435/512
	else:
		$TouchControlsGUI/JumpButtonTouchscreen2.position = Vector2(0.0, 804.0)
		$TouchControlsGUI/JumpButtonTouchscreen2.scale.x = get_window().get_size().x/512
	$"TouchControlsGUI/platformer-controls/platformer-down".visible = $Player.is_platformer && $Player.gamemode == "wave"
#	if Input.is_action_just_pressed("refresh_level"):
#		$Levels.get_child(0).queue_free()
#		var instanciated_level = load(CurrentLevel.current_level_path).instantiate()
#		$Levels.add_child(instanciated_level)
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -(50-CurrentLevel.music_volume*50))
