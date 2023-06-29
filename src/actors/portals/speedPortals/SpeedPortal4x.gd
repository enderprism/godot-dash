extends Area2D

signal speed_portal_4x_entered

@onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("speed_portal_4x_entered", Callable(player, "_on_SpeedPortal4x_area_entered"))

func _on_SpeedPortal4x_area_entered(_area: Area2D) -> void:
	emit_signal("speed_portal_4x_entered")
