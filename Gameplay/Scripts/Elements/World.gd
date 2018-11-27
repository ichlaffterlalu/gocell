extends Node

signal player_finished(player_node)

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var game_start_time = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Player_finished(player_node):
	player_node.set_finish_time(player_node.finish_time - game_start_time)
	emit_signal("player_finished", player_node)


func _on_Player_first_move(start_time):
	if game_start_time == 0:
		game_start_time = start_time


func _on_Main_start_game():
	$Player.set_player_active(true)
	$Player2.set_player_active(true)


func _on_game_change_status(active_status):
	$Player.set_player_active(active_status)
	$Player2.set_player_active(active_status)
