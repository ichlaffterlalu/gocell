extends "res://Main/Scripts/Base/SceneFade.gd"

signal time_trial_win(player_node)
signal time_trial_lose(player_node)
signal game_change_status(active_status)

onready var viewport1 = $Viewports/ViewportContainer1/Viewport1
onready var finishlabel1 = $Viewports/ViewportContainer1/FinishedLabel
onready var camera1 = $Viewports/ViewportContainer1/Viewport1/Camera2D
onready var world = $Viewports/ViewportContainer1/Viewport1/World
onready var time_label = $Viewports/ViewportContainer1/TimeLabels/Time
onready var record_label = $Viewports/ViewportContainer1/TimeLabels/Record
onready var t = Timer.new()

var exit_mode = null
var finished_waiting = false
var record_duration = -1
var stop_condition = false

func _ready():
	ready_fade()
	GameplayVar.reset_gameplay()
	camera1.target = world.get_node("Player")
	world._enable_time_trial_mode()
	_init_record()
	#setup timer for game end
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)

func _init_record():
	var record = DB.get_records_best_10(Global.player_1_name, -1, world.map_name, true).front()
	if record != null:
		record_duration = record["duration"]
		record_label.text = "Best of " + Global.player_1_name + " in " + world.map_name + ": " + str(record_duration) + " s"
	else:
		record_duration = -1
		record_label.text = Global.player_1_name + " never played in " + world.map_name + " before, so... no limits!"

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
	if not stop_condition:
		if record_duration < 0 or player_node.finish_time/1000.0 <= record_duration:
			stop_condition = true
			emit_signal("time_trial_win", player_node)
			DB.insert_to_records(player_node, 0, world.map_name)

func _on_FinishedLabel_finished_waiting():
	finished_waiting = true
	t.start()
	yield(t, "timeout")
	_on_GameMenu_return_to_title_screen()
	t.queue_free()

func _on_FinishedLabel_start_game():
	world.get_node("Music").play()
	emit_signal("game_change_status", true)

func _process(delta):
	if not stop_condition:
		var time = GameplayVar.count_finish_time(OS.get_ticks_msec())/1000.0
		time_label.text = "Time Elapsed: " + str(time) + " s"
		if record_duration >= 0 and time > record_duration:
			stop_condition = true
			emit_signal("time_trial_lose", world.get_player_1_node())
			emit_signal("game_change_status", false)
