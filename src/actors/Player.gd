extends Actor

@export_range (0.01, 4.00, 0.01) var time_scale: float = 1.00
@export var gamemode: String = "cube"
var is_platformer: bool
@export var mini: bool = false
signal spider_jumped(distance)
signal started_dashing
signal dead

@onready var player_icon: = $Icon
@onready var player_camera = get_node("/root/Scene/PlayerCamera")

var _debug_time: = 0.0
var _is_small_hitbox_colliding: = false
var _is_hazard_colliding: = false
var _is_dead: = false
var direction
var _is_reversed: bool = false
var _camera_edge_speed: = 500
var _is_dashing = false
var gravityBackup = gravity
var shipGravityDirection = gravity
var trail_delta = 0.0
var _speed_multiplier: float = 1.0
var _spider_state_machine
var spider_dash_pos: Vector2
var snap_vector: Vector2
var _in_jblock: bool = false
var arrow_trigger_direction: Vector2 = UP_DIRECTION
var is_static: bool = false
var level_ended: bool = false

# Gameplay elements collisions
# Pads
var _pad_checker: int

# Orbs
var _has_let_go_of_orb: bool = false
var _orb_jumped: bool = false
var _orb_checker: int
var _is_toggle_orb_colliding: bool = false
var _dash_orb_rotation = 0.0
var _dash_orb_y_offset = 0.0
var _spider_orb_opposite_gravity: bool = false
var _is_green_orb_jumping: bool = false

# Portals
var _is_yellow_gravity_portal_colliding: bool = false
var _is_blue_gravity_portal_colliding: bool = false

var _robot_timer: float
var _jump_direction = 0.0
var _x_direction = 1
var _icon_direction = 1
var _press_or_hold: bool = false
var _holdable_gamemode: = false
var _can_fly = false
var floor_angle: float = get_floor_angle()
var _is_player_onground: bool # doesn't depend on gameplay direction


func _ready() -> void:
	player_camera.limit_right = 10000000

	if is_platformer:
		player_camera.offset.x = 0
		player_camera.drag_horizontal_enabled = false
		player_camera.drag_vertical_enabled = false
		player_camera.position_smoothing_enabled = true
	velocity = Vector2.ZERO
	direction = Vector2.ZERO
	_is_hazard_colliding = false
	UP_DIRECTION.y = -1.0
	stopDashing()
	_is_dead = false
	_spider_state_machine = $SpiderSprites/AnimationTree.get("parameters/playback")

func _physics_process(delta: float) -> void:
#	snap_vector = Vector2(UP_DIRECTION.x, UP_DIRECTION.y * -1)

	if arrow_trigger_direction == Vector2(0.0, -1.0):
		_is_player_onground = is_on_floor()
	elif arrow_trigger_direction == Vector2(-1.0, 0.0):
		_is_player_onground = is_on_wall()

	if Input.is_action_just_pressed("jump") && _in_jblock:
		_in_jblock = false
	
	if _orb_jumped && Input.is_action_just_released("jump") && !(is_on_floor() && is_on_ceiling() && is_on_wall()):
		_has_let_go_of_orb = true
		_orb_jumped = false

	smooth_rot_speed = 1000*delta
#	if is_platformer:
#		player_camera.offset.x = 0
#		player_camera.drag_horizontal_enabled = false
#		player_camera.drag_vertical_enabled = false
#		player_camera.position_smoothing_enabled = true
#	else:
#		player_camera.position_smoothing_enabled = false

	global_rotation_degrees = 0.0

	if gamemode == "ball" || gamemode == "spider":
		_press_or_hold = Input.is_action_just_pressed("jump")
		_holdable_gamemode = false
		_can_fly = is_on_floor() || is_on_wall() || is_on_ceiling()
	elif gamemode == "wave":
		_press_or_hold = Input.is_action_pressed("jump")
		_can_fly = true
		_holdable_gamemode = true
	elif gamemode == "ufo":
		_press_or_hold = Input.is_action_just_pressed("jump")
		_can_fly = true
		_holdable_gamemode = true
	elif gamemode == "robot":
		_press_or_hold = Input.is_action_pressed("jump")
		_can_fly = true
		_holdable_gamemode = false
	else: # cube
		_press_or_hold = Input.is_action_pressed("jump")
		_holdable_gamemode = true
		_can_fly = _is_player_onground
	var is_jump_interrupted: bool = Input.is_action_just_released("jump") and velocity.y < 0.0
	
	direction = get_direction(_press_or_hold)

	if Input.is_action_pressed("jump") && _orb_checker & GDInteractible.Orb.ORB_GREEN && _has_let_go_of_orb:
		_is_green_orb_jumping = true

	if gamemode == "spider":
		_spider_manage_states()

	# Ship script (after a snippet from this tutorial: https://www.youtube.com/watch?v=-3HhmDGu_Ak&t=96s)
	if gamemode == "ship":
		if Input.is_action_just_pressed("jump"):
			gravity = -shipGravityDirection * UP_DIRECTION.y * -1
		elif Input.is_action_just_released("jump"):
			gravity = shipGravityDirection * UP_DIRECTION.y * -1

	if mini:
		scale = Vector2(0.3, 0.3)
		if gamemode == "wave":
			$Icon.scale = Vector2(1.25, 1.25)
		speed.y = 1100 * 0.75

	else:
		scale = Vector2(0.5, 0.5)
		if gamemode == "wave":
			$Icon.scale = Vector2(1.0, 1.0)
		speed.y = 1100.0

	floor_angle = get_floor_angle()
	var slope_object: Object

	if "Slope" in str($AreaDetection.get_overlapping_bodies()):
		for object in $AreaDetection.get_overlapping_bodies():
			if "Slope" in str(object):
				slope_object = object
				break
		if (slope_object.scale.x >= 1 && UP_DIRECTION.y < 0) || (slope_object.scale.x <= -1 && UP_DIRECTION.y > 0):
			floor_angle = abs(get_floor_angle()) * -1

	if Input.is_action_just_pressed("jump") && !_is_dead && gamemode == "spider" && _is_player_onground && _orb_checker == 0:
		do_spider_jump()

	if _pad_checker & GDInteractible.Pad.PAD_SPIDER && !_is_dead:
		do_spider_jump()
		velocity.y = 0
		_jump_direction = UP_DIRECTION.y * -1
		_pad_checker &= ~GDInteractible.Pad.PAD_SPIDER

	if Input.is_action_pressed("jump") && _orb_checker & GDInteractible.Orb.ORB_SPIDER && _has_let_go_of_orb && !_is_dead:
		do_spider_jump()
		_orb_jumped = true
	

	
	if Input.is_action_just_pressed("jump") && gamemode == "robot" && _is_player_onground:
		_robot_timer = 0.25 / delta
	if _robot_timer > 0:
		_robot_timer -= 1
	
