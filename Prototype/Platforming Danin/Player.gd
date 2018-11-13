extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const ACCEL = 10
const NORMAL_SPEED = 200
const MAX_SPEED = 400
const JUMP_HEIGHT = -600

export var id = 0

var current_max_speed = MAX_SPEED
var motion = Vector2()
var moving = false
var boost = true
var stamina = 5
var accel_right = 0
var accel_left = 0


func _physics_process(delta):
	motion.y += GRAVITY
	if Input.is_action_just_pressed("ui_right_%s" % id):
		if motion.x > 0:
			boost = true
			motion.x += 1200
			current_max_speed += 100
		if boost:
			print ("RIGHT BOOST. Current maximum speed = ",current_max_speed)
	elif Input.is_action_just_pressed("ui_left_%s" % id):
		if motion.x < 0:
			boost = true
			motion.x -= 1200
		if boost:
			print ("LEFT BOOST. Current maximum speed = ",current_max_speed)
	elif Input.is_action_pressed("ui_right_%s" % id):
		if boost:
			motion.x = lerp(motion.x + ACCEL, current_max_speed,0.45)
		else:
			motion.x = min(motion.x + ACCEL, current_max_speed)
	elif Input.is_action_pressed("ui_left_%s" % id):
		if boost:
			motion.x = lerp(motion.x - ACCEL, -MAX_SPEED,0.45)
		else:
			motion.x = max(motion.x - ACCEL, -MAX_SPEED)
	else:
		motion.x = lerp(motion.x, 0, 0.1)
		if motion.x == 0:
			boost = false
			
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up_%s" % id):
			motion.y = JUMP_HEIGHT
	
	motion = move_and_slide(motion,UP)
	pass