extends Area2D

signal cube_portal_entered

onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("cube_portal_entered", player, "_on_CubePortal_area_entered")

func _on_CubePortal_0_area_entered(_area: Area2D) -> void:
	emit_signal("cube_portal_entered")