#	if !is_static && !is_platformer:
#		# Reset the camera offset if in Arrow Trigger
#		if arrow_trigger_direction == Vector2(-1.0, 0.0) && !$AnimationPlayer.is_playing() && player_camera.offset.x != 0.0:
#			if player_camera.offset.x == -200:
#				$AnimationPlayer.play("Camera3D go to center from left edge")
#			elif player_camera.offset.x == 200:
#				$AnimationPlayer.play("Camera3D go to center from right edge")
#		# Put the camera back in place when getting out of Arrow Trigger
#		if arrow_trigger_direction == Vector2(0.0, -1.0) && !$AnimationPlayer.is_playing() && player_camera.offset.x == 0.0:
#			if _x_direction == 1.0:
#				$AnimationPlayer.play("Camera3D go from center to left edge")
#			elif _x_direction == -1.0:
#				$AnimationPlayer.play("Camera3D go from center to right edge")
	
	
	if _is_reversed == true && (Input.is_action_just_pressed("jump") && _orb_checker != 0):
		_x_direction *= -1
	if (Input.is_action_just_pressed("jump") && (_orb_checker & GDInteractible.Orb.ORB_BLUE || \
		_orb_checker & GDInteractible.Orb.ORB_GREEN || _orb_checker & GDInteractible.Orb.ORB_DASH_MAGENTA)) or \
		_pad_checker & GDInteractible.Pad.PAD_BLUE or (Input.is_action_just_pressed("jump") && \
		(((is_on_floor() || is_on_ceiling()) && gamemode == "ball") || \
		(gamemode == "swingcopter" && _orb_checker == 0))):
		if (Input.is_action_just_pressed("jump") \
			&& (is_on_floor() || is_on_ceiling()) && gamemode == "ball"):
			velocity.y *= -1
		_pad_checker &= ~GDInteractible.Pad.PAD_BLUE # reverts blue pad/orb
		_orb_checker &= ~GDInteractible.Orb.ORB_BLUE
		_orb_checker &= ~GDInteractible.Orb.ORB_GREEN
		$SpiderSprites.scale.y *= -1
		gravity *= -1
		if gamemode != "swingcopter":
			UP_DIRECTION.y *= -1
	if (Input.is_action_just_pressed("jump") && (_orb_checker & GDInteractible.Orb.ORB_DASH_GREEN || _orb_checker & GDInteractible.Orb.ORB_DASH_MAGENTA)):
		_is_dashing = true
		_orb_checker & GDInteractible.Orb.ORB_DASH_GREEN
		emit_signal("started_dashing")
		$DashFire.show()
		gravityBackup = gravity
		if arrow_trigger_direction == Vector2(0.0, -1.0):
			_dash_orb_y_offset = sqrt(pow(speed.x * _speed_multiplier, 2) + pow(speed.y * gravityMod, 2)) * sin(_dash_orb_rotation)
		elif arrow_trigger_direction == Vector2(-1.0, 0.0):
			_dash_orb_y_offset = sqrt(pow(speed.x * _speed_multiplier, 2) + pow(speed.y * gravityMod, 2)) * sin(_dash_orb_rotation - PI/2)
		gravity = 0
	if (Input.is_action_pressed("jump") && _is_dashing):
		velocity.y = 0
	if _is_dashing && Input.is_action_just_released("jump"):
		stopDashing()
	velocity = calculate_move_velocity(velocity, direction, speed, _holdable_gamemode, gamemode, _is_dashing, is_jump_interrupted, _dash_orb_y_offset)
	
	# Sprite Rotation
	if gamemode == "cube":
		if !is_on_floor() && !is_on_ceiling() && !is_on_wall():
			rotate_sprite(delta, direction)
		else:
			if "Slope" in str($AreaDetection.get_overlapping_bodies()): player_icon.rotation = floor_angle
			elif player_icon.rotation_degrees != round(round(player_icon.rotation_degrees / 90.0) * 90.0):
				player_icon.rotation_degrees = move_toward(player_icon.rotation_degrees, round(round(player_icon.rotation_degrees / 90.0) * 90.0), smooth_rot_speed)
	else:
		if gamemode == "ball":
			rotate_sprite(delta, direction)
		else:
			rotate_sprite(0.016667, direction)
		if !(gamemode == "ball" || gamemode == "swingcopter"):
