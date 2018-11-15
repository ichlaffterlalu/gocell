extends ColorRect

signal fade_finished

func fade_in():
	$FadeInAnimation.play("fade_in")
	
func _on_FadeInAnimation_animation_finished(anim_name):
	emit_signal("fade_finished")