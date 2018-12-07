extends Node

signal player_finished(player_node)
export(String) var map_name = "World";

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var game_start_time = 0
var time_trial_mode = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$Player.set_player_name(Global.player_1_name)
	$Player.set_character(Global.player_1_character_id)
	$Player2.set_player_name(Global.player_2_name)
	$Player2.set_character(Global.player_2_character_id)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _enable_time_trial_mode():
	time_trial_mode = true
	$Player2.remove_and_skip()

func _on_Player_finished(player_node):
	player_node.set_finish_time(player_node.finish_time - game_start_time)
	emit_signal("player_finished", player_node)

func _on_Player_first_move(start_time):
	if game_start_time == 0:
		game_start_time = start_time


func _on_Main_start_game():
	$Player.set_player_active(true)
	if !time_trial_mode:
		$Player2.set_player_active(true)


func _on_game_change_status(active_status):
	$Player.set_player_active(active_status)
	if !time_trial_mode:
		$Player2.set_player_active(active_status)
