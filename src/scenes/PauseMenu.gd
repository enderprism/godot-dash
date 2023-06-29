extends Control

var scene_to_go: String = "null"
@onready var player_camera = get_node("/root/Scene/PlayerCamera")
const base_position = Vector2(127.0, 1091)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") && not get_tree().paused:
		_pause_game()
	elif Input.is_action_just_pressed("pause") && get_tree().paused:
		_unpause_game()

func _pause_game():
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Menu/Labels/LevelName.text = CurrentLevel.current_level
	get_tree().paused = true

func _unpause_game():
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
#	rect_position = base_position
	get_tree().paused = false

func _on_Restart_button_up() -> void:
	if $Menu/Buttons/Restart.is_hovered():
		CurrentLevel.reset()
		CurrentLevel.reset_lvl_time()
		get_tree().reload_current_scene()
		get_tree().paused = false

func _on_ContinuePlaying_button_up() -> void:
	if $Menu/Buttons/ContinuePlaying.is_hovered():
		_unpause_game()


func _on_GoBackToMenu_button_up() -> void:
	scene_to_go = "res://src/scenes/LevelSelector.tscn"
	if $Menu/Buttons/GoBackToMenu.is_hovered():
		get_tree().paused = false
		get_node("/root/Scene/LevelMusic").stop()
		$FadeScreen.show()
		$FadeScreen.fade_in()
		$QuitSound.play()
		await get_tree().create_timer(0.3).timeout
		$QuitSound.stop()

func _on_FadeScreen_fade_finished() -> void:
	if !scene_to_go == "null":
		get_tree().change_scene_to_file(scene_to_go)
	$FadeScreen.hide()
