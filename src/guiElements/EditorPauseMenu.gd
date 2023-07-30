extends Control

var scene_to_go: String = "null"
const base_position = Vector2(127.0, 1091)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") && not get_tree().paused:
		_pause_game()
	elif Input.is_action_just_pressed("pause") && get_tree().paused:
		_unpause_game()
	if !$HBoxContainer/LeftSide/EditorOptions/show_ground.is_pressed():
		owner._hide_ground()
	else:
		owner._show_ground()

func _pause_game():
	show()
	get_tree().paused = true

func _unpause_game():
	hide()
	get_tree().paused = false

func _exit_editor():
	scene_to_go = "res://src/scenes/StartScreen.tscn"
	get_tree().paused = false
	if has_node("%LevelMusic"):
		get_node("%LevelMusic").stop()
	CurrentLevel.reset()
	$FadeScreen.show()
	$FadeScreen.fade_in()
	CurrentLevel.in_editor = false
	$QuitSound.play()
	await get_tree().create_timer(0.3).timeout
	$QuitSound.stop()

func _on_ContinuePlaying_button_up() -> void:
	if $Menu/Buttons/ContinuePlaying.is_hovered():
		_unpause_game()

func _on_FadeScreen_fade_finished() -> void:
	if !scene_to_go == "null":
		get_tree().change_scene_to_file(scene_to_go)
	$FadeScreen.hide()

func _on_resume_pressed() -> void:
	_unpause_game()

func _on_exit_pressed() -> void:
	_exit_editor()

func _on_option_button_item_selected(index: int) -> void:
	match index:
		2:
			owner.camera_control_scheme = CurrentLevel.CameraControlScheme.GEOMETRYDASH
		3:
			owner.camera_control_scheme = CurrentLevel.CameraControlScheme.BLENDER
