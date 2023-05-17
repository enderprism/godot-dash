extends Area2D

signal swingcopter_portal_entered

onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("swingcopter_portal_entered", player, "_on_SwingcopterPortal_area_entered")

func _on_SwingcopterPortal_area_entered(area: Area2D) -> void:
	emit_signal("swingcopter_portal_entered")
