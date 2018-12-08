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

func _ready():
	ready_fade()
	GameplayVar.reset_gameplay()
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
		DB.insert_to_records(player_node, 1, world.map_name)
	elif not GameplayVar.gameplay_is_cutted_off():
		if player_node.id == 1:
			emit_signal("lose_1", player_node)
		elif player_node.id == 2:
			emit_signal("lose_2", player_node)
		DB.insert_to_records(player_node, 1, world.map_name)

func _on_FinishedLabel_finished_waiting():
	t.start()
	yield(t, "timeout")
	_on_GameMenu_return_to_title_screen()
	t.queue_free()

func _on_FinishedLabel_start_game():
	world.get_node("Music").play()
	emit_signal("game_change_status", true)
