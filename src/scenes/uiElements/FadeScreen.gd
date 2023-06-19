extends ColorRect

signal fade_finished

func _ready() -> void:
	color = Color("000000ff")

func fade_in() -> void:
	show()
	color = Color("00000000")
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(self, "color", Color("000000ff"), 0.2)
	await fade_tween.finished
	emit_signal("fade_finished")

func fade_out() -> void:
	show()
	color = Color("000000ff")
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(self, "color", Color("00000000"), 0.2)
	await fade_tween.finished
	emit_signal("fade_finished")
	hide()
