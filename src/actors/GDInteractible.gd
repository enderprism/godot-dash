@tool extends Area2D

class_name GDInteractible

enum Orb {
	ORB_DISABLED = 0,
	ORB_YELLOW = 1,
	ORB_PINK = 2,
	ORB_RED = 4,
	ORB_BLUE = 8,
	ORB_GREEN = 16,
	ORB_BLACK = 32,
	ORB_SPIDER = 64,
	ORB_DASH_GREEN = 128,
	ORB_DASH_MAGENTA = 256,
}

# add an export flag with reverse and spider orb opposite gravity
# with name "Orb Flags"

enum Pad {
	PAD_DISABLED = 0,
	PAD_YELLOW = 1,
	PAD_PINK = 2,
	PAD_RED = 4,
	PAD_BLUE = 8,
	PAD_SPIDER = 16,
}

# GamemodePortal will be written as GMPortal to save time and space.
enum GMPortal {
	GMPORTAL_DISABLED = 0,
	GMPORTAL_CUBE = 1,
	GMPORTAL_SHIP = 2,
	GMPORTAL_UFO = 4,
	GMPORTAL_WAVE = 8,
	GMPORTAL_BALL = 16,
	GMPORTAL_ROBOT = 32,
	GMPORTAL_SPIDER = 64,
	GMPORTAL_SWING = 128,
}

# SpeedPortal will be written as SPPortal to save time and space.
enum SPPortal {
	SPPORTAL_DISABLED = 0,
	SPPORTAL_1X = 1,
	SPPORTAL_2X = 2,
	SPPORTAL_3X = 4,
	SPPORTAL_4X = 8,
	SPPORTAL_05X = 16,
	SPPORTAL_0X = 16,
}

var orb_type_val: Orb
var is_reverse_val = false
var is_spider_orb_opp_gravity_val = false
var is_multi_usage_val = false
var is_freefly_val = false
var has_custom_ground_radius_val = false
var pad_type_val: Pad
var gmportal_type_val: GMPortal
var spportal_type_val: SPPortal
var orb_type_idx: int
var pad_type_idx: int
var gmportal_type_idx: int
var spportal_type_idx: int
var ground_radius: float

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_player_enter"))
	connect("body_exited", Callable(self, "_on_player_exit"))

func _on_player_enter(_body: Node2D):
	var _player
	if CurrentLevel.in_editor:
		_player = get_node("/root/LevelEditor/GameScene/Player")
	else:
		_player = get_node("/root/Scene/Player")
	if orb_type_val != Orb.ORB_DISABLED:
		_player._orb_checker |= orb_type_val
		_player._is_reversed = is_reverse_val
		if orb_type_val == Orb.ORB_SPIDER:
			_player._spider_orb_opposite_gravity = is_spider_orb_opp_gravity_val
			if is_spider_orb_opp_gravity_val: _player.get_node("SpiderSprites/SpiderShapecast").rotation_degrees = 180
		if orb_type_val == Orb.ORB_DASH_GREEN || orb_type_val == Orb.ORB_DASH_MAGENTA:
			_player._dash_orb_rotation = rotation
	elif pad_type_val != Pad.PAD_DISABLED:
		_player._pad_checker |= pad_type_val
		if is_reverse_val:
			_player._x_direction *= -1
	elif gmportal_type_val != GMPortal.GMPORTAL_DISABLED:
		var was_already_cube: bool = _player.gamemode == "cube" && gmportal_type_val == GMPortal.GMPORTAL_CUBE
		if !was_already_cube:
			_player.player_icon.rotation_degrees = 0
		if gmportal_type_val == GMPortal.GMPORTAL_CUBE:
			_player.player_icon.flip_v = false
		if gmportal_type_val == GMPortal.GMPORTAL_CUBE || \
		gmportal_type_val == GMPortal.GMPORTAL_UFO || \
		gmportal_type_val == GMPortal.GMPORTAL_ROBOT || \
		gmportal_type_val == GMPortal.GMPORTAL_SPIDER:
			_player.gravity = _player.shipGravityDirection * _player.UP_DIRECTION.y * -1
		_player.gamemode = _set_gamemode(gmportal_type_val)
		ground_radius = _set_ground_radius(gmportal_type_val)
		get_node("/root/Scene/GroundManager")._freefly_setter(
			is_freefly_val,
			ground_radius,
			global_position.y,
			false,
		)
	elif spportal_type_val != SPPortal.SPPORTAL_DISABLED:
		_player._speed_multiplier = _set_speed(spportal_type_val)

