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
	PLAYERCAMERA: /root/Scene/Player/Camera2D
	PLAYER: /root/Scene/Player
	GROUND: /root/Scene/Ground
	BACKGROUND: /root/Scene/Background
Value: the end value of the trigger. If it's a position, it can be a global position or an offset.
Offset: decides wether the target coordinates should offset the position or set it.
Example:
	offset Vector2(2, 1): moves 2 pixels to the right and 1 pixel down
	normal Vector2(61, 61): moves to 61, 61
Easing type and curve: the shape of the (imaginary) Bézier curve representing the easing of the action.
Possible types: 
	EASE_IN: 1, EASE_OUT: 2, EASE_IN_OUT: 3, EASE_OUT_IN: 4, CONSTANT: 5
Possible curves:
	TRANS_LINEAR = 0, TRANS_SINE = 1, TRANS_QUINT = 2, TRANS_QUART = 3, TRANS_QUAD = 4
	TRANS_EXPO = 5, TRANS_ELASTIC = 6, TRANS_CUBIC = 7, TRANS_CIRC = 8, TRANS_BOUNCE = 9
	TRANS_BACK = 10

IF YOU WANT TO DO A CAMERA STATIC:
	Camera static is possible if you put PLAYERCAMERA as the target and 'static' as the property.
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
export var target_path: String
export var duration: float
export var property: String
export var value: Array = [Vector2.ZERO, Vector2.ZERO]
export var relative: bool
export(int, "Ease In", "Ease Out", "Ease In-Out", "Ease Out-In", "Constant") var easing_type
export(int, "Linear", "Sine", "Quint", "Quart", "Quad", "Expo", "Elastic", "Cubic", "Circ", "Bounce", "Back") var easing_curve
export var exit_static: bool
export var one_time: bool
export var show: bool

var is_static: bool
var static_pos
onready var player_camera = get_node("/root/Scene/Player/Camera2D")
onready var player = get_node("/root/Scene/Player")

func _on_trigger_area_entered(area: Area2D) -> void:
	var target: Object
	if (target_path != "" and property != "") || property == "random":
		if target_path != "":
			if "/root/Scene/" in target_path:
				target = get_node(target_path)
			elif target_path == "PLAYER":
				target = get_node("/root/Scene/Player")
			elif target_path == "PLAYERCAMERA":
				target = player_camera
			elif target_path == "GROUND":
				target = get_node("/root/Scene/Ground")
			elif target_path == "LINE":
				target = get_node("/root/Scene/Line")
			elif target_path == "BACKGROUND":
				target = get_node("/root/Scene/Background")
			elif target_path == "SONG":
				target = get_node("/root/Scene/LevelMusic")
			else:
				target = get_node("../"+target_path)
		else:
			print("No group defined!")
			pass
		var trigger_tween = get_tree().create_tween().set_parallel()
		if target_path == "PLAYERCAMERA" && property == "static":
			if exit_static:
				exit_static(target)
				player.is_static = false
			else:
				enter_static(target)
				player.is_static = true
				is_static = true
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
		CurrentLevel.append_onetime_trigger_to_list(get_path())
		set_monitorable(false)

func enter_static(camera):
	var trigger_tween = get_tree().create_tween().set_parallel()
	var end_pos: Vector2 = get_node("../"+value[0]).global_position
	# Append current trigger to active triggers
	CurrentLevel.append_static_trigger_to_list(get_path())
	get_node(CurrentLevel.static_triggers_list[0]).set_process_priority(3)
	if len(CurrentLevel.static_triggers_list) >= 2:
		get_node(CurrentLevel.static_triggers_list[0]).set_process_priority(1)
		get_node(CurrentLevel.static_triggers_list[1]).set_process_priority(2)
		CurrentLevel.static_triggers_list.remove(0)
	if value[1].x == 1:
		camera.drag_margin_h_enabled = false
	elif value[1].y == 1:
		camera.drag_margin_v_enabled = false
		camera.drag_margin_bottom = 1.0
	if value[1].x == 1:
		trigger_tween.tween_property(
			camera,
			"offset:x",
			0.0,
			duration
		).set_trans(easing_curve).set_ease(easing_type)
		trigger_tween.tween_property(
			camera,
			"global_position:x",
			end_pos.x,
			duration
		).set_trans(easing_curve).set_ease(easing_type)
	if value[1].y == 1:
		trigger_tween.tween_property(
			camera,
			"offset:y",
			0.0,
			duration
		).set_trans(easing_curve).set_ease(easing_type)
		trigger_tween.parallel().tween_property(
			camera,
			"global_position:y",
			end_pos.y,
			duration
		).set_trans(easing_curve).set_ease(easing_type)
	trigger_tween.play()
	yield(trigger_tween, "finished")
	if value[1].x == 1:
		CurrentLevel.set_if_camera_static(true, true)
	elif value[1].y == 1:
		CurrentLevel.set_if_camera_static(false, true)
	static_pos = end_pos

func exit_static(camera):
	var trigger_tween = get_tree().create_tween().set_parallel()
	var end_pos: Vector2 = Vector2(0.0, 62.0)
	var end_offset: Vector2 = Vector2(0.0, -225.0)
	if player.arrow_trigger_direction == Vector2(0.0, -1.0):
		end_offset.x = 200 if player._x_direction > 0 else -200
	elif player.arrow_trigger_direction == Vector2(-1.0, 0.0):
		end_offset.x = 200 if player._x_direction > 0 else -200
	if player.arrow_trigger_direction == Vector2(-1.0, 0.0):
		camera.drag_margin_h_enabled = true
	elif player.arrow_trigger_direction == Vector2(0.0, -1.0):
		camera.drag_margin_v_enabled = true
	camera.drag_margin_bottom = 0.0
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
	CurrentLevel.set_if_camera_static(false, false)

func toggle_off(_toggled_group):
	_toggled_group.global_position.y = 500
	_toggled_group.scale = Vector2(0.0, 0.0)

func toggle_on(_toggled_group):
	_toggled_group.global_position.x = global_position.x
	_toggled_group.global_position.y = global_position.y
	if show: _toggled_group.visible = true
	_toggled_group.scale = Vector2(1.0, 1.0)

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
	elif property == "":
		$TriggerIcon.texture = load("res://assets/levelTextures/triggers/edit_eEmptyBtn_001.png")

func _physics_process(_delta: float) -> void:
	if Engine.editor_hint:
		# Code to execute when in editor.
		$TriggerIcon.show()
		_set_trigger_icon()
	else:
		$TriggerIcon.hide()
	if len(CurrentLevel.onetime_triggers_list) >= 1:
		get_node(CurrentLevel.onetime_triggers_list[0]).set_monitorable(false)
		get_node(CurrentLevel.onetime_triggers_list[0]).set_monitoring(false)
		CurrentLevel.onetime_triggers_list.remove(0)
	if CurrentLevel.is_camera_static && property == "static" && !exit_static && len(CurrentLevel.static_triggers_list) > 0:
		if get_node(CurrentLevel.static_triggers_list[0]).value[1].x == 1.0:
			player_camera.global_position.x = get_node("../"+str(get_node(CurrentLevel.static_triggers_list[0]).value[0])).global_position.x
		if get_node(CurrentLevel.static_triggers_list[0]).value[1].y== 1.0:
			player_camera.global_position.y = get_node("../"+str(get_node(CurrentLevel.static_triggers_list[0]).value[0])).global_position.y
