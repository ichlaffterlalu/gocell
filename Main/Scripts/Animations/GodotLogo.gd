extends "res://Main/Scripts/Animations/Fade.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$FadeAnimation.play("rotate")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_FadeAnimation_animation_finished(anim_name):
	._on_FadeAnimation_animation_finished(anim_name)
	if anim_name == "fade_in":
		$FadeAnimation.play("rotate")

