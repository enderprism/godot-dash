extends CanvasLayer

var radius_from_portal: float
var portal_y_coords: float
var freefly: bool
var screen_y_limit: float
@onready var ground_bottom = $Ground_Bottom
@onready var ground_top = $Ground_Top
@onready var player_camera = $"../PlayerCamera"

func _ready() -> void:
	freefly = true

func _freefly_setter(_freefly, _radius, _y_coords, _custom) -> void:
	screen_y_limit = player_camera.get_screen_center_position().y + 1080/2
	var prev_freefly_value = freefly
	freefly = _freefly
	radius_from_portal = _radius
	portal_y_coords = clamp(_y_coords, -5000, 183)
	player_camera.freefly = _freefly
	player_camera.unfreefly_center = portal_y_coords
	var ground_tween = get_tree().create_tween().set_parallel(true)
	if _custom == false:
		if freefly == false:
			ground_tween.tween_property(ground_bottom, "global_position:y", portal_y_coords + radius_from_portal, 0.3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			ground_tween.tween_property(ground_top, "global_position:y", portal_y_coords - radius_from_portal, 0.3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			ground_tween.tween_property(player_camera, "global_position:y", portal_y_coords, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		elif prev_freefly_value == false:
			ground_tween.tween_property(ground_bottom, "global_position:y", ground_bottom.global_position.y + 100*player_camera.zoom.y, 0.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			ground_tween.tween_property(ground_top, "global_position:y", ground_top.global_position.y - 100*player_camera.zoom.y, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			await ground_tween.finished
			ground_bottom.global_position.y = 488
			ground_top.global_position.y = -5500
