extends Control

export var _selected_level: String = "Trigger Test"
var new_pos: Vector2
const selection_width: int = 1920

func _ready() -> void:
	$Levels.rect_size.x = $Levels.get_child_count() * OS.get_window_size().x
	$Levels.rect_position.x = CurrentLevel.current_lvl_selector_page
	if !MenuLoop.is_playing_menuloop(): MenuLoop.play_menuloop()
#	$"Level Menu/Play Level/VBoxContainer/Label".text = selected_level
	$FadeScreen.show()
	$FadeScreen.fade_out()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		$FadeScreen.show()
		$FadeScreen.fade_in()
		CurrentLevel.scene_to_go = "res://src/scenes/StartScreen.tscn"
	if Input.is_action_just_pressed("ui_left"): _on_Left_pressed()
	if Input.is_action_just_pressed("ui_right"): _on_Right_pressed()


#func _on_GoBackButton_button_down() -> void:
#	$AnimationPlayer.play("GoBackButtonClick")

func _on_GoBackButton_button_up() -> void:
	if $GoBackButton.is_hovered():
		$FadeScreen.show()
		$FadeScreen.fade_in()
#	$AnimationPlayer.play("GoBackButtonStopClick")
	CurrentLevel.scene_to_go = "res://src/scenes/StartScreen.tscn"

func _on_FadeScreen_fade_finished() -> void:
	if !CurrentLevel.scene_to_go == "null":
		get_tree().change_scene(CurrentLevel.scene_to_go)
	$FadeScreen.hide()

func _on_Left_pressed() -> void:
	$Switch/PosTween.stop_all()
	$Levels.rect_position = new_pos # snaps in case the tween hasn't finished animating
	new_pos = Vector2(int($Levels.rect_position.x+selection_width), $Levels.rect_position.y)
	if new_pos.x >= selection_width:
		new_pos.x = -selection_width * ($Levels.get_child_count() - 1)
	$Switch/PosTween.remove_all()
	$Switch/PosTween.interpolate_property($Levels, "rect_position", null, new_pos, 0.2, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Switch/PosTween.start()
	CurrentLevel.set_current_page(new_pos.x)

func _on_Right_pressed() -> void:
	$Switch/PosTween.stop_all()
	$Levels.rect_position = new_pos # snaps in case the tween hasn't finished animating
	new_pos = Vector2(int($Levels.rect_position.x-selection_width) % int($Levels.rect_size.x), $Levels.rect_position.y)
	$Switch/PosTween.remove_all()
	$Switch/PosTween.interpolate_property($Levels, "rect_position", null, new_pos, 0.2, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Switch/PosTween.start()
	CurrentLevel.set_current_page(new_pos.x)
