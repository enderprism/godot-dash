extends Area2D

signal minisize_portal_entered

onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("minisize_portal_entered", player, "_on_MiniSizePortal_area_entered")

func _on_MiniSizePortal_area_entered(_area: Area2D) -> void:
	emit_signal("minisize_portal_entered")
