extends "res://Main/Scripts/Base/SceneFade.gd"

signal time_trial_win(player_node)
signal time_trial_lose(player_node)
signal game_change_status(active_status)

onready var viewport1 = $Viewports/ViewportContainer1/Viewport1
onready var finishlabel1 = $Viewports/ViewportContainer1/FinishedLabel
onready var camera1 = $Viewports/ViewportContainer1/Viewport1/Camera2D
onready var world = $Viewports/ViewportContainer1/Viewport1/World
onready var t = Timer.new()

var finished_players = []
var exit_mode = null
var finished_waiting = false

func _ready():
	ready_fade()
	camera1.target = world.get_node("Player")
	world._enable_time_trial_mode()
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
		emit_signal("time_trial_win", player_node)

func _on_FinishedLabel_finished_waiting():
	finished_waiting = true
	t.start()
	yield(t, "timeout")
	_on_GameMenu_return_to_title_screen()
	t.queue_free()

func _on_FinishedLabel_start_game():
	world.get_node("Music").play()
	emit_signal("game_change_status", true)
