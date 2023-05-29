extends Node

var end_time: float

func set_end_time(time: float):
	end_time = time

var calculated_percentage: float
var rounded_percentage: float
func _physics_process(delta: float) -> void:
	if has_node("/root/Scene"):
		var _current_level = get_node("/root/Scene/Levels").get_child(0)
		if _current_level.time_based_percentage && end_time > 0.0:
			calculated_percentage = (CurrentLevel.level_time*100) / end_time
			rounded_percentage = snapped(calculated_percentage, 1.0)
			if !get_node("/root/Scene/Player")._is_dead:
				if rounded_percentage >= 100.00:
					get_node("/root/Scene/GUI/Percentage").text = "100%"
				else:
					get_node("/root/Scene/GUI/Percentage").text = str(rounded_percentage) + "%"
		elif _current_level.has_node("LevelEnd/EndEdge"):
			var _player_pos = get_node("/root/Scene/Player").global_position.x
			var _level_end = _current_level.get_node("LevelEnd/EndEdge").global_position.x
			calculated_percentage = (_player_pos*100)/_level_end
			rounded_percentage = snapped(calculated_percentage, 1.0)
			if !get_node("/root/Scene/Player")._is_dead:
				if rounded_percentage >= 100.00:
					get_node("/root/Scene/GUI/Percentage").text = "100%"
				else:
					get_node("/root/Scene/GUI/Percentage").text = str(rounded_percentage) + "%"
		else:
			get_node("/root/Scene/GUI/Percentage").text = "Infinite"
	else:
		end_time = 0.0
