@tool
extends Area2D

class_name Trigger

#export var actions = [{
#	"property": "",
#	"duration": 0.0,
#	"target": "object path",
#	"value": Vector2.ZERO,
#	"offset": false,
#	"easing type": 0,
#	"easing curve": 0,
#}]

"""
Trigger Docs:
The triggers are made of a list, that contains the actions.
The actions are made of a dictionary, describing their properties.
Property: the tweened property of the trigger.
Example: 
	Move, alpha, color, rotate, scale, camera triggers
Duration: the duration of the action. If it is 0.0 the action is instant (and not tweened)
Target: the path of the trigger's targetted object.
SPECIAL TARGET PATHS:
	PLAYERCAMERA: /root/Scene/PlayerCamera
	PLAYER: /root/Scene/Player
	GROUND: /root/Scene/Ground
	BACKGROUND: /root/Scene/Background
Value: the end value of the trigger. If it's a position, it can be a global position or an offset.
Relative: decides wether the target value should be added to the start value or replace it.
Example:
	relative Vector2(2, 1): moves 2 pixels to the right and 1 pixel down
	normal Vector2(61, 61): moves to 61, 61
Easing type and curve: the shape of the (imaginary) Bézier curve representing the easing of the action.
Possible types: 
	EASE_IN: 1, EASE_OUT: 2, EASE_IN_OUT: 3, EASE_OUT_IN: 4, CONSTANT: 5
Possible curves:
	TRANS_LINEAR = 0, TRANS_SINE = 1, TRANS_QUINT = 2, TRANS_QUART = 3, TRANS_QUAD = 4
	TRANS_EXPO = 5, TRANS_ELASTIC = 6, TRANS_CUBIC = 7, TRANS_CIRC = 8, TRANS_BOUNCE = 9
	TRANS_BACK = 10

IF YOU WANT TO DO A CAMERA STATIC:
	Camera2D static is possible if you put PLAYERCAMERA as the target and 'static' as the property.
	It will then require 2 arguments in Value:
		First: the object as its path. It will get its global_position.
		Second: the active axis as a Vector2, with 0 as inactive and 1 as active.
			For example, Vector2(0, 1) sets Y as active and X as inactive.
			Vector2(1, 1) sets both.
	You can exit static with setting 'exitStatic' to true.
	It will not require any Value.

SONG TRIGGER:
	Put the path as SONG and property as seek, and the first element of
	value as a float to the wanted song position.
"""
@export var target_path: String
@export var property: String
@export var duration: float
@export var value: Array = [Vector2.ZERO, Vector2.ZERO]
@export var relative: bool
@export_enum ("Ease In", "Ease Out", "Ease In-Out", "Ease Out-In", "Constant") var easing_type: int
@export_enum ("Linear", "Sine", "Quint", "Quart", "Quad", "Expo", "Elastic", "Cubic", "Circ", "Bounce", "Back") var easing_curve: int
@export var _is_exit_static: bool
@export var one_time: bool
#@export var show: bool

var static_pos
@onready var player_camera = get_node("/root/Scene/PlayerCamera")
@onready var player = get_node("/root/Scene/Player")