#			$SpiderSprites.scale.y = 2 if UP_DIRECTION.y < 0 else -2
			player_icon.flip_v = false if UP_DIRECTION.y < 0 else true
	
	if _spider_immunity_timer > 0:
		_spider_immunity_timer -= 1
	if _spider_immunity_timer != 0:
		_is_small_hitbox_colliding = false
		_is_hazard_colliding = false
	
	if (_is_small_hitbox_colliding || (_is_hazard_colliding && _spider_immunity_timer == 0)) && !_is_dead:
		$AnimationPlayer.current_animation = "DeathAnimation"

	if !level_ended:
		changeSpriteOnGamemode()
		set_velocity(velocity)
		set_floor_constant_speed_enabled(true)
		set_up_direction(UP_DIRECTION)
		move_and_slide()
	else:
		$PlayerGroundParticles.hide()
		$DashFire.hide()
	
func get_direction(_press_or_hold: bool) -> Vector2:
	# _press_or_hold detects clicking depending of the gamemode (or holding for the wave, the ship, and the robot)
	# _can_fly is true for flying gamemodes and is equal to is_on_ground for other gamemodes
	# for the cube, this means (Input.is_action_pressed("jump") || is_on_ground())
	if !(is_platformer && gamemode == "wave"):
		if (_press_or_hold and _can_fly) || \
		(Input.is_action_pressed("jump") && _has_let_go_of_orb && _orb_checker != 0):
			_jump_direction = UP_DIRECTION.y
			_orb_jumped = true
			_has_let_go_of_orb = false
		elif _pad_checker != 0: #and is_on_floor()
			_jump_direction = UP_DIRECTION.y
		elif Input.is_action_pressed("jump") && _orb_checker & GDInteractible.Orb.ORB_GREEN && _has_let_go_of_orb:
			_jump_direction = -UP_DIRECTION.y
		elif Input.is_action_pressed("jump") && _has_let_go_of_orb && _orb_checker & GDInteractible.Orb.ORB_SPIDER:
			_jump_direction = UP_DIRECTION.y * -1
		else:
			_jump_direction = UP_DIRECTION.y * -1 # contains black orb
	
	if is_platformer:
		_x_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left") if _speed_multiplier != 0.0 else 0.0
		if Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
			_icon_direction = _x_direction
		if gamemode == "wave" && Input.is_action_pressed("jump"):
			_jump_direction = UP_DIRECTION.y
		elif gamemode == "wave" && Input.is_action_pressed("wave_platformer_move_down"):
			_jump_direction = -UP_DIRECTION.y
		elif gamemode == "wave" && (!Input.is_action_pressed("jump") || !Input.is_action_pressed("wave_platformer_move_down")):
			_jump_direction = 0.0
	else:
		_icon_direction = _x_direction
	return Vector2(
		# Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		_x_direction if !_is_dead else 0.0, # player stops moving on the x axis (forwards and backwards) when it dies
		_jump_direction if !_is_dead else 0.0
	)

