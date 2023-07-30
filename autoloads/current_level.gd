extends Node

var current_level: String
var current_level_scene: PackedScene
var is_camera_static: Vector2
var scene_to_go: String = "null"
var current_lvl_selector_page: float
var onetime_triggers_list: Array
var music_volume: float = 1.0
var sfx_volume: float = 1.0
var level_time: float
var in_editor: bool
var editor_active_camera: ActiveCamera
var editor_is_playtesting: bool
var editor_camera_control_scheme: CameraControlScheme

enum CameraControlScheme {
	GEOMETRYDASH = 0,
	BLENDER = 1,
}

enum ActiveCamera {
	EDITORCAMERA,
	PLAYERCAMERA,
}

func reset() -> void:
	is_camera_static = Vector2.ZERO
	editor_is_playtesting = false

func reset_lvl_time():
	level_time = 0.0

func _physics_process(delta: float) -> void:
	if has_node("/root/Scene"):
		level_time += 0.016667
		Engine.time_scale = get_node("/root/Scene/Player").time_scale
	if in_editor && editor_is_playtesting:
		level_time += 0.016667
		Engine.time_scale = get_node("/root/LevelEditor/GameScene/Player").time_scale
	else:
		Engine.time_scale = 1.0

func set_scene_to_go(scene):
	scene_to_go = scene

func set_current_level(level):
	current_level = level

func set_current_page(page):
	current_lvl_selector_page = page

func append_onetime_trigger_to_list(trigger):
	onetime_triggers_list.append(trigger)

func set_music_volume(volume):
	music_volume = volume

func set_sfx_volume(volume):
	sfx_volume = volume
