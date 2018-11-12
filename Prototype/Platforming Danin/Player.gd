extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20
const SPEED = 200
const TOP_SPEED = 1000
const JUMP_HEIGHT = -600
const STAMINA = 0

export var id = 0
var motion = Vector2()
var ACCELERATION_RIGHT = 200
var ACCELERATION_LEFT = -200



func _physics_process(delta):
	motion.y += GRAVITY
	
	
	if Input.is_action_pressed("ui_right_%s" % id):
		ACCELERATION_LEFT = -SPEED
		
		if (STAMINA >= 100000):
			ACCELERATION_RIGHT = SPEED
			STAMINA = 0
			
		motion.x = ACCELERATION_RIGHT
		STAMINA += motion.x

	elif Input.is_action_pressed("ui_left_%s" % id):
		ACCELERATION_RIGHT = SPEED
		
		if (STAMINA >= 100000):
			ACCELERATION_LEFT = -SPEED
			STAMINA = 0
			
		motion.x = ACCELERATION_LEFT
		STAMINA += -motion.x
	
	elif Input.is_action_just_released("ui_right_%s" % id):
		ACCELERATION_LEFT = -SPEED
		
		if (ACCELERATION_RIGHT + SPEED < TOP_SPEED):
			ACCELERATION_RIGHT += SPEED
		else :
			ACCELERATION_RIGHT = TOP_SPEED
		
		if (STAMINA >= 100000):
			ACCELERATION_RIGHT = SPEED
			STAMINA = 0
				
		motion.x = ACCELERATION_RIGHT
		STAMINA += motion.x
	
	elif Input.is_action_just_released("ui_left_%s" % id):
		ACCELERATION_RIGHT = SPEED
		
		if (ACCELERATION_LEFT - SPEED > TOP_SPEED):
			ACCELERATION_LEFT -= SPEED
		else:
			ACCELERATION_LEFT = -TOP_SPEED
			
		if (STAMINA >= 100000):
			ACCELERATION_LEFT = -SPEED
			STAMINA = 0
			
		motion.x = ACCELERATION_LEFT
		STAMINA += -motion.x
	
			
	else:
		motion.x = 0
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up_%s" % id):
			motion.y = JUMP_HEIGHT
			
	
	motion = move_and_slide(motion,UP)
	pass
	