var gravityMod = 1

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		holdable_gamemode: bool,
		gamemode: String,
		is_wave_dashing: bool,
		is_jump_interrupted: bool,
		dash_offset: float
	) -> Vector2:
	var out: = linear_velocity
	var _out_horizontal: float
	var _out_vertical: float
	
	if arrow_trigger_direction == Vector2(0.0, -1.0):
		_out_vertical = linear_velocity.y
	elif arrow_trigger_direction == Vector2(-1.0, 0.0):
		_out_vertical = linear_velocity.x

	_out_horizontal = speed.x * direction.x * _speed_multiplier
	if _is_dashing:
		gravityMod = 0
		if _x_direction > 0:
			_out_vertical += dash_offset + (gravity * get_physics_process_delta_time()) * gravityMod
		elif _x_direction < 0:
			_out_vertical -= dash_offset + (gravity * get_physics_process_delta_time()) * gravityMod
	elif gamemode == "ship" || gamemode == "ufo" || gamemode == "swingcopter":
		max_speed.y = -800.0
		gravityMod = 0.6
		_out_vertical += (gravity * get_physics_process_delta_time()) * gravityMod + dash_offset
	elif gamemode == "wave":
		max_speed.y = -1500.0
		gravityMod = 0 # stops normal gravity so custom one can be used
	else:
		max_speed.y = -1500.0
		gravityMod = 1
		_out_vertical += gravity * get_physics_process_delta_time() + dash_offset
	if direction.y == UP_DIRECTION.y:
		if _pad_checker & GDInteractible.Pad.PAD_PINK || _orb_checker & GDInteractible.Orb.ORB_PINK:
			_out_vertical = speed.y * direction.y * 0.8 * gravityMod
			_pad_checker &= ~GDInteractible.Pad.PAD_PINK # reverts pink pad/orb
			_orb_checker &= ~GDInteractible.Orb.ORB_PINK
		elif _pad_checker & GDInteractible.Pad.PAD_RED || _orb_checker & GDInteractible.Orb.ORB_RED:
			_out_vertical = speed.y * direction.y * 2.25 * gravityMod
			_pad_checker &= ~GDInteractible.Pad.PAD_RED # reverts red pad/orb
			_orb_checker &= ~GDInteractible.Orb.ORB_RED
		elif _orb_checker & GDInteractible.Orb.ORB_GREEN:
			_out_vertical = speed.y * direction.y * gravityMod
			_orb_checker &= ~GDInteractible.Orb.ORB_GREEN # reverts red pad/orb
		elif _pad_checker & GDInteractible.Pad.PAD_YELLOW:
			_out_vertical = speed.y * direction.y * gravityMod * 1.35
			_pad_checker &= ~GDInteractible.Pad.PAD_YELLOW # reverts yellow pad
		elif _orb_checker & GDInteractible.Orb.ORB_YELLOW:
			_out_vertical = speed.y * direction.y * gravityMod * 1.1
			_orb_checker &= ~GDInteractible.Orb.ORB_YELLOW # reverts yellow orb
		elif _is_toggle_orb_colliding:
			_out_vertical = 0.0
		elif _orb_checker & GDInteractible.Orb.ORB_BLACK:
			_out_vertical = speed.y * UP_DIRECTION.y * -1.25
		elif gamemode == "ship" || gamemode == "swingcopter":
			_out_vertical = speed.y * direction.y * 0.05 * gravityMod
		elif gamemode == "robot":
			if _robot_timer > 0:
				_out_vertical = sqrt(pow(625*_speed_multiplier, 2) + pow(1100*_speed_multiplier, 2)) * sin(PI/6) * UP_DIRECTION.y
		else:
			if gamemode == "wave":
				if !is_wave_dashing:
					_out_vertical = sqrt(pow(625*_speed_multiplier, 2) + pow(1100*_speed_multiplier, 2)) * sin(PI/6) * UP_DIRECTION.y if !mini else sqrt(pow(625*_speed_multiplier, 2) + pow(1100*_speed_multiplier, 2)) * sin(PI/4+PI/8) * UP_DIRECTION.y
				else: _out_vertical = 0.0
			elif (!gamemode == "spider" || !_pad_checker & GDInteractible.Pad.PAD_SPIDER) && !_in_jblock: # CUBE
				_out_vertical = speed.y * direction.y * gravityMod
	if direction.y == -UP_DIRECTION.y && _is_player_onground && !_is_dashing:
		_out_vertical = 0.0
	if direction.y == UP_DIRECTION.y * -1 && gamemode == "wave":
		_out_vertical = sqrt(pow(625*_speed_multiplier, 2) + pow(1100*_speed_multiplier, 2)) * sin(PI/6) * UP_DIRECTION.y * -1 if !mini else sqrt(pow(625*_speed_multiplier, 2) + pow(1100*_speed_multiplier, 2)) * sin(PI/4+PI/8) * UP_DIRECTION.y * -1
	if direction.y == 0.0 && gamemode == "wave" && is_platformer:
		_out_vertical = 0.0
	if Input.is_action_pressed("jump") && _has_let_go_of_orb && (_orb_checker & GDInteractible.Orb.ORB_BLUE || _pad_checker & GDInteractible.Pad.PAD_BLUE):
		_out_vertical = speed.y * UP_DIRECTION.y * 1.25
	_out_vertical = clampf(_out_vertical, max_speed.y, -max_speed.y)

	if arrow_trigger_direction == Vector2(0.0, -1.0):
		$SpiderSprites.rotation_degrees = 0.0
		out.x = _out_horizontal
		out.y = _out_vertical
	elif arrow_trigger_direction == Vector2(-1.0, 0.0):
		out.y = -_out_horizontal
		out.x = _out_vertical
		$SpiderSprites.rotation_degrees = -90.0
	return out

var arrow_trigger_sprite_rotation_offset = 0
var sprite_rotation_used_axis: float
var vel_horizontal_axis: float
var _wave_size_angle: float = 45.0
var _wave_target_angle: float
var smooth_rot_speed: float = 1000*0.016667

