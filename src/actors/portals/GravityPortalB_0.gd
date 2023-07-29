extends Area2D

signal blue_gravity_portal_entered

@onready var player

func _ready() -> void:
	if CurrentLevel.in_editor:
		player = get_node("/root/LevelEditor/GameScene/Player")
	else:
		player = get_node("/root/Scene/Player")
	connect("blue_gravity_portal_entered", Callable(player, "_on_BlueGravityPortal_area_entered"))

func _on_GravityPortalB_0_area_entered(_area: Area2D) -> void:
	emit_signal("blue_gravity_portal_entered")