func _set_speed(speed: int) -> float:
	match speed:
		SPPortal.SPPORTAL_1X:
			return 1.0
		SPPortal.SPPORTAL_2X:
			return 1.243
		SPPortal.SPPORTAL_3X:
			return 1.502
		SPPortal.SPPORTAL_4X:
			return 1.849
		SPPortal.SPPORTAL_05X:
			return 0.807
		SPPortal.SPPORTAL_0X:
			return 0.0
	return 1.0

func _set_ground_radius(gamemode: int) -> float:
	if has_custom_ground_radius_val:
		return ground_radius*61
	else:
		match gamemode:
			GMPortal.GMPORTAL_CUBE:
				return 61*5
			GMPortal.GMPORTAL_SHIP:
				return 61*5
			GMPortal.GMPORTAL_UFO:
				return 61*5
			GMPortal.GMPORTAL_WAVE:
				return 61*5
			GMPortal.GMPORTAL_BALL:
				return 61*4
			GMPortal.GMPORTAL_ROBOT:
				return 61*5
			GMPortal.GMPORTAL_SPIDER:
				return 61*4.5
			GMPortal.GMPORTAL_SWING:
				return 61*5
	return 61*5

func _set_gamemode(gamemode: int) -> String:
	match gamemode:
		GMPortal.GMPORTAL_CUBE:
			return "cube"
		GMPortal.GMPORTAL_SHIP:
			return "ship"
		GMPortal.GMPORTAL_UFO:
			return "ufo"
		GMPortal.GMPORTAL_WAVE:
			return "wave"
		GMPortal.GMPORTAL_BALL:
			return "ball"
		GMPortal.GMPORTAL_ROBOT:
			return "robot"
		GMPortal.GMPORTAL_SPIDER:
			return "spider"
		GMPortal.GMPORTAL_SWING:
			return "swingcopter"
	return ""

func _on_player_exit(_body: Node2D):
	var _player
	if CurrentLevel.in_editor:
		_player = get_node("/root/LevelEditor/GameScene/Player")
	else:
		_player = get_node("/root/Scene/Player")
	if orb_type_val != Orb.ORB_DISABLED:
		_player._orb_checker &= ~orb_type_val
		if orb_type_val == Orb.ORB_SPIDER:
			_player._spider_orb_opposite_gravity = false
			_player.get_node("SpiderSprites/SpiderShapecast").rotation_degrees = 0
	elif pad_type_val != Pad.PAD_DISABLED:
		_player._pad_checker &= ~pad_type_val
	if !is_multi_usage_val:
		set_deferred("process_mode", PROCESS_MODE_DISABLED)

########################
# FANCY INSPECTOR CODE #
########################