func _on_trigger_area_entered(area: Area2D) -> void:
	var target
	if (target_path != "" and property != "") || property == "random":
		if target_path != "":
			if "/root/Scene/" in target_path:
				target = get_node(target_path)
			elif target_path == "PLAYER":
				target = get_node("/root/Scene/Player")
			elif target_path == "PLAYERCAMERA":
				target = player_camera
			elif target_path == "GROUND":
				target = [
					get_node("/root/Scene/GroundManager/Ground_Bottom/Ground_Bottom_OBJ"),
					get_node("/root/Scene/GroundManager/Ground_Top/Ground_Top_OBJ")
				]
			elif target_path == "LINE":
				target = [
					get_node("/root/Scene/GroundManager/Ground_Bottom/Line_Bottom"),
					get_node("/root/Scene/GroundManager/Ground_Top/Line_Top")
				]
			elif target_path == "BACKGROUND":
				target = get_node("/root/Scene/Background")
			elif target_path == "SONG":
				target = get_node("/root/Scene/LevelMusic")
			else:
				target = get_node("../"+target_path)
		var trigger_tween = get_tree().create_tween().set_parallel()
		if target_path == "GROUND" || target_path == "LINE":
			if !relative:
				trigger_tween.parallel().tween_property(
					target[0],
					property,
					value[0],
					duration
				).set_trans(easing_curve).set_ease(easing_type)
				trigger_tween.parallel().tween_property(
					target[1],
					property,
					value[0],
					duration
				).set_trans(easing_curve).set_ease(easing_type)
			else:
				trigger_tween.parallel().tween_property(
					target[0],
					property,
					value[0],
					duration
				).as_relative().set_trans(easing_curve).set_ease(easing_type)
				trigger_tween.parallel().tween_property(
					target[1],
					property,
					value[0],
					duration
				).as_relative().set_trans(easing_curve).set_ease(easing_type)
		elif target_path == "PLAYERCAMERA" && property == "static":
			if _is_exit_static:
				exit_static(target)
			else:
				enter_static(target)
		elif property == "toggle":
			if value[0] == true:
				toggle_on(target)
			if value[0] == false:
				toggle_off(target)
		elif property == "random":
			var random = RandomNumberGenerator.new()
			random.randomize()
			var random_group = random.randi_range(0, 100)
			for i in range(len(value[1])):
				var group = value[1][i]
				var random_target = get_node("RandomGroups").get_child(i)
				if random_group >= group.x && random_group <= group.y:
					if value[0] == true:
						toggle_on(random_target)
					if value[0] == false:
						toggle_off(random_target)
		elif target_path == "SONG" && property == "seek":
			target.seek(value[0])
		else:
			if relative:
				trigger_tween.tween_property(
					target,
					property,
					value[0],
					duration
				).as_relative().set_trans(easing_curve).set_ease(easing_type)
				trigger_tween.play()
			else:
				trigger_tween.tween_property(
					target,
					property,
					value[0],
					duration
				).set_trans(easing_curve).set_ease(easing_type)
				trigger_tween.play()
	if one_time:
		self.process_mode = 4

func enter_static(camera):
	CurrentLevel.set_if_camera_static(value[1])
	var trigger_tween = get_tree().create_tween().set_parallel()
	var end_pos: Vector2 = get_node("../"+value[0]).global_position
	if value[1].x == 1:
		trigger_tween.tween_property(
			camera,
			"offset:x",
			0.0,
			duration
		).set_trans(easing_curve).set_ease(easing_type)
		trigger_tween.tween_property(
			camera,
			"position:x",
			end_pos.x,
			duration
		).set_trans(easing_curve).set_ease(easing_type)
	if value[1].y == 1:
		trigger_tween.parallel().tween_property(
			camera,
			"position:y",
			end_pos.y,
			duration
		).set_trans(easing_curve).set_ease(easing_type)
	trigger_tween.play()
#
func exit_static(camera):
	var trigger_tween = get_tree().create_tween().set_parallel()
	var end_pos: Vector2 = Vector2(
			camera.x_final_pos + player.speed.x * player._speed_multiplier * (duration+0.5),
			camera.y_final_pos
		)
	var end_offset: Vector2 = Vector2(camera.x_final_offset, camera.y_final_offset)
	trigger_tween.tween_property(
		camera,
		"offset",
		end_offset,
		duration
	).set_trans(easing_curve).set_ease(easing_type)
	trigger_tween.tween_property(
		camera,
		"position",
		end_pos,
		duration
	).set_trans(easing_curve).set_ease(easing_type)
	trigger_tween.play()
	await trigger_tween.finished
	CurrentLevel.set_if_camera_static(Vector2.ZERO)
	camera.horizontal_lerp_weight = 0.0
	await get_tree().create_timer(0.25).timeout
	camera.horizontal_lerp_weight = 0.5

func toggle_off(_toggled_group):
	_toggled_group.process_mode = 4 # = Mode: Disabled
	_toggled_group.hide()

func toggle_on(_toggled_group):
	_toggled_group.process_mode = 0 # = Mode: Inherit
	_toggled_group.show()
#	if show: _toggled_group.show()

func _ready() -> void:
	set_monitorable(true)

