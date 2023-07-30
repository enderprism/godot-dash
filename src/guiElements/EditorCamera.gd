extends Camera2D

var mouse_start_pos
var screen_start_position

var dragging = false
var can_drag = true

enum CameraEvents {
	DRAG,
	PAN_UP,
	PAN_DOWN,
	PAN_LEFT,
	PAN_RIGHT,
	ZOOM_OUT,
	ZOOM_IN,
} 

func _input(event):
	var events: Array
	events.resize(len(CameraEvents))
	if CurrentLevel.editor_camera_control_scheme == CurrentLevel.CameraControlScheme.GEOMETRYDASH:
		events[CameraEvents.DRAG] = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT
		events[CameraEvents.PAN_UP] = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and !Input.is_key_pressed(KEY_SHIFT) and !Input.is_key_pressed(KEY_CTRL) and event.pressed
		events[CameraEvents.PAN_DOWN] = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and !Input.is_key_pressed(KEY_SHIFT) and !Input.is_key_pressed(KEY_CTRL) and event.pressed
		events[CameraEvents.PAN_LEFT] = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and Input.is_key_pressed(KEY_SHIFT) and event.pressed
		events[CameraEvents.PAN_RIGHT] = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and Input.is_key_pressed(KEY_SHIFT) and event.pressed
		events[CameraEvents.ZOOM_OUT] = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and Input.is_key_pressed(KEY_CTRL) and event.pressed
		events[CameraEvents.ZOOM_IN] = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and Input.is_key_pressed(KEY_CTRL) and event.pressed
	elif CurrentLevel.editor_camera_control_scheme == CurrentLevel.CameraControlScheme.BLENDER:
		events[CameraEvents.DRAG] = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE
		events[CameraEvents.PAN_UP] = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and Input.is_key_pressed(KEY_SHIFT) and event.pressed
		events[CameraEvents.PAN_DOWN] = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and Input.is_key_pressed(KEY_SHIFT)and event.pressed
		events[CameraEvents.PAN_LEFT] = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and Input.is_key_pressed(KEY_CTRL) and event.pressed
		events[CameraEvents.PAN_RIGHT] = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and Input.is_key_pressed(KEY_CTRL) and event.pressed
		events[CameraEvents.ZOOM_OUT] = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and !Input.is_key_pressed(KEY_SHIFT) and !Input.is_key_pressed(KEY_CTRL) and event.pressed
		events[CameraEvents.ZOOM_IN] = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and !Input.is_key_pressed(KEY_SHIFT) and !Input.is_key_pressed(KEY_CTRL) and event.pressed
	
	if events[CameraEvents.DRAG]:
		if event.is_pressed() and can_drag:
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging and !get_tree().paused:
		position = Vector2(1/zoom.x, 1/zoom.y) * (mouse_start_pos - event.position) + screen_start_position
	
	if events[CameraEvents.PAN_UP]:
		_tween_prop("position", Vector2(position.x, position.y - 61 * 5 * 1/zoom.y))
	if events[CameraEvents.PAN_DOWN]:
		_tween_prop("position", Vector2(position.x, position.y + 61 * 5 * 1/zoom.y))
	if events[CameraEvents.PAN_LEFT]:
		_tween_prop("position", Vector2(position.x - 61 * 5 * 1/zoom.x, position.y))
	if events[CameraEvents.PAN_RIGHT]:
		_tween_prop("position", Vector2(position.x + 61 * 5 * 1/zoom.x, position.y))
	if events[CameraEvents.ZOOM_OUT]:
		if (zoom.x + 0.2 * zoom.x) < 11 && (zoom.y + 0.2 * zoom.y) < 11:
			_tween_prop("zoom", Vector2(zoom.x + 0.2 * zoom.x, zoom.y + 0.2 * zoom.y))
	if events[CameraEvents.ZOOM_IN]:
		if (zoom.x - 0.2 * zoom.x) > 0.45 && (zoom.y - 0.2 * zoom.y) > 0.45:
			_tween_prop("zoom", Vector2(zoom.x - 0.2 * zoom.x, zoom.y - 0.2 * zoom.y))

func _tween_prop(property: String, final_val: Vector2) -> void:
	var _tween = get_tree().create_tween()
	_tween.tween_property(
		self,
		property,
		final_val,
		0.1
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

@onready var _playtest_control = get_node("../EditorGUI/LevelEditor/EditorControls/PlaytestControl")
@onready var _edit_control = get_node("../EditorGUI/LevelEditor/EditorControls/EditControl")
@onready var _editor_bottom = get_node("../EditorGUI/LevelEditor/EditorBottom")

func _mouse_hovers(rect: Rect2):
	var _mouse_position = get_viewport().get_mouse_position()
	if rect.has_point(_mouse_position):
		return true
	else: return false

func _make_rect(node: Node) -> Rect2:
	return Rect2(node.position, node.size)

func _process(delta: float) -> void:
	if _mouse_hovers(_make_rect(_playtest_control)) || _mouse_hovers(_make_rect(_edit_control)) || _mouse_hovers(_make_rect(_editor_bottom)):
		can_drag = false
	else: can_drag = true
