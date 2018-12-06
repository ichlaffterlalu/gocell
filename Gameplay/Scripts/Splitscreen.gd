extends "res://Main/Scripts/Base/SceneFade.gd"

signal win_1(player_node)
signal win_2(player_node)
signal waiting_1()
signal waiting_2()
signal lose_1(player_node)
signal lose_2(player_node)
signal game_change_status(active_status)

onready var viewport1 = $Viewports/ViewportContainer1/Viewport1
onready var viewport2 = $Viewports/ViewportContainer2/Viewport2
onready var finishlabel1 = $Viewports/ViewportContainer1/FinishedLabel
onready var finishlabel2 = $Viewports/ViewportContainer1/FinishedLabel
onready var camera1 = $Viewports/ViewportContainer1/Viewport1/Camera2D
onready var camera2 = $Viewports/ViewportContainer2/Viewport2/Camera2D
onready var world = $Viewports/ViewportContainer2/Viewport2/World
onready var t = Timer.new()

var finished_players = []
var exit_mode = null
var finished_waiting = false

func _insert_to_leaderboard(player_node):
	var timestamp = OS.get_datetime()
	var query = "INSERT INTO Records (user_name, timestamp, duration, multiplayer) VALUES ("
	query += "'" + player_node.player_name + "', "
	query += "'%04d-%02d-%02d %02d:%02d:%02d', " % [timestamp.year, timestamp.month, timestamp.day, timestamp.hour, timestamp.minute, timestamp.second];
	query += str(player_node.finish_time/1000) + ", "
	query += "0);"
	print(query)
	
	var db = preload("res://lib/gdsqlite.gdns").new()
	if (!db.open_db("user://data.sqlite3")):
		print("Cannot open database.")
		return false
	var result = db.query(query)
	db.close()
	return result
	
func _ready():
	ready_fade()
	viewport1.world_2d = viewport2.world_2d
	camera1.target = world.get_node("Player")
	camera2.target = world.get_node("Player2")
	#setup timer for game end
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)


func _on_Fade_fade_in_finished():
	if exit_mode == "stage_restart":
		get_tree().reload_current_scene()
	elif exit_mode == "title_screen":
		get_tree().change_scene("res://Main/Scenes/TitleScreen.tscn")


func _on_GameMenu_return_to_title_screen():
	exit_mode = "title_screen"
	$Fade.fade_in()


func _on_GameMenu_stage_restart():
	exit_mode = "stage_restart"
	$Fade.fade_in()

func _on_World_player_finished(player_node):
	finished_players.append(player_node)
	if len(finished_players) == 1:
		if player_node.id == 1:
			emit_signal("win_1", player_node)
			emit_signal("waiting_2")
		elif player_node.id == 2:
			emit_signal("win_2", player_node)
			emit_signal("waiting_1")
		print(_insert_to_leaderboard(player_node))
	elif !finished_waiting:
		if player_node.id == 1:
			emit_signal("lose_1", player_node)
		elif player_node.id == 2:
			emit_signal("lose_2", player_node)
		print(_insert_to_leaderboard(player_node))

func _on_FinishedLabel_finished_waiting():
	finished_waiting = true
	t.start()
	yield(t, "timeout")
	_on_GameMenu_return_to_title_screen()
	t.queue_free()

func _on_FinishedLabel_start_game():
	world.get_node("Music").play()
	emit_signal("game_change_status", true)
