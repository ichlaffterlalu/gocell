extends "res://Main/Scripts/Base/SceneFade.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var scene_path_to_load
var _current_subscene = ""

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	ready_fade()
	GameplayVar.reset_gameplay()

	for button in $MainPage/Container/HBox/LeftSide/MenuButtons/Scenes.get_children():
		button.connect("pressed", self, "_on_ChangeScene_Button_pressed", [button.scene_to_load])

	for button in $MainPage/Container/HBox/LeftSide/MenuButtons/Gameplay.get_children():
		button.connect("pressed", self, "_on_Gameplay_Button_pressed", [button.gameplay_type])

func _on_ChangeScene_Button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	$Fade.fade_in()

func _on_Gameplay_Button_pressed(gameplay_type):
	$MainPage/Container/HBox/RightSide/Dashboard/GodotLogo.toggle(false)
	$MainPage/Container/HBox/RightSide/Dashboard/Settings.toggle(false)
	_current_subscene = "select_stage"
	$MainPage/Container/HBox/RightSide/Dashboard/SelectStage._on_Button_pressed(gameplay_type)

func _on_Settings_pressed():
	if _current_subscene != "settings":
		$MainPage/Container/HBox/RightSide/Dashboard/SelectStage.toggle(false)
		$MainPage/Container/HBox/RightSide/Dashboard/GodotLogo.toggle(false)
		_current_subscene = "settings"
		$MainPage/Container/HBox/RightSide/Dashboard/Settings.toggle(true)
	else:
		$MainPage/Container/HBox/RightSide/Dashboard/SelectStage.toggle(false)
		$MainPage/Container/HBox/RightSide/Dashboard/GodotLogo.toggle(true)
		$MainPage/Container/HBox/RightSide/Dashboard/Settings.toggle(false)
		_current_subscene = ""

func _on_Exit_pressed():
	$Fade.fade_in()
	scene_path_to_load = "exit_game"

func _on_Fade_fade_in_finished():
	if scene_path_to_load == "exit_game":
		get_tree().quit()
	elif scene_path_to_load == "restart":
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene(scene_path_to_load)


func _on_SelectStage_fade_out_finished():
	if _current_subscene == "select_stage":
		$MainPage/Container/HBox/RightSide/Dashboard/GodotLogo.toggle(true)
		_current_subscene = ""


func _on_Settings_need_restart():
	$Fade.fade_in()
	scene_path_to_load = "restart"
