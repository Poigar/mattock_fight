extends KinematicBody2D

const UP = Vector2(0,-1)

var ACCELERATION = 50
var JUMP_HEIGHT = -550
var MAX_SPEED = 260
var CLIMB_SPEED = -350
var GRAVITY = Vector2(0, 1200)
var BULLET_GRAVITY = Vector2(0,700)

var bullet_speed_multiplier = 2.5
var max_bullet_speed = 300

var velocity = Vector2()
var friction = false

var camera = null
var camera_zoom_intensity = 0.1
var camera_max_zoom = 0.5
var camera_min_zoom = 1.5

slave var slave_pos = Vector2()

var use_camera = false;

var player_area = null

var pots_inspected = [] #Keeps a record of opened pots to close them on area leave





func _ready():
	
	camera = get_node("cam")
	player_area = get_node("area")
	
	if(use_camera && is_network_master()):
		camera.make_current()
		
	set_process_input(true)





func _physics_process(delta):
	
	if is_network_master():
#		print("hola")
	
		_check_area_overlap()
		_calc_gravity(delta)
		_calc_movement(delta)
		_calc_jump_force(delta)
		velocity = move_and_slide(velocity, UP)
		rset("slave_pos", position)
	else:
		position = slave_pos





func _calc_movement(delta):
	
	if Input.is_action_pressed("player_move_left"):
		velocity.x = max(velocity.x-ACCELERATION, -MAX_SPEED)
	elif Input.is_action_pressed("player_move_right"):
		velocity.x = min(velocity.x+ACCELERATION, MAX_SPEED)
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)





func _calc_gravity(delta):
	
	if !is_on_wall():
		velocity += delta * GRAVITY





func _calc_jump_force(delta):

	if is_on_floor() && Input.is_action_pressed("player_jump"):
		velocity.y += JUMP_HEIGHT
	
	if is_on_wall() && Input.is_action_pressed("player_jump"):
		velocity.y = CLIMB_SPEED





func _input(event):
	
	_handle_zoom()
	
	if event.is_action("player_throw") && is_network_master():
		_handle_aim()
	
	



func _check_area_overlap():
	
	var overlapping_areas = player_area.get_overlapping_areas()
	
	if overlapping_areas.size() > 0:
	
		for area in overlapping_areas:
			if area.is_in_group("pots"):
				area.get_parent().open_inspector()
				pots_inspected.append(area)
				
	else:
		
		for pot in pots_inspected:
			pot.get_parent().close_inspector()
			pots_inspected.remove(pots_inspected.find(pot))



master func _use_camera(state):
	use_camera = state





func _handle_aim():
	var mouse_pos = get_global_mouse_position() - global_position
	
	if mouse_pos.x > max_bullet_speed:
		mouse_pos.x = max_bullet_speed
	if mouse_pos.x < -max_bullet_speed:
		mouse_pos.x = -max_bullet_speed
	
	if mouse_pos.y < -max_bullet_speed:
		mouse_pos.y = -max_bullet_speed
	if mouse_pos.y > max_bullet_speed:
		mouse_pos.y = max_bullet_speed
		
	rpc("_spawn_bullet",$aim.global_position,mouse_pos*bullet_speed_multiplier)





sync func _spawn_bullet(pos,impulse):
	
	var bullet = preload("res://scenes/weapons/snowball.tscn").instance()
	bullet.position = pos
	bullet.apply_impulse(Vector2(0,0),impulse)
	bullet.add_force(Vector2(0,0),BULLET_GRAVITY)
	bullet.add_collision_exception_with(self)
	get_parent().add_child(bullet)


func _handle_zoom():
	if Input.is_action_pressed("camera_zoom_out"):
		var current_zoom_level = camera.get_zoom()
		if current_zoom_level.x < camera_min_zoom:
			camera.set_zoom(Vector2(current_zoom_level.x + camera_zoom_intensity, current_zoom_level.y + camera_zoom_intensity) )
		
		
	if Input.is_action_pressed("camera_zoom_in"):
		var current_zoom_level = camera.get_zoom()
		if current_zoom_level.x > camera_max_zoom:
			camera.set_zoom(Vector2(current_zoom_level.x - camera_zoom_intensity, current_zoom_level.y - camera_zoom_intensity) )