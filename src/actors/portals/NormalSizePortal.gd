extends Area2D

signal normalsize_portal_entered

@onready var player

func _ready() -> void:
	if CurrentLevel.in_editor:
		player = get_node("/root/LevelEditor/GameScene/Player")
	else:
		player = get_node("/root/Scene/Player")
	connect("normalsize_portal_entered", Callable(player, "_on_NormalSizePortal_area_entered"))

func _on_NormalSizePortal_area_entered(_area: Area2D) -> void:
	emit_signal("normalsize_portal_entered")
