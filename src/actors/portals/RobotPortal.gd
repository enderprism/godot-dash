extends Area2D

signal robot_portal_entered

@onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("robot_portal_entered", Callable(player, "_on_RobotPortal_area_entered"))

func _on_RobotPortal_area_entered(area: Area2D) -> void:
	emit_signal("robot_portal_entered")