func rotate_sprite(delta, direction):
	if arrow_trigger_direction == Vector2(0.0, -1.0):
		sprite_rotation_used_axis = velocity.y
		vel_horizontal_axis = velocity.x
		arrow_trigger_sprite_rotation_offset = 0
	elif arrow_trigger_direction == Vector2(-1.0, 0.0):
		sprite_rotation_used_axis = velocity.x
		vel_horizontal_axis = velocity.y
		arrow_trigger_sprite_rotation_offset = -90
	
	if _is_dashing:
		$DashFire.rotation = _dash_orb_rotation
		$PlayerDashParticles.rotation = _dash_orb_rotation
		$DashFire.flip_h = $Icon.flip_h
		$DashFire.offset.x = -90 * _icon_direction
		$DashFire.play("default")
	
	if gamemode == "cube" || gamemode == "ball":
		if !_is_dashing:
			player_icon.rotation_degrees += delta * 400 * direction.x * -UP_DIRECTION.y# UP
		else:
			player_icon.rotation_degrees += delta * 400 * direction.x * 2
	if gamemode == "ship" || gamemode == "swingcopter":
		if !_is_dashing:
			# player_icon.rotation_degrees += delta * 200 * direction.x * sign(gravity) # UP
			if (gamemode == "ship" || gamemode == "swingcopter") && !is_platformer:
				player_icon.rotation_degrees = move_toward(player_icon.rotation_degrees, (sprite_rotation_used_axis * delta * 4 * _icon_direction) + arrow_trigger_sprite_rotation_offset, smooth_rot_speed/6)
#				player_icon.rotation_degrees = (sprite_rotation_used_axis * delta * 2 * _icon_direction) + arrow_trigger_sprite_rotation_offset
			elif is_platformer && gamemode == "swingcopter":
				player_icon.rotation_degrees = move_toward(player_icon.rotation_degrees, (sprite_rotation_used_axis * delta * 2 * _icon_direction) + arrow_trigger_sprite_rotation_offset, smooth_rot_speed)
#				player_icon.rotation_degrees = (sprite_rotation_used_axis * delta * 2 * _icon_direction) + arrow_trigger_sprite_rotation_offset
			elif is_platformer && gamemode == "ship":
				if arrow_trigger_direction == Vector2(0.0, -1.0):
					player_icon.rotation_degrees = move_toward(player_icon.rotation_degrees, 0.0, smooth_rot_speed)
#					player_icon.rotation_degrees = 0.0
				else:
					if player_icon.rotation_degrees != -90.0: player_icon.rotation_degrees = move_toward(player_icon.rotation_degrees, -90.0, smooth_rot_speed)
#			if !is_platformer:
#				player_icon.rotation_degrees = clamp(player_icon.rotation_degrees, -45.0 + arrow_trigger_sprite_rotation_offset, 45.0 + arrow_trigger_sprite_rotation_offset)
#			else:
#				player_icon.rotation_degrees = clamp(player_icon.rotation_degrees, -90.0 + arrow_trigger_sprite_rotation_offset, 90.0 + arrow_trigger_sprite_rotation_offset)
			if is_on_floor() || is_on_ceiling() || is_on_wall():
				if "Slope" in str($AreaDetection.get_overlapping_bodies()):
					if UP_DIRECTION.y < 0: player_icon.rotation = move_toward(player_icon.rotation, floor_angle, smooth_rot_speed)
					elif player_icon.rotation != floor_angle - 2*PI: player_icon.rotation = move_toward(player_icon.rotation, floor_angle - 2*PI, smooth_rot_speed)
				elif player_icon.rotation_degrees != arrow_trigger_sprite_rotation_offset: player_icon.rotation_degrees = move_toward(player_icon.rotation, arrow_trigger_sprite_rotation_offset, smooth_rot_speed)
		elif player_icon.rotation != _dash_orb_rotation:
			player_icon.rotation = move_toward(player_icon.rotation, _dash_orb_rotation, smooth_rot_speed)

	if gamemode == "wave":
		if !_is_dashing:
			if !mini:
				_wave_size_angle = 45.0
			else:
				_wave_size_angle = 60.0
			if direction == Vector2(1.0, 1.0):
				_wave_target_angle = _wave_size_angle + arrow_trigger_sprite_rotation_offset
			elif direction == Vector2(1.0, -1.0):
				_wave_target_angle = -_wave_size_angle + arrow_trigger_sprite_rotation_offset
			elif direction == Vector2(-1.0, 1.0):
				_wave_target_angle = 180.0 - _wave_size_angle + arrow_trigger_sprite_rotation_offset
			elif direction == Vector2(-1.0, -1.0):
				_wave_target_angle = 180.0 + _wave_size_angle + arrow_trigger_sprite_rotation_offset
			
			# change rotation instanlly if the wave is horizontal and flips side because it looks weird otherwise
			elif direction == Vector2(1.0, 0.0):
				_wave_target_angle = 0.0 + arrow_trigger_sprite_rotation_offset
#				player_icon.rotation_degrees = _wave_target_angle
			elif direction == Vector2(-1.0, 0.0):
				_wave_target_angle = 180.0 + arrow_trigger_sprite_rotation_offset
