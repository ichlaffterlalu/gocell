extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const ACCEL = 10
const SPEED = 400
const JUMP_HEIGHT = -600

export var id = 0

var current_max_speed = SPEED
var motion = Vector2()
var moving = false
var finish = false
var win = false;
var boost = true
var stamina = 5
var accel_right = 0
var accel_left = 0

var timeDict = OS.get_ticks_msec()

func _physics_process(delta):
	if (!finish):
		var currentTime = OS.get_ticks_msec()
		
		if (currentTime / 100 % 50 == timeDict / 100 % 50):
			print("REFRESH")
			stamina = 5
			current_max_speed = SPEED
		
		motion.y += GRAVITY
		if Input.is_action_just_pressed("ui_right_%s" % id):
			if stamina != 0:
				stamina -= 1
				print (stamina)
				if motion.x > 0:
					boost = true
					motion.x += 1200
					current_max_speed += 100
				if boost:
					print ("RIGHT BOOST. Current maximum speed = ",current_max_speed)
					
		elif Input.is_action_just_pressed("ui_left_%s" % id):
			if stamina != 0:
				stamina -= 1
				print (stamina)
				if motion.x < 0:
					boost = true
					motion.x -= 1200
					current_max_speed += 100
				if boost:
					print ("LEFT BOOST. Current maximum speed = ",current_max_speed)
					
		elif Input.is_action_pressed("ui_right_%s" % id):
			if boost:
				motion.x = min(motion.x + ACCEL, current_max_speed)
			else:
				motion.x = min(motion.x + ACCEL, SPEED)
				
		elif Input.is_action_pressed("ui_left_%s" % id):
			if boost:
				motion.x = max(motion.x - ACCEL, -current_max_speed)
			else:
				motion.x = max(motion.x - ACCEL, -SPEED)
				
		else:
			motion.x = lerp(motion.x, 0, 0.1)
			if motion.x == 0:
				boost = false
				current_max_speed = SPEED
				
		if is_on_floor():
			if Input.is_action_just_pressed("ui_up_%s" % id):
				motion.y = JUMP_HEIGHT
			
		if (position.x >3640):
			if (position.y > 400):
				finish = true
				print ("Player ", id , " finish");
				if (!win):
					print("Player ", id , " win");
					win = true
				
				
		
		motion = move_and_slide(motion,UP)
		pass
	
	