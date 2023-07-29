extends Node2D

@export var _enabled = true
@export var cell_width = 61
@onready var _editor_camera = get_node("../EditorCamera")

func _draw():
	if _enabled: 
		var size = get_viewport_rect().size * 10 * _editor_camera.zoom / 2
		var cam = _editor_camera.position
		for i in range(int((cam.x - size.x) / cell_width) - 1, int((size.x + cam.x) / cell_width) + 1):
			draw_line(Vector2(i * cell_width, cam.y + size.y + 100), Vector2(i * cell_width, cam.y - size.y - 100), "000000")
		for i in range(int((cam.y - size.y) / cell_width) - 1, int((size.y + cam.y) / cell_width) + 1):
			draw_line(Vector2(cam.x + size.x + 100, i * cell_width), Vector2(cam.x - size.x - 100, i * cell_width), "000000")