#				player_icon.rotation_degrees = _wave_target_angle
			
			elif direction == Vector2(0.0, 1.0):
				_wave_target_angle = 90.0 + arrow_trigger_sprite_rotation_offset
			elif direction == Vector2(0.0, -1.0):
				_wave_target_angle = -90.0 + arrow_trigger_sprite_rotation_offset
			if _wave_target_angle - player_icon.rotation_degrees > 180.0:
				_wave_target_angle -= 360.0
			elif _wave_target_angle - player_icon.rotation_degrees < -180.0:
				# add or remove 360° if the angle is too big to prevent weird rotations
				_wave_target_angle += 360.0
			if arrow_trigger_direction == Vector2(0.0, -1.0) && (is_on_floor() || is_on_ceiling()):
				if direction.x == 1:
					_wave_target_angle = 0.0
				elif direction.x == -1:
					_wave_target_angle = 180.0
			elif arrow_trigger_direction == Vector2(-1.0, 0.0) && is_on_wall():
				if direction.x == 1:
					_wave_target_angle = -90.0
				elif direction.x == -1:
					_wave_target_angle = 90.0
			if player_icon.rotation_degrees != _wave_target_angle:
				player_icon.rotation_degrees = move_toward(player_icon.rotation_degrees, _wave_target_angle, smooth_rot_speed)
			if direction == Vector2(0.0, 0.0):
				player_icon.rotation_degrees = fmod(player_icon.rotation_degrees, 360.0)
		else:
			player_icon.rotation = move_toward(player_icon.rotation, _dash_orb_rotation * _icon_direction, smooth_rot_speed)
			$DashFire.rotation = _dash_orb_rotation * _icon_direction
	if gamemode == "ufo" || gamemode == "spider":
		$SpiderSprites.scale.x = -2
		if !_is_dashing:
			if "Slope" in str($AreaDetection.get_overlapping_bodies()) && player_icon.rotation_degrees != floor_angle:
				player_icon.rotation_degrees = move_toward(player_icon.rotation_degrees, floor_angle, smooth_rot_speed)
				$SpiderSprites.rotation = move_toward($SpiderSprites.rotation, floor_angle, smooth_rot_speed)
			elif $SpiderSprites.rotation != 0.0:
				player_icon.rotation_degrees = move_toward(player_icon.rotation_degrees, 0.0, smooth_rot_speed)
				if arrow_trigger_direction == Vector2(0.0, -1.0) && $SpiderSprites.rotation != 0.0:
					$SpiderSprites.rotation = move_toward($SpiderSprites.rotation, 0.0, smooth_rot_speed)
		elif player_icon.rotation_degrees != _dash_orb_rotation:
			player_icon.rotation_degrees = move_toward(player_icon.rotation_degrees, _dash_orb_rotation, smooth_rot_speed)
			$SpiderSprites.rotation = move_toward($SpiderSprites.rotation, _dash_orb_rotation, smooth_rot_speed)

func player_dies():
	$PlayerGroundParticles.hide()
	emit_signal("dead")
	_is_dead = true
	_is_dashing = false
	gravity = 0
	velocity = Vector2(0.0, 0.0)
	UP_DIRECTION.y = -1
	CurrentLevel.reset()
	get_node("/root/Scene/LevelMusic").playing = false

func player_respawn():
	CurrentLevel.reset_lvl_time()
	get_tree().reload_current_scene()

# Spider States

var _is_spider_jumping: bool = false

func _spider_manage_states():
	if _jump_direction == UP_DIRECTION.y:
		_is_spider_jumping = true
	if level_ended:
		_spider_state_machine.travel("fall loop")
	elif (is_on_floor() || is_on_ceiling() || is_on_wall()) && direction.x == 0:
		_spider_state_machine.travel("idle")
	elif (is_on_floor() || is_on_ceiling() || is_on_wall()) && direction.x != 0 && _speed_multiplier == 1.0: # speed 1
		_spider_state_machine.travel("walkSpeed1")
	elif (is_on_floor() || is_on_ceiling() || is_on_wall()) && direction.x != 0 && _speed_multiplier == 0.807: # speed 0.5
		_spider_state_machine.travel("walkSpeed0-5")
	elif (is_on_floor() || is_on_ceiling() || is_on_wall()) && direction.x != 0 && _speed_multiplier == 1.243: # speed 2
		_spider_state_machine.travel("walkSpeed2")
	elif (is_on_floor() || is_on_ceiling() || is_on_wall()) && direction.x != 0 && _speed_multiplier == 1.502: # speed 3
		_spider_state_machine.travel("walkSpeed3")
	elif (is_on_floor() || is_on_ceiling() || is_on_wall()) && direction.x != 0 && _speed_multiplier == 1.849: # speed 4
		_spider_state_machine.travel("walkSpeed4")
	elif UP_DIRECTION.y < 0: # normal gravity
		if !(is_on_floor() || is_on_ceiling() || is_on_wall()) && velocity.y < 0 && !_is_dashing:
			_spider_state_machine.travel("jump")
			_is_spider_jumping = true
		elif (!(is_on_floor() || is_on_ceiling() || is_on_wall()) && velocity.y > 0) || _is_dashing:
			_spider_state_machine.travel("fall loop")
			_is_spider_jumping = false
	elif UP_DIRECTION.y > 0: # inverted gravity
		if !(is_on_floor() || is_on_ceiling() || is_on_wall()) && velocity.y > 0 && !_is_dashing:
			_spider_state_machine.travel("jump")
			_is_spider_jumping = true
		elif (!(is_on_floor() || is_on_ceiling() || is_on_wall()) && velocity.y < 0) || _is_dashing:
			_spider_state_machine.travel("fall loop")
			_is_spider_jumping = false

