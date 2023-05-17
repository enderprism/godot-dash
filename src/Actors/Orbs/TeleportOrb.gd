extends Area2D

onready var _player: = get_node("/root/Scene/Player")
var _player_entered: bool = false
export var y_only: bool = false
signal entered_tp_orb
signal exited_tp_orb

func _ready() -> void:
	connect("entered_tp_orb", _player, "_on_ToggleOrb_area_entered")
	connect("exited_tp_orb", _player, "_on_ToggleOrb_area_exited")

func _physics_process(delta: float) -> void:
	if _player_entered && Input.is_action_pressed("jump") && _player._has_let_go_of_orb:
		_player_entered = false
		if y_only:
			_player.global_position.y = get_node("ExitTeleportOrb").get_global_position().y
		else:
			_player.global_position = get_node("ExitTeleportOrb").get_global_position()

func _on_TeleportOrb_area_entered(area: Area2D) -> void:
	emit_signal("entered_tp_orb")
	_player_entered = true

func _on_TeleportOrb_area_exited(area: Area2D) -> void:
	emit_signal("exited_tp_orb")
	_player_entered = false
