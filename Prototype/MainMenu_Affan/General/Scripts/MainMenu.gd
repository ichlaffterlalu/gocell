extends "res://General/Scripts/SceneFade.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var scene_path_to_load

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$MainPage/MarginContainer/HBoxContainer/RightSide/CenterContainer/TextureRect/AnimationPlayer.play("rotate")
	$Fade.show()
	$Fade.fade_out()
	for button in $MainPage/MarginContainer/HBoxContainer/LeftSide/MenuButtons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])

func _on_Button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	$Fade.show()
	$Fade.fade_in()

func _on_Fade_fade_in_finished():
	if scene_path_to_load == "exit_game":
		get_tree().quit()
	else:
		get_tree().change_scene(scene_path_to_load)

func _on_Exit_pressed():
	$Fade.show()
	$Fade.fade_in()
	scene_path_to_load = "exit_game"


func _on_Settings_pressed():
	$MainPage/MarginContainer/HBoxContainer/RightSide/CenterContainer/Settings/WindowDialog.popup() # replace with function body
