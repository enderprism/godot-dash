extends CollisionPolygon2D

class_name SolidSlopeHitbox
signal player_entered

onready var player = get_node("/root/Scene/Player")

#func _physics_process(delta: float) -> void:
#	if get_parent() in player.area_detection.get_overlapping_bodies() && \
#	 ((scale.x > 0 && player.UP_DIRECTION.y < 0) || (scale.x < 0 && player.UP_DIRECTION.y > 0)):
#		player.floor_angle *= -1

#func _ready() -> void:
#	connect("player_entered", player, "get_slope", [get_parent()])
#
#func _on_PlayerDetector_area_entered(area: Area2D) -> void:
#	emit_signal("player_entered")