func _set(property: StringName, value: Variant) -> bool:
	notify_property_list_changed()
	if property == "Orb Type":
		orb_type_idx = value
		orb_type_val = Orb[Orb.keys()[value]]
		if orb_type_val != 0:
			is_multiusage_usage = PROPERTY_USAGE_DEFAULT
			is_reverse_usage = PROPERTY_USAGE_DEFAULT
			pad_usage = PROPERTY_USAGE_NO_EDITOR
			gmportal_usage = PROPERTY_USAGE_NO_EDITOR
			spportal_usage = PROPERTY_USAGE_NO_EDITOR
		else:
			is_reverse_usage = PROPERTY_USAGE_NO_EDITOR
			is_multiusage_usage = PROPERTY_USAGE_NO_EDITOR
		if orb_type_val == Orb.ORB_SPIDER:
			is_spider_orb_opp_gravity_usage = PROPERTY_USAGE_DEFAULT
		else:
			is_spider_orb_opp_gravity_usage = PROPERTY_USAGE_NO_EDITOR
	elif property == "Is Reverse?":
		is_reverse_val = value
	elif property == "Is Opposite Gravity?":
		is_spider_orb_opp_gravity_val = value
	elif property == "Is Freefly?":
		is_freefly_val = value
	elif property == "Is Multi Usage?":
		is_multi_usage_val = value
	elif property == "Has Custom Ground Radius?":
		has_custom_ground_radius_val = value
		if has_custom_ground_radius_val:
			custom_ground_radius_usage = PROPERTY_USAGE_DEFAULT
		else:
			custom_ground_radius_usage = PROPERTY_USAGE_NO_EDITOR
	elif property == "Custom Ground Radius":
		ground_radius = value
	elif property == "Pad Type":
		pad_type_idx = value
		pad_type_val = Pad[Pad.keys()[value]]
		if pad_type_val != 0:
			is_multiusage_usage = PROPERTY_USAGE_DEFAULT
			is_reverse_usage = PROPERTY_USAGE_DEFAULT
			orb_usage = PROPERTY_USAGE_NO_EDITOR
			gmportal_usage = PROPERTY_USAGE_NO_EDITOR
			spportal_usage = PROPERTY_USAGE_NO_EDITOR
		else:
			is_multiusage_usage = PROPERTY_USAGE_NO_EDITOR
			is_reverse_usage = PROPERTY_USAGE_NO_EDITOR
	elif property == "Gamemode Portal Type":
		gmportal_type_idx = value
		gmportal_type_val = GMPortal[GMPortal.keys()[value]]
		if gmportal_type_val != 0:
			is_freefly_usage = PROPERTY_USAGE_DEFAULT
			has_custom_ground_radius_usage = PROPERTY_USAGE_DEFAULT
			custom_ground_radius_usage = PROPERTY_USAGE_READ_ONLY
			orb_usage = PROPERTY_USAGE_NO_EDITOR
			pad_usage = PROPERTY_USAGE_NO_EDITOR
			spportal_usage = PROPERTY_USAGE_NO_EDITOR
		else:
			is_freefly_usage = PROPERTY_USAGE_NO_EDITOR
			custom_ground_radius_usage = PROPERTY_USAGE_NO_EDITOR
			has_custom_ground_radius_usage = PROPERTY_USAGE_NO_EDITOR
	elif property == "Speed Portal Type":
		spportal_type_idx = value
		spportal_type_val = SPPortal[SPPortal.keys()[value]]
		if spportal_type_val != 0:
			orb_usage = PROPERTY_USAGE_NO_EDITOR
			pad_usage = PROPERTY_USAGE_NO_EDITOR
			gmportal_usage = PROPERTY_USAGE_NO_EDITOR
	else: return false
	
	if orb_type_val == Orb.ORB_DISABLED && pad_type_val == Pad.PAD_DISABLED && gmportal_type_val == GMPortal.GMPORTAL_DISABLED && spportal_type_val == SPPortal.SPPORTAL_DISABLED:
		orb_usage = PROPERTY_USAGE_DEFAULT
		pad_usage = PROPERTY_USAGE_DEFAULT
		gmportal_usage = PROPERTY_USAGE_DEFAULT
		spportal_usage = PROPERTY_USAGE_DEFAULT
	return true

