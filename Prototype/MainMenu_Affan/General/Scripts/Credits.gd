extends "res://General/Scripts/SceneFade.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$Background/Container.hide()
	._ready()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Fade_fade_out_finished_child():
	._on_Fade_fade_out_finished()
	$AnimationPlayer.play("credits")
	$Background/Container.show()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "credits":
		$Fade.fade_in()


func _on_Fade_fade_in_finished():
	get_tree().change_scene("res://General/Scenes/MainMenu.tscn")
