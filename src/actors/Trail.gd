extends Line2D

@export var length: float
@export var wave_trail: bool
@export var enabled: bool = true
var point_pos: Vector2
@onready var player_icon = get_node("../Player/Icon")
@onready var player = get_node("../Player")

func _ready() -> void:
	clear_points()
	

func _physics_process(_delta: float) -> void:
	if enabled || get_tree().is_debugging_collisions_hint():
		global_position = Vector2.ZERO
		global_rotation = 0
		point_pos = player_icon.global_position
		if wave_trail:
			if player.mini:
				width = 15
			else:
				width = 20
			if player.gamemode == "wave":
				add_point(point_pos)
			else:
				clear_points()
		else:
			add_point(point_pos)
		while get_point_count() > length:
			remove_point(0)
