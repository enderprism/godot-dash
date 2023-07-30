extends BaseButton

@export var _switch_scene: bool = false
@export var _scene_to_go: String
@export var _level_selector_button: bool = false
@export var _selected_level: String
@export var _block_palette_button: bool
var _selected_level_scene: PackedScene

func _ready() -> void:
	connect("button_down", Callable(self, "_button_held"))
	connect("button_up", Callable(self, "_button_unheld"))

func _physics_process(_delta: float) -> void:
	pivot_offset.x = size.x/2
	pivot_offset.y = size.y/2
	if _block_palette_button:
		if is_pressed():
			modulate = Color("808080")
		else:
			modulate = Color("ffffff")

func _button_held() -> void:
	var scale_tween = create_tween()
	scale_tween.set_ease(Tween.EASE_OUT)
	scale_tween.set_trans(Tween.TRANS_BOUNCE)
	scale_tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)

func _button_unheld() -> void:
	var scale_tween = create_tween()
	scale_tween.set_ease(Tween.EASE_OUT)
	scale_tween.set_trans(Tween.TRANS_BOUNCE)
	scale_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)
	if _switch_scene:
		if _level_selector_button:
			get_node("/root/LevelSelector/playLevelSound").play()
			MenuLoop.stop_menuloop()
			CurrentLevel.current_level = _selected_level
			CurrentLevel.current_level_scene = _selected_level_scene
			if _scene_to_go == "GameScene":
				_scene_to_go = "res://src/scenes/GameScene.tscn"
			CurrentLevel.scene_to_go = _scene_to_go
			await get_tree().create_timer(1).timeout
			CurrentLevel.scene_to_go = _scene_to_go
			owner.owner.get_node("FadeScreen").fade_in()
		else:
			CurrentLevel.scene_to_go = _scene_to_go
			owner.get_node("FadeScreen").fade_in()