var _spider_immunity_timer: int

func do_spider_jump():
	_spider_immunity_timer = 10
	_in_jblock = true
	if arrow_trigger_direction == Vector2(0.0, -1.0):
		var collision_point: float = $SpiderSprites/SpiderRaycast.get_collision_point().y
		var arrival_coordinates: float
		if UP_DIRECTION.y > 0: # inverted gravity
			arrival_coordinates = collision_point
		elif UP_DIRECTION.y < 0 && _spider_orb_opposite_gravity:
			arrival_coordinates = collision_point
		else: # normal gravity
			arrival_coordinates = (collision_point + $Icon.texture.get_height()/2)
		var old_pos = position
		position.y = arrival_coordinates
		if not _spider_orb_opposite_gravity:
			gravity *= -1
			UP_DIRECTION.y *= -1
			velocity.y = 0
			_jump_direction = UP_DIRECTION.y * -1
		emit_signal("spider_jumped", abs(arrival_coordinates - old_pos.y))
		if mini && UP_DIRECTION.y > 0 && _orb_checker & GDInteractible.Orb.ORB_SPIDER:
			position.y -= 30
	elif arrow_trigger_direction == Vector2(-1.0, 0.0):
		var collision_point: float = $SpiderSprites/SpiderRaycast.get_collision_point().x
		var arrival_coordinates: float
		if UP_DIRECTION.y > 0: # inverted gravity
			arrival_coordinates = (collision_point - $Icon.texture.get_height()/2)
		elif UP_DIRECTION.y < 0 && _spider_orb_opposite_gravity:
			arrival_coordinates = collision_point
		else: # normal gravity
			arrival_coordinates = (collision_point + $Icon.texture.get_height()/2)
		var old_pos = position
		position.x = arrival_coordinates
		if not _spider_orb_opposite_gravity:
			gravity *= -1
			UP_DIRECTION.y *= -1
			velocity.x *= -1
			_jump_direction = UP_DIRECTION.y * -1
		emit_signal("spider_jumped", abs(arrival_coordinates - old_pos.x))
		if mini && UP_DIRECTION.y > 0 && _orb_checker & GDInteractible.Orb.ORB_SPIDER:
			position.x -= 30
	if "BackgroundKillZone" in str($SpiderSprites/SpiderRaycast.get_collider()):
		player_camera.global_position.y = -4750
		$DeathParticles.global_position.y = -4750
		$AnimationPlayer.play("DeathAnimation")
	if !_spider_orb_opposite_gravity:
		$SpiderSprites.scale.y *= -1

func stopDashing():
	$DashFire.hide()
	_is_dashing = false
	rotation_degrees = 0.0
	_dash_orb_y_offset = 0.0
	gravity = gravityBackup if !gamemode == "ship" else shipGravityDirection * UP_DIRECTION.y * -1

var cube_texture = preload("res://assets/playerTextures/cube.png")
var robot_texture = preload("res://assets/playerTextures/robot_placeholder.png")
var ship_texture = preload("res://assets/playerTextures/ship.png")
var jetpack_texture = preload("res://assets/playerTextures/jetpack.png")
var ufo_texture = preload("res://assets/playerTextures/ufo.png")
var ball_texture = preload("res://assets/playerTextures/ball.png")
var wave_texture = preload("res://assets/playerTextures/wave.png")
var swingcopter_texture = preload("res://assets/playerTextures/swingcopter.png")

func changeSpriteOnGamemode() -> void:
	if gamemode == "cube":
		$Icon.set_texture(cube_texture)
		$Icon.offset = Vector2(0.0, 0.0)
		$Icon.scale = Vector2(1.0, 1.0)
		$Hitbox.scale = Vector2(1.0, 1.0)
		$AreaDetection.scale = Vector2(1.05, 1.05)
	elif gamemode == "ship" && !is_platformer:
		$Icon.set_texture(ship_texture)
		$Icon.offset = Vector2(0.0, -22.5 * UP_DIRECTION.y * -1)
		$Icon.scale = Vector2(1.523, 1.523)
		$Hitbox.scale = Vector2(1.0, 1.0)
		$AreaDetection.scale = Vector2(1.05, 1.05)
	elif gamemode == "ship" && is_platformer:
		$Icon.set_texture(jetpack_texture)
		$Icon.offset = Vector2(0.0, 0.0)
		$Icon.scale = Vector2(1.2, 1.2)
		$Hitbox.scale = Vector2(1.0, 1.0)
		$AreaDetection.scale = Vector2(1.05, 1.05)
	elif gamemode == "ufo":
		$Icon.set_texture(ufo_texture)
		$Icon.offset = Vector2(0.0, 4.0 * UP_DIRECTION.y * -1)
		$Icon.scale = Vector2(1.1, 1.1)
		$Hitbox.scale = Vector2(1.0, 1.0)
		$AreaDetection.scale = Vector2(1.05, 1.05)
	elif gamemode == "ball":
		$Icon.set_texture(ball_texture)
		$Icon.offset = Vector2(0.0, 4.5)
		$Icon.scale = Vector2(1.0, 1.0)
		$Hitbox.scale = Vector2(1.0, 1.0)
		$AreaDetection.scale = Vector2(1.05, 1.05)
	elif gamemode == "swingcopter":
		$Icon.set_texture(swingcopter_texture)
		$Icon.offset = Vector2(0.0, 0.0)
		$Icon.scale = Vector2(1.0, 1.0)
		$Hitbox.scale = Vector2(1.0, 1.0)
		$AreaDetection.scale = Vector2(1.05, 1.05)
	elif gamemode == "wave":
		$Icon.set_texture(wave_texture)
		$Icon.offset = Vector2(0.0, 0.0)
