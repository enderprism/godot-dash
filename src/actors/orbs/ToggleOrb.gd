extends Area2D

class_name toggler

@onready var _player
@onready var _toggled_group: = get_node("ToggledGroup")
@export var _enable: bool = false
@export var _switch: bool = false
var _player_entered: bool = false
const SCALE_DISABLED: Vector2 = Vector2(0.0, 0.0)
const SCALE_ENABLED: Vector2 = Vector2(1.0, 1.0)

signal toggle_orb_entered
signal toggle_orb_exited
signal toggle_orb_pressed

func _ready() -> void:
	if CurrentLevel.in_editor:
		_player = get_node("/root/LevelEditor/GameScene/Player")
	else:
		_player = get_node("/root/Scene/Player")
	connect("toggle_orb_entered", Callable(_player, "_on_ToggleOrb_area_entered"))
	connect("toggle_orb_exited", Callable(_player, "_on_ToggleOrb_area_exited"))

func _physics_process(_delta: float) -> void:
	$ToggleRing.self_modulate = self_modulate
	if _player_entered && Input.is_action_pressed("jump") && _player._has_let_go_of_orb:
		emit_signal("toggle_orb_pressed")
		_player_entered = false
		if has_node("ToggledGroup"):
			if _switch:
				if _toggled_group.scale == SCALE_DISABLED: toggle_on()
				elif _toggled_group.scale == SCALE_ENABLED: toggle_off()
			elif _enable: toggle_on()
			elif !_enable: toggle_off()

func toggle_off():
	_toggled_group.global_position.y = 500
	_toggled_group.scale = Vector2(0.0, 0.0)

func toggle_on():
	_toggled_group.global_position.x = global_position.x
	_toggled_group.global_position.y = global_position.y
	_toggled_group.scale = Vector2(1.0, 1.0)

func _on_ToggleOrb_area_entered(_area: Area2D) -> void:
	_player_entered = true
	emit_signal("toggle_orb_entered")

func _on_ToggleOrb_area_exited(_area: Area2D) -> void:
	_player_entered = false
	emit_signal("toggle_orb_exited")
