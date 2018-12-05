extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 20/2
const ACCEL = 25/2
const SPEED = 400/2
const JUMP_HEIGHT = -600/2

signal first_move(start_time)
signal player_finished(player_node)
signal recovery()

export(int) var id = 0
export(Vector2) var finish_line
export(bool) var finish_x_after # if yes, use position.x > finish_line.x in finish condition
export(bool) var finish_y_below # if no, use position.y < finish_line.y in finish condition
export(String) var player_name
export(Texture) var player_texture

var current_max_speed = SPEED
var motion = Vector2()
var moving = false
var started = false
var player_active = false
var finish_time = 0
var finish = false
var boost = true
var stamina = 5
var accel_right = 0
var accel_left = 0

var currentTime
var recoveryTime
var recov = false
var boostclick = 0

onready var dash_sound = $Dash

var timeDict = OS.get_ticks_msec()

func set_finish_time(time):
	finish_time = time

func set_player_active(val):
	if (!finish):
		player_active = val

func _ready():
	if player_texture != null:
		$Sprite.set_texture(player_texture)
	else:
		 _init_change_color_modulation(id)
	$Label.text = player_name

func _init_change_color_modulation(char_id):
	if char_id == 1:
		$Sprite.self_modulate = Color(1,1,1,1)
	elif char_id == 2:
		$Sprite.self_modulate = Color(1,1,0,1)
	else:
		$Sprite.self_modulate = Color(0,0,0,1)

func _check_started():
	if started == false:
		emit_signal("first_move", OS.get_ticks_msec())
	started = true

func _physics_process(delta):
	if (player_active):
		
		if (stamina < 5 and boost and not recov):
			recov = true
			emit_signal("recovery")
		
		motion.y += GRAVITY
		if Input.is_action_just_pressed("ui_right_%s" % id):
			_check_started()
			if motion.x > 0:
				if stamina != 0:
					print("TEST")
					dash_sound.play(0)
					stamina -= 1
					print (stamina)
					boost = true
					boostclick += 1
					#recoveryTime = OS.get_ticks_msec()
					motion.x = lerp(motion.x +2000/2, SPEED, 0.0001)
					current_max_speed = SPEED + 50 * (boostclick)
			if boost:
				print ("RIGHT BOOST. Current maximum speed = ",current_max_speed)
				
				
		elif Input.is_action_just_pressed("ui_left_%s" % id):
			_check_started()
			if motion.x < 0:
				if stamina != 0:
					stamina -= 1
					print (stamina)
					boost = true
					motion.x -= 1200/2
					current_max_speed += 100/2
					if boost:
						print ("LEFT BOOST. Current maximum speed = ",current_max_speed)
					
		elif Input.is_action_pressed("ui_right_%s" % id):
			_check_started()
			if boost:
				motion.x = min(motion.x + ACCEL, current_max_speed)
			else:
				motion.x = min(motion.x + ACCEL, SPEED)
				
		elif Input.is_action_pressed("ui_left_%s" % id):
			_check_started()
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
				_check_started()
				motion.y = JUMP_HEIGHT

		if (finish_line.x > 0 && ((finish_x_after && position.x > finish_line.x) || (!finish_x_after && position.x < finish_line.x))):
			if (finish_line.y > 0 && ((finish_y_below && position.y > finish_line.y) || (!finish_y_below && position.y < finish_line.y))):
				finish = true
				player_active = false
				finish_time = OS.get_ticks_msec()
				
				print ("Player ", id , " finish");
				emit_signal("player_finished", self)

		
		motion = move_and_slide(motion,UP)
		pass
	
	

func _on_Timer_timeout():
	print("hello?")
	stamina += 1
	current_max_speed = SPEED
	print(stamina)
	boostclick = 0
	if (stamina == 5):
		recov = false
		$Timer.stop()
