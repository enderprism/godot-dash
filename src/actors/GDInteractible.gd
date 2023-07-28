@tool

extends Area2D

class_name GDInteractible

## ALL THIS CODE FOR A MENU AUGH
## AND I STILL NEED TO DO THE ACTUAL CODE, I'M ONLY HALF WAY THERE

enum Orb {
	ORB_DISABLED = 0,
	ORB_YELLOW = 1,
	ORB_PINK = 2,
	ORB_RED = 4,
	ORB_BLUE = 8,
	ORB_BLACK = 16,
	ORB_SPIDER = 32,
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
	SPPORTAL_0X = 16,
}

var orb_type_val: Orb
var is_reverse_val = false
var is_spider_orb_opp_gravity_val = false
var pad_type_val: Pad
var gmportal_type_val: GMPortal
var spportal_type_val: SPPortal
var orb_type_idx: int
var pad_type_idx: int
var gmportal_type_idx: int
var spportal_type_idx: int


########################
# FANCY INSPECTOR CODE #
########################

func _set(property: StringName, value: Variant) -> bool:
	notify_property_list_changed()
	if property == "Orb Type":
		orb_type_idx = value
		orb_type_val = Orb[Orb.keys()[value]]
		if orb_type_val != 0:
			is_reverse_usage = PROPERTY_USAGE_DEFAULT
			pad_usage = PROPERTY_USAGE_NO_EDITOR
			gmportal_usage = PROPERTY_USAGE_NO_EDITOR
			spportal_usage = PROPERTY_USAGE_NO_EDITOR
		else:
			is_reverse_usage = PROPERTY_USAGE_NO_EDITOR
		if orb_type_val == Orb.ORB_SPIDER:
			is_spider_orb_opp_gravity_usage = PROPERTY_USAGE_DEFAULT
		else:
			is_spider_orb_opp_gravity_usage = PROPERTY_USAGE_NO_EDITOR
	if property == "Is Reverse?":
		is_reverse_val = value
	if property == "Is Opposite Gravity?":
		is_spider_orb_opp_gravity_val = value
	if property == "Pad Type":
		pad_type_idx = value
		pad_type_val = Pad[Pad.keys()[value]]
		if pad_type_val != 0:
			is_reverse_usage = PROPERTY_USAGE_DEFAULT
			orb_usage = PROPERTY_USAGE_NO_EDITOR
			gmportal_usage = PROPERTY_USAGE_NO_EDITOR
			spportal_usage = PROPERTY_USAGE_NO_EDITOR
		else:
			is_reverse_usage = PROPERTY_USAGE_NO_EDITOR
	if property == "Gamemode Portal Type":
		gmportal_type_idx = value
		print(GMPortal[GMPortal.keys()[value]])
		gmportal_type_val = GMPortal[GMPortal.keys()[value]]
		if gmportal_type_val != 0:
			orb_usage = PROPERTY_USAGE_NO_EDITOR
			pad_usage = PROPERTY_USAGE_NO_EDITOR
			spportal_usage = PROPERTY_USAGE_NO_EDITOR
	if property == "Speed Portal Type":
		spportal_type_idx = value
		spportal_type_val = SPPortal[SPPortal.keys()[value]]
		if spportal_type_val != 0:
			orb_usage = PROPERTY_USAGE_NO_EDITOR
			pad_usage = PROPERTY_USAGE_NO_EDITOR
			gmportal_usage = PROPERTY_USAGE_NO_EDITOR
	if orb_type_val == Orb.ORB_DISABLED && pad_type_val == Pad.PAD_DISABLED && gmportal_type_val == GMPortal.GMPORTAL_DISABLED && spportal_type_val == SPPortal.SPPORTAL_DISABLED:
		orb_usage = PROPERTY_USAGE_DEFAULT
		pad_usage = PROPERTY_USAGE_DEFAULT
		gmportal_usage = PROPERTY_USAGE_DEFAULT
		spportal_usage = PROPERTY_USAGE_DEFAULT
#	print(orb_type_val, ", ", orb_flags_val, ", ", pad_type_val, ", ", gmportal_type_val, ", ", spportal_type_val)
	return true

func _get(property: StringName):
	if property == "Orb Type":
		return orb_type_idx
	if property == "Is Reverse?":
		return is_reverse_val
	if property == "Is Opposite Gravity?":
		return is_spider_orb_opp_gravity_val
	if property == "Pad Type":
		return pad_type_idx
	if property == "Gamemode Portal Type":
		return gmportal_type_idx
	if property == "Speed Portal Type":
		return spportal_type_idx
	return null

var orb_usage = PROPERTY_USAGE_DEFAULT
var is_reverse_usage = PROPERTY_USAGE_NO_EDITOR
var is_spider_orb_opp_gravity_usage = PROPERTY_USAGE_NO_EDITOR
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
		"hint_string": "ORB_DISABLED,ORB_YELLOW,ORB_PINK,ORB_RED,ORB_BLUE,ORB_BLACK,ORB_SPIDER",
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
		"hint_string": "SPPORTAL_DISABLED,SPPORTAL_1X,SPPORTAL_2X,SPPORTAL_3X,SPPORTAL_4X,SPPORTAL_0X",
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

	return properties
