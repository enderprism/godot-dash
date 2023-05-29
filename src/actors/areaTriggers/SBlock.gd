extends Area2D

@onready var _player = get_node("/root/Scene/Player")
var _player_entered: bool = false

func _on_SBlock_area_entered(area: Area2D) -> void:
	_player.stopDashing()
