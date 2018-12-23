extends KinematicBody2D

var UP = Vector2(0,-1)
var GRAVITY = 20/2
var ACCEL = 25/2
var SPEED = 400/2
var JUMP_HEIGHT = -600/2
var MAX_STAM = 5

signal first_move(start_time)
signal player_finished(player_node)
signal recovery()
signal add_stam(id)
signal delete_stam(id)

export(int) var id = 0
export(Vector2) var finish_line
export(bool) var finish_x_after # if yes, use position.x > finish_line.x in finish condition
export(bool) var finish_y_below # if no, use position.y < finish_line.y in finish condition
export(String) var player_name
export(SpriteFrames) var player_sprite
export(AudioStreamOGGVorbis) var jump_sound

var current_max_speed = SPEED
var motion = Vector2()
var moving = false
var started = false
var player_active = false
var finish_time = 0
var finish = false
var boost = true
var stamina = MAX_STAM
var accel_right = 0
var accel_left = 0

var currentTime
var recoveryTime
var recov = false
var boostclick = 0

onready var dash_sound = $Dash

# For detecting sudden speed change
var pos_before_1 = Vector2()
var pos_before_2 = Vector2()

var timeDict = OS.get_ticks_msec()

func set_finish_time(time):
	finish_time = time

func set_player_active(val):
	if (!finish):
		player_active = val

func set_player_name(val):
	if (!player_active && !finish):
		player_name = val
		$Label.text = player_name

func set_character(val):
	var character = DB.get_character_by_id(val)[0]
	if (!player_active && !finish):
		SPEED = character["top_speed"]
		ACCEL = character["acceleration"]
		MAX_STAM = character["stamina"]
		player_sprite = load(character["sprite_address"]).instance().frames
		$Sprite.frames = player_sprite
		current_max_speed = SPEED
		stamina = MAX_STAM
		if Global.player_1_character_id == Global.player_2_character_id:
			_init_change_color_modulation(id)
		# Set stam assets
		$StamContainer.init_stam_bars(stamina)

func _ready():
	if jump_sound != null:
		$Jump.stream = jump_sound
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
		$Sprite.play("idle")
		emit_signal("first_move", OS.get_ticks_msec())
	started = true

func _squared_dist_two_coord(coord1, coord2):
	return pow(coord1[0] - coord2[0],2) + pow(coord1[1] - coord2[1], 2)
	
func _physics_process(delta):
	if (player_active):
		var anim = null

		if (stamina < MAX_STAM and boost and not recov):
			recov = true
			emit_signal("recovery")

		motion.y += GRAVITY
		if Input.is_action_just_pressed("ui_right_%s" % id):
			_check_started()
			if motion.x > 0:
				if stamina != 0:
					$Sprite.frame = 0
					anim = "dash-right"
					dash_sound.play(0)
					emit_signal("delete_stam", stamina)
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
					$Sprite.frame = 0
					anim = "dash-left"
					dash_sound.play(0)
					emit_signal("delete_stam", stamina)
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
				anim = "jump"
				$Jump.play()
				motion.y = JUMP_HEIGHT

		if (finish_line.x > 0 && ((finish_x_after && position.x > finish_line.x) || (!finish_x_after && position.x < finish_line.x))):
			if (finish_line.y > 0 && ((finish_y_below && position.y > finish_line.y) || (!finish_y_below && position.y < finish_line.y))):
				finish = true
				player_active = false
				finish_time = GameplayVar.count_finish_time(OS.get_ticks_msec())

				print ("Player ", id , " finish");
				emit_signal("player_finished", self)
		motion = move_and_slide(motion, UP)
		var diff = _squared_dist_two_coord(pos_before_2, pos_before_1) - _squared_dist_two_coord(pos_before_1, Vector2(position.x, position.y))
		if (diff > 10) and not boost:
			$Sprite.play("idle")
			$Hit.play()
		pos_before_2 = pos_before_1
		pos_before_1 = Vector2(position.x, position.y)
		if anim != null:
			$Sprite.play(anim)

func _on_Sprite_animation_finished():
	if $Sprite.animation != "idle":
		$Sprite.play("idle")
		

func _on_Timer_timeout():
	stamina += 1
	emit_signal("add_stam", stamina)
	current_max_speed = SPEED
	print(stamina)
	boostclick = 0
	if (stamina == MAX_STAM):
		recov = false
		$Timer.stop()
