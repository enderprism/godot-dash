extends Area2D

@onready var _player
var _player_entered: bool = false
var _debug_time: float
signal player_entered
signal player_canjump

func _on_JBlock_area_entered(area: Area2D) -> void:
	_player.direction.y = 0
	_player_entered = true
	_player._in_jblock = true

func _physics_process(delta: float) -> void:
#	_debug_time += 1
	if _player_entered: 
		_player._in_jblock = true
	elif Input.is_action_just_pressed("jump"):
		_player_entered = false
		_player._in_jblock = false

func _ready() -> void:
	if CurrentLevel.in_editor:
		_player = get_node("/root/LevelEditor/GameScene/Player")
	else:
		_player = get_node("/root/Scene/Player")