func _get(property: StringName):
	if property == "Orb Type":
		return orb_type_idx
	elif property == "Is Reverse?":
		return is_reverse_val
	elif property == "Is Opposite Gravity?":
		return is_spider_orb_opp_gravity_val
	elif property == "Is Multi Usage?":
		return is_multi_usage_val
	elif property == "Is Freefly?":
		return is_freefly_val
	elif property == "Has Custom Ground Radius?":
		return has_custom_ground_radius_val
	elif property == "Custom Ground Radius":
		return ground_radius
	elif property == "Pad Type":
		return pad_type_idx
	elif property == "Gamemode Portal Type":
		return gmportal_type_idx
	elif property == "Speed Portal Type":
		return spportal_type_idx
	return null

var orb_usage = PROPERTY_USAGE_DEFAULT
var is_reverse_usage = PROPERTY_USAGE_NO_EDITOR
var is_spider_orb_opp_gravity_usage = PROPERTY_USAGE_NO_EDITOR
var is_multiusage_usage = PROPERTY_USAGE_NO_EDITOR
var is_freefly_usage = PROPERTY_USAGE_NO_EDITOR
var has_custom_ground_radius_usage = PROPERTY_USAGE_NO_EDITOR
var custom_ground_radius_usage = PROPERTY_USAGE_NO_EDITOR
var pad_usage = PROPERTY_USAGE_DEFAULT
var gmportal_usage = PROPERTY_USAGE_DEFAULT
var spportal_usage = PROPERTY_USAGE_DEFAULT

func _get_property_list():
	var properties = []
	
	properties.append({
		"name": "Orb Type",
		"type": TYPE_INT,
		"usage": orb_usage, # See above assignment.
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "ORB_DISABLED,ORB_YELLOW,ORB_PINK,ORB_RED,ORB_BLUE,ORB_GREEN,ORB_BLACK,ORB_SPIDER,ORB_DASH_GREEN,ORB_DASH_MAGENTA",
	})
	
	properties.append({
		"name": "Pad Type",
		"type": TYPE_INT,
		"usage": pad_usage, # See above assignment.
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "PAD_DISABLED,PAD_YELLOW,PAD_PINK,PAD_RED,PAD_BLUE,PAD_SPIDER",
	})
	
	properties.append({
		"name": "Gamemode Portal Type",
		"type": TYPE_INT,
		"usage": gmportal_usage, # See above assignment.
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "GMPORTAL_DISABLED,GMPORTAL_CUBE,GMPORTAL_SHIP,GMPORTAL_UFO,GMPORTAL_WAVE,GMPORTAL_BALL,GMPORTAL_ROBOT,GMPORTAL_SPIDER,GMPORTAL_SWING",
	})
	
	properties.append({
		"name": "Speed Portal Type",
		"type": TYPE_INT,
		"usage": spportal_usage, # See above assignment.
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "SPPORTAL_DISABLED,SPPORTAL_1X,SPPORTAL_2X,SPPORTAL_3X,SPPORTAL_4X,SPPORTAL_05X,SPPORTAL_0X",
	})

	properties.append({
		"name": "Is Multi Usage?",
		"type": TYPE_BOOL,
		"usage": is_multiusage_usage, # See above assignment.
	})

	properties.append({
		"name": "Is Reverse?",
		"type": TYPE_BOOL,
		"usage": is_reverse_usage, # See above assignment.
	})
	
	properties.append({
		"name": "Is Opposite Gravity?",
		"type": TYPE_BOOL,
		"usage": is_spider_orb_opp_gravity_usage, # See above assignment.
	})
	
	properties.append({
		"name": "Is Freefly?",
		"type": TYPE_BOOL,
		"usage": is_freefly_usage, # See above assignment.
	})
	
	properties.append({
		"name": "Has Custom Ground Radius?",
		"type": TYPE_BOOL,
		"usage": has_custom_ground_radius_usage, # See above assignment.
		
	})
	
	properties.append({
		"name": "Custom Ground Radius",
		"type": TYPE_FLOAT,
		"usage": custom_ground_radius_usage, # See above assignment.
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "2,12,0.001",
	})

	return properties
