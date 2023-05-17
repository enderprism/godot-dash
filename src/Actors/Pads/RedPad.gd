extends Area2D

signal red_pad_entered

export var reverse: bool = false
onready var player: = get_node("/root/Scene/Player")

func _ready() -> void:
	connect("red_pad_entered", player, "_on_RedPad_area_entered", [reverse]) # connect pad function to player'


func _on_RedPad_area_entered(_area: Area2D) -> void:
	emit_signal("red_pad_entered")
