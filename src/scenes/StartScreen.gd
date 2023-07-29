extends Control

var scene_to_go: String = "null"
''
func _ready() -> void:
	CurrentLevel.current_lvl_selector_page = 0.0
	CurrentLevel.scene_to_go = "null"
	pivot_offset.x = size.x / 2
	pivot_offset.y = size.y / 2
	if !MenuLoop.is_playing_menuloop(): MenuLoop.play_menuloop()
	$FadeScreen.show()
	$FadeScreen.fade_out()
	$FadeScreen.hide()

#func _on_LevelSelector_button_down() -> void:
#	$Menu/Buttons/AnimationPlayer.play("LevelSelectorClick")

func _on_LevelSelector_button_up() -> void:
	if $Menu/Buttons/LevelSelector.is_hovered():
		$FadeScreen.show()
		$FadeScreen.fade_in()
#	$Menu/Buttons/AnimationPlayer.play("LevelSelectorStopClick")
	scene_to_go = "res://src/scenes/LevelSelector.tscn"

#func _on_Icon_Selector_button_down() -> void:
#	$Menu/Buttons/AnimationPlayer.play("IconSelectorClick")
#
#func _on_Icon_Selector_button_up() -> void:
##	if $Menu/Buttons/IconSelector.is_hovered():
##		$FadeScreen.show()
##		$FadeScreen.fade_in()
#	$Menu/Buttons/AnimationPlayer.play("IconSelectorStopClick")

func _on_FadeScreen_fade_finished() -> void:
	if !scene_to_go == "null":
		get_tree().change_scene_to_file(scene_to_go)


func _on_CloseGame_button_up() -> void:
	if $CloseGame.is_hovered():
		get_tree().quit()


func _on_level_editor_pressed() -> void:
	if $Menu/Buttons/LevelEditor.is_hovered():
		$FadeScreen.show()
		$FadeScreen.fade_in()
	scene_to_go = "res://src/guiElements/LevelEditor.tscn"
