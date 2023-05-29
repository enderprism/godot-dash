extends Area2D

signal spider_portal_entered

@onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("spider_portal_entered", Callable(player, "_on_SpiderPortal_area_entered"))

func _on_SpiderPortal_area_entered(area: Area2D) -> void:
	emit_signal("spider_portal_entered")