func _set_trigger_icon() -> void:
	$TriggerIcon.global_rotation = 0.0
	if property == "position":
		$TriggerIcon.texture = load("res://assets/levelTextures/triggers/edit_eMoveComBtn_001.png")
	elif property == "scale":
		$TriggerIcon.texture = load("res://assets/levelTextures/triggers/edit_eScaleComBtn_001.png")
	elif property == "arrow_trigger_direction":
		if value[0] == Vector2(-1.0, 0.0):
			$TriggerIcon.global_rotation_degrees = -90.0
		elif value[0] == Vector2(0.0, -1.0):
			$TriggerIcon.global_rotation_degrees = 0.0
		$TriggerIcon.texture = load("res://assets/levelTextures/triggers/edit_eGameRotBtn_001.png")
	elif property == "rotation_degrees" && target_path == "PLAYERCAMERA":
		$TriggerIcon.texture = load("res://assets/levelTextures/triggers/edit_eCamRotBtn_001.png")
	elif property == "rotation_degrees" && target_path != "PLAYERCAMERA":
		$TriggerIcon.texture = load("res://assets/levelTextures/triggers/edit_eRotateComBtn_001.png")
	elif property == "zoom" && target_path == "PLAYERCAMERA":
		$TriggerIcon.texture = load("res://assets/levelTextures/triggers/edit_eZoomBtn_001.png")
	elif property == "static" && target_path == "PLAYERCAMERA":
		$TriggerIcon.texture = load("res://assets/levelTextures/triggers/edit_eStaticBtn_001.png")
	elif property == "offset" && target_path == "PLAYERCAMERA":
		$TriggerIcon.texture = load("res://assets/levelTextures/triggers/edit_eOffsetBtn_001.png")
	elif property == "modulate":
		$TriggerIcon.texture = load("res://assets/levelTextures/triggers/edit_eTintCol01Btn_001.png")
	elif property == "toggle":
		if value[0]:
			$TriggerIcon.texture = load("res://assets/levelTextures/triggers/edit_eToggleBtn3_002.png")
		else:
			$TriggerIcon.texture = load("res://assets/levelTextures/triggers/edit_eToggleBtn3_001.png")
	elif property == "random":
		$TriggerIcon.texture = load("res://assets/levelTextures/triggers/edit_eRandomBtn_001.png")
	elif property == "_x_direction" && target_path == "PLAYER":
		$TriggerIcon.texture = load("res://assets/levelTextures/triggers/edit_eReverseBtn_001.png")
	elif property == "seek":
		$TriggerIcon.texture = load("res://assets/levelTextures/triggers/edit_eSongBtn_001.png")
	elif property == "time_scale":
		$TriggerIcon.texture = load("res://assets/levelTextures/triggers/edit_eTimeWarpBtn_001.png")
	elif property == "":
		$TriggerIcon.texture = load("res://assets/levelTextures/triggers/edit_eEmptyBtn_001.png")

func _physics_process(_delta: float) -> void:
	if get_tree().is_debugging_collisions_hint() || Engine.is_editor_hint():
		# Code to execute when in editor.
		$TriggerIcon.show()
		_set_trigger_icon()
	else:
		$TriggerIcon.hide()
#	if len(CurrentLevel.onetime_triggers_list) >= 1:
#		get_node(CurrentLevel.onetime_triggers_list[0]).set_monitorable(false)
#		get_node(CurrentLevel.onetime_triggers_list[0]).set_monitoring(false)
#		CurrentLevel.onetime_triggers_list.remove_at(0)
#	if CurrentLevel.is_camera_static && property == "static" && !_is_exit_static && len(CurrentLevel.static_triggers_list) > 0:
#		if get_node(CurrentLevel.static_triggers_list[0]).value[1].x == 1.0:
#			player_camera.global_position.x = get_node("../"+str(get_node(CurrentLevel.static_triggers_list[0]).value[0])).global_position.x
#		if get_node(CurrentLevel.static_triggers_list[0]).value[1].y== 1.0:
#			player_camera.global_position.y = get_node("../"+str(get_node(CurrentLevel.static_triggers_list[0]).value[0])).global_position.y
