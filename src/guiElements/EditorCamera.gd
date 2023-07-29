extends Camera2D

var mouse_start_pos
var screen_start_position

var dragging = false

func _input(event):
	if CurrentLevel.editor_camera_control_scheme == CurrentLevel.CameraControlScheme.GEOMETRYDASH:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				mouse_start_pos = event.position
				screen_start_position = position
				dragging = true
			else:
				dragging = false
		elif event is InputEventMouseMotion and dragging and !get_tree().paused:
			position = Vector2(1/zoom.x, 1/zoom.y) * (mouse_start_pos - event.position) + screen_start_position
		## TODO: Refactor the code to be less repetitive
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and !Input.is_key_pressed(KEY_SHIFT) and !Input.is_key_pressed(KEY_CTRL) and event.pressed:
			_tween_prop("position", Vector2(position.x, position.y - 61 * 5 * 1/zoom.y))
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and !Input.is_key_pressed(KEY_SHIFT) and !Input.is_key_pressed(KEY_CTRL) and event.pressed:
			_tween_prop("position", Vector2(position.x, position.y + 61 * 5 * 1/zoom.y))
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and Input.is_key_pressed(KEY_SHIFT) and event.pressed:
			_tween_prop("position", Vector2(position.x + 61 * 5 * 1/zoom.x, position.y))
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and Input.is_key_pressed(KEY_SHIFT) and event.pressed:
			_tween_prop("position", Vector2(position.x - 61 * 5 * 1/zoom.x, position.y))
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and Input.is_key_pressed(KEY_CTRL) and event.pressed:
			if (zoom.x + 0.1 * zoom.x) < 11 && (zoom.y + 0.1 * zoom.y) < 11:
				_tween_prop("zoom", Vector2(zoom.x + 0.2 * zoom.x, zoom.y + 0.2 * zoom.y))
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and Input.is_key_pressed(KEY_CTRL) and event.pressed:
			if (zoom.x - 0.1 * zoom.x) > 0.41 && (zoom.y - 0.1 * zoom.y) > 0.41:
				_tween_prop("zoom", Vector2(zoom.x - 0.2 * zoom.x, zoom.y - 0.2 * zoom.y))

func _tween_prop(property: String, final_val: Vector2) -> void:
	get_tree().create_tween().tween_property(self, property, final_val, 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