#		$Icon.scale = Vector2(1.0, 1.0)
		$Hitbox.scale = Vector2(0.5, 0.5)
		$AreaDetection.scale = Vector2(0.5, 0.5)
	elif gamemode == "robot":
		$Icon.set_texture(robot_texture)
		$Icon.offset = Vector2(0.0, -20.0)
		$Icon.scale = Vector2(1.0, 1.0)
		$Hitbox.scale = Vector2(1.0, 1.0)
		$AreaDetection.scale = Vector2(1.05, 1.05)
	elif gamemode == "spider":
		$Icon.hide()
		$Icon.offset = Vector2(0.0, 0.0)
		$Icon.scale = Vector2(1.0, 1.0)
		$Hitbox.scale = Vector2(1.0, 1.0)
		$AreaDetection.scale = Vector2(1.05, 1.05)
		$SpiderSprites.show()
	if !gamemode == "spider" && !_is_dead:
		$Icon.show()
		$SpiderSprites.hide()
	if _is_dead:
		$Icon.hide()
		$SpiderSprites.hide()
	if gamemode != "wave":
		if _icon_direction < 0:
			$Icon.flip_h = true
			$SpiderSprites.scale.x = -2
		else:
			$Icon.flip_h = false
			$SpiderSprites.scale.x = 2
	else:
		player_icon.flip_h = false
		player_icon.flip_v = false

func set_platformer(platformer: bool) -> void:
	is_platformer = platformer

# Gameplay Elements Signals
func _on_HazardsArea_body_entered() -> void:
	_is_hazard_colliding = true

func _on_ToggleOrb_area_entered(_area: Area2D) -> void:
	_is_toggle_orb_colliding = true

func _on_ToggleOrb_area_exited() -> void:
	_is_toggle_orb_colliding = false

# Portals
func _on_YellowGravityPortal_area_entered() -> void:
	_is_yellow_gravity_portal_colliding = true
	if _is_yellow_gravity_portal_colliding:
		gravity = -5000
		gravityBackup = -5000
		UP_DIRECTION.y = 1
		$SpiderSprites.scale.y = -2
	_is_yellow_gravity_portal_colliding = false

func _on_BlueGravityPortal_area_entered() -> void:
	_is_blue_gravity_portal_colliding = true
	if _is_blue_gravity_portal_colliding:
		gravity = 5000
		gravityBackup = 5000
		UP_DIRECTION.y = -1
		$SpiderSprites.scale.y = 2
	_is_blue_gravity_portal_colliding = false

# Gamemode Portals
func _on_CubePortal_area_entered() -> void:
	gamemode = "cube"
	player_icon.flip_v = false
	player_icon.rotation_degrees = 0
	gravity = shipGravityDirection * UP_DIRECTION.y * -1

func _on_ShipPortal_area_entered() -> void:
	gamemode = "ship"
	player_icon.rotation_degrees = 0

func _on_UFOPortal_area_entered() -> void:
	gamemode = "ufo"
	player_icon.rotation_degrees = 0
	gravity = shipGravityDirection * UP_DIRECTION.y * -1

func _on_WavePortal_area_entered() -> void:
	gamemode = "wave"
	player_icon.rotation_degrees = 0

func _on_BallPortal_area_entered() -> void:
	gamemode = "ball"
	player_icon.rotation_degrees = 0

func _on_RobotPortal_area_entered() -> void:
	gamemode = "robot"
	player_icon.rotation_degrees = 0
	gravity = shipGravityDirection * UP_DIRECTION.y * -1

func _on_SpiderPortal_area_entered() -> void:
	gamemode = "spider"
	player_icon.rotation_degrees = 0
	gravity = shipGravityDirection * UP_DIRECTION.y * -1

func _on_SwingcopterPortal_area_entered() -> void:
	gamemode = "swingcopter"
	player_icon.rotation_degrees = 0

# Size Portals
func _on_MiniSizePortal_area_entered() -> void:
	mini = true

func _on_NormalSizePortal_area_entered() -> void:
	mini = false
	if UP_DIRECTION.y > 0:
		if !gamemode == "wave": position.y += 30
		else: position.y += 15


func _on_BlockOverlap_body_entered(_body: Node) -> void:
	_is_small_hitbox_colliding = true
