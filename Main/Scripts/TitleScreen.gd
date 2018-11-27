extends "res://Main/Scripts/Base/SceneFade.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var scene_path_to_load

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	ready_fade()
	
	for button in $MainPage/Container/HBox/LeftSide/MenuButtons/Scenes.get_children():
		button.connect("pressed", self, "_on_ChangeScene_Button_pressed", [button.scene_to_load])
	
	for button in $MainPage/Container/HBox/LeftSide/MenuButtons/Gameplay.get_children():
		button.connect("pressed", self, "_on_Gameplay_Button_pressed", [button.gameplay_type])

func _on_ChangeScene_Button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	$Fade.fade_in()

func _on_Gameplay_Button_pressed(gameplay_type):
	$MainPage/Container/HBox/RightSide/Dashboard/SelectStage._on_Button_pressed(gameplay_type)
	if $MainPage/Container/HBox/RightSide/Dashboard/GodotLogo.is_visible_in_tree():
		$MainPage/Container/HBox/RightSide/Dashboard/GodotLogo.toggle()

func _on_SelectStage_user_choosed(scene_path):
	$Fade.fade_in()
	scene_path_to_load = scene_path

func _on_Settings_pressed():
	$MainPage/Container/HBox/RightSide/Dashboard/GodotLogo.toggle()
	$MainPage/Container/HBox/RightSide/Dashboard/Settings._on_Button_pressed()

func _on_Exit_pressed():
	$Fade.fade_in()
	scene_path_to_load = "exit_game"

func _on_Fade_fade_in_finished():
	if scene_path_to_load == "exit_game":
		get_tree().quit()
	else:
		get_tree().change_scene(scene_path_to_load)


func _on_SelectStage_fade_out_finished():
	$MainPage/Container/HBox/RightSide/Dashboard/GodotLogo.toggle()
