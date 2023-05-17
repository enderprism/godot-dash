extends Area2D

class_name GDOrb

export var reverse: bool = false
export var multi_usage: bool = false
onready var player: = get_node("/root/Scene/Player") 
var ring_sprite_name: String
var rotation_speed: float = 0.0
var signal_receptor_entered: String
var signal_receptor_exited: String

func _ready() -> void:
	_setVars()
	connect("area_entered", player, signal_receptor_entered, [reverse]) # connect orb function to player
	connect("area_exited", player, signal_receptor_exited) # connect orb function to player

func _physics_process(_delta: float) -> void:
	get_node(ring_sprite_name).rotation_degrees += rotation_speed
	if overlaps_area(player) && player._orb_jumped && !multi_usage:
		monitorable = false

func _setVars() -> void:
	pass
