extends Trigger

"""
TARGET PATH IS USELESS
"""


func _on_NormalTrigger_area_entered(area: Area2D) -> void:
	enter_static(get_node("/root/Scene/PlayerCamera"))

func _on_trigger_area_entered(area: Area2D) -> void:
	pass

func enter_static(camera):
	var trigger_tween = get_tree().create_tween().set_parallel()
	var end_pos: Vector2 = get_node("../"+value[0]).global_position
	# RESET THE CAMERA OFFSET WHEN ENTERING STATIC
	camera.drag_vertical_enabled = false
	trigger_tween.tween_property(
		camera,
		"offset",
		Vector2(0.0, 0.0),
		duration
	).set_trans(easing_curve).set_ease(easing_type)
	trigger_tween.tween_property(
		camera,
		"global_position",
		end_pos,
		duration
	).set_trans(easing_curve).set_ease(easing_type)
	trigger_tween.play()
#	CurrentLevel.set_if_camera_static(true)
	await trigger_tween.finished
#	is_static = true
