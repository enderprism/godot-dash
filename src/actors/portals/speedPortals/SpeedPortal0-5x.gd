extends Area2D

signal speed_portal_05x_entered

onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("speed_portal_05x_entered", player, "_on_SpeedPortal05x_area_entered")

func _on_SpeedPortal05x_area_entered(_area: Area2D) -> void:
	emit_signal("speed_portal_05x_entered")
