extends Node

var current_level: String
var current_level_scene: PackedScene
var is_camera_static: bool
var is_background_static: bool
var scene_to_go: String = "null"
var current_lvl_selector_page: float
var static_triggers_list: Array
var onetime_triggers_list: Array
var music_volume: float = 1.0
var sfx_volume: float = 1.0
var level_time: float
@onready var player = get_node("/root/Scene/Player")

func reset() -> void:
	is_background_static = false
	is_camera_static = false
	static_triggers_list.clear()

func reset_lvl_time():
	level_time = 0.0

func _physics_process(delta: float) -> void:
	if has_node("/root/Scene"):
		level_time += 0.016667
		Engine.time_scale = get_node("/root/Scene/Player").time_scale
	else:
		Engine.time_scale = 1.0

func set_scene_to_go(scene):
	scene_to_go = scene

func set_current_level(level):
	current_level = level

func set_if_camera_static(bg_static: bool, cam_static: bool):
	is_background_static = bg_static
	is_camera_static = cam_static

func set_current_page(page):
	current_lvl_selector_page = page

func append_static_trigger_to_list(trigger):
	static_triggers_list.append(trigger)

func append_onetime_trigger_to_list(trigger):
	onetime_triggers_list.append(trigger)

func set_music_volume(volume):
	music_volume = volume

func set_sfx_volume(volume):
	sfx_volume = volume
