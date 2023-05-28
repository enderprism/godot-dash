extends Area2D

signal normalsize_portal_entered

onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("normalsize_portal_entered", player, "_on_NormalSizePortal_area_entered")

func _on_NormalSizePortal_area_entered(_area: Area2D) -> void:
	emit_signal("normalsize_portal_entered")
