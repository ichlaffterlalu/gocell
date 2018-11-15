extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var scene_path_to_load

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	for button in $MainPage/MarginContainer/HBoxContainer/LeftSide/MenuButtons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])

func _on_Button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_FadeIn_fade_finished():
	get_tree().change_scene(scene_path_to_load)
