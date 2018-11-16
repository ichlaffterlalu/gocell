extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const SPEED = 200
const JUMP_HEIGHT = -600

export var id = 0
var motion = Vector2()
var moving = false


func _physics_process(delta):
	motion.y += GRAVITY
	
	if Input.is_action_pressed("ui_right_%s" % id):
		motion.x = SPEED
	elif Input.is_action_pressed("ui_left_%s" % id):
		motion.x = -SPEED
	else:
		motion.x = 0
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up_%s" % id):
			motion.y = JUMP_HEIGHT
	
	motion = move_and_slide(motion,UP)
	pass
	
