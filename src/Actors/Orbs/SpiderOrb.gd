extends Area2D

signal spider_orb_entered
signal spider_orb_exited

export var reverse: bool = false
export var opposite_gravity: bool = false
onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("spider_orb_entered", player, "_on_SpiderOrb_area_entered", [reverse, opposite_gravity]) # connect orb function to player
	connect("spider_orb_exited", player, "_on_SpiderOrb_area_exited") # connect orb function to player

func _on_SpiderOrb_area_entered(_area: Area2D) -> void:
	emit_signal("spider_orb_entered")

func _on_SpiderOrb_area_exited(_area: Area2D) -> void:
	emit_signal("spider_orb_exited")
