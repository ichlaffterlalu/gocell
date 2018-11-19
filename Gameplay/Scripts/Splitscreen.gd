extends "res://Main/Scripts/Base/SceneFade.gd"

onready var viewport1 = $Viewports/ViewportContainer1/Viewport1
onready var viewport2 = $Viewports/ViewportContainer2/Viewport2
onready var camera1 = $Viewports/ViewportContainer1/Viewport1/Camera2D
onready var camera2 = $Viewports/ViewportContainer2/Viewport2/Camera2D
onready var world = $Viewports/ViewportContainer2/Viewport2/World

var exit_mode = null

func _ready():
	ready_fade()
	viewport1.world_2d = viewport2.world_2d
	camera1.target = world.get_node("Player")
	camera2.target = world.get_node("Player2")


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
