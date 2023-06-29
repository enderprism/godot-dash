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
			For example, Vector2(0, 1) sets X as inactive and Y as active.
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

var interpolatedWeight: float
var initialValue
var static_pos
var isInterpolating: bool = false
var target
var pos_offset: Vector2
var rot_offset: float
@onready var player_camera = get_node("/root/Scene/PlayerCamera")
@onready var player = get_node("/root/Scene/Player")

func _on_trigger_body_entered(_body: Node2D) -> void:
	var trigger_tween = get_tree().create_tween()
	trigger_tween.finished.connect(_stop_interpolating)	
	isInterpolating = true
	trigger_tween.tween_property(self, "interpolatedWeight", 1.0, duration).from(0.0).set_ease(easing_type).set_trans(easing_curve)
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
		
		if target_path == "GROUND" || target_path == "LINE":
			initialValue = [target[0].get(property), target[1].get(property)]
		elif target_path == "PLAYERCAMERA" && property == "static":
			initialValue = [
				player_camera.position,
				player_camera.offset
			]
			if typeof(value[0]) == TYPE_STRING:
				value[0] = get_node("../"+value[0]).global_position
		elif property == "position" && typeof(value[0]) == TYPE_STRING:
			initialValue = target.get("global_position")
		elif property == "follow":
			initialValue = target.get("global_position")
		elif property == "toggle":
			isInterpolating = false
		else:
			initialValue = target.get(property)
		
		if relative:
			if !typeof(value[0]) == TYPE_STRING:
				value[0] += initialValue
			else:
				if value[0] == "PLAYER":
					if property == "position":
						pos_offset = initialValue - player.position
					elif property == "rotation_degrees":
						rot_offset = initialValue - player.get_node("Icon").rotation_degrees
				else:
					pos_offset = initialValue - get_node("../"+value[0]).global_position
		
		if property == "toggle":
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

func _stop_interpolating() -> void:
	if _is_exit_static:
		CurrentLevel.is_camera_static = Vector2(0.0, 0.0)
	isInterpolating = false
	if one_time:
		set_process_mode(PROCESS_MODE_DISABLED)

func _physics_process(_delta: float) -> void:
	if get_tree().is_debugging_collisions_hint() || Engine.is_editor_hint():
		# Code to execute when in editor.
		$TriggerIcon.show()
		_set_trigger_icon()
	else:
		$TriggerIcon.hide()
	if isInterpolating:
		if duration <= _delta:
			interpolatedWeight = 1.0
		if target_path == "GROUND" || target_path == "LINE":
			target[0].set(property, lerp(initialValue[0], value[0], interpolatedWeight))
			target[1].set(property, lerp(initialValue[1], value[0], interpolatedWeight))
		elif target_path == "PLAYERCAMERA" && property == "static":
			if !_is_exit_static:
				CurrentLevel.is_camera_static = value[1]
				if value[1].x == 1.0:
					player_camera.position.x = lerpf(
						initialValue[0].x,
						value[0].x,
						interpolatedWeight
					)
					player_camera.offset.x = lerpf(
						initialValue[1].x,
						0.0,
						interpolatedWeight
					)
				if value[1].y == 1.0:
					player_camera.position.y = lerpf(
						initialValue[0].y,
						clampf(value[0].y, player_camera.MIN_HEIGHT, player_camera.MAX_HEIGHT),
						interpolatedWeight
					)
					player_camera.offset.y = lerpf(
						initialValue[1].y,
						0.0,
						interpolatedWeight
					)
			else:
				player_camera.position = lerp(
					initialValue[0],
					Vector2(player_camera.x_final_pos, player_camera.y_final_pos),
					interpolatedWeight
				)
				player_camera.offset = lerp(
					initialValue[1],
					Vector2(player_camera.x_final_offset, player_camera.y_final_offset),
					interpolatedWeight
				)
		elif property == "position" && typeof(value[0]) == TYPE_STRING:
			var end_pos: Vector2
			if value[0] == "PLAYER":
				end_pos = player.position
			else:
				end_pos = get_node("../"+value[0]).global_position
			if relative:
				if value[1].x == 1.0:
					target.global_position.x = end_pos.x + pos_offset.x
				if value[1].y == 1.0:
					target.global_position.y = end_pos.y + pos_offset.y
			else:
				if value[1].x == 1.0:
					target.global_position.x = lerpf(initialValue.x, end_pos.x, interpolatedWeight)
				if value[1].y == 1.0:
					target.global_position.y = lerpf(initialValue.y, end_pos.y, interpolatedWeight)
		elif property == "rotation_degrees" && typeof(value[0]) == TYPE_STRING && value[0] == "PLAYER":
			var end_rot: float = player.get_node("Icon").rotation_degrees
			if relative:
				target.global_rotation_degrees = end_rot + rot_offset
			else:
				target.global_rotation_degrees = end_rot
		elif !(target_path == "SONG" || property == "toggle" || property == "random"):
			if typeof(initialValue) == TYPE_FLOAT:
				target.set(property, lerpf(initialValue, value[0], interpolatedWeight))
			else:
				target.set(property, lerp(initialValue, value[0], interpolatedWeight))

func toggle_off(_toggled_group):
	_toggled_group.process_mode = 4 # = Mode: Disabled
	_toggled_group.hide()

func toggle_on(_toggled_group):
	_toggled_group.process_mode = 0 # = Mode: Inherit
	_toggled_group.show()
#	if show: _toggled_group.show()

func _ready() -> void:
	CurrentLevel.is_camera_static = Vector2.ZERO
	set_monitorable(true)
	if !Engine.is_editor_hint(): hide()

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
