extends Area2D

@onready var _player
var _player_entered: bool = false

func _on_SBlock_area_entered(area: Area2D) -> void:
	_player.stopDashing()

func _ready() -> void:
	if CurrentLevel.in_editor:
		_player = get_node("/root/LevelEditor/GameScene/Player")
	else:
		_player = get_node("/root/Scene/Player")
