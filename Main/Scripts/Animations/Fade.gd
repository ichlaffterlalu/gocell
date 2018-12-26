extends Node

signal fade_in_finished
signal fade_out_finished

func fade_in():
	$FadeAnimation.play("fade_in")
	self.show()

func fade_out():
	$FadeAnimation.play("fade_out")

func toggle(status):
	#print(status)
	if not status and self.is_visible_in_tree():
		fade_out()
	elif status and not self.is_visible_in_tree():
		fade_in()

func _on_FadeAnimation_animation_finished(anim_name):
	if anim_name == "fade_in":
		emit_signal("fade_in_finished")
	elif anim_name == "fade_out":
		self.hide()
		emit_signal("fade_out_finished")