extends "res://Main/Scripts/Animations/Fade.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var to_gameplay_type = "Gameplay"
signal user_choosed(scene_path)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	for button in $Main/Container/Stages.get_children():
		button.connect("pressed", self, "_on_SceneButton_pressed", [button.scene_to_load])

func _on_Button_pressed(gameplay_type="Gameplay"):
	if to_gameplay_type != gameplay_type && self.is_visible_in_tree():
		to_gameplay_type = gameplay_type
	elif self.is_visible_in_tree():
		self.fade_out()
	else:
		to_gameplay_type = gameplay_type
		self.fade_in()
		self.show()

func _on_SceneButton_pressed(path):
	emit_signal("user_choosed", "res://" + to_gameplay_type + "/" + path)
