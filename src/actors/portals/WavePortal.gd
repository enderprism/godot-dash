extends Area2D

signal wave_portal_entered

onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("wave_portal_entered", player, "_on_WavePortal_area_entered")

func _on_WavePortal_0_area_entered(area: Area2D) -> void:
	emit_signal("wave_portal_entered")
