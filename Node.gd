extends KinematicBody2D

var vel = Vector2()
func _ready():
	set_physics_process(true)





func _physics_process(delta):
	
	if Input.is_action_pressed("player_move_right"):
		vel.x = 100
	elif Input.is_action_pressed("player_move_left"):
		vel.x = -100
	else:
		vel.x = 0
		
	
	move_and_slide(vel)