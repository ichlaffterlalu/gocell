extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$Fade.show()
	$Fade.fade_out()

func _on_Fade_fade_out_finished():
	$Fade.hide()