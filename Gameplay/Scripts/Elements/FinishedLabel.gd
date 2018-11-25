extends "res://Main/Scripts/Animations/Fade.gd"

signal finished_waiting()
signal start_game()

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var status = 0 # 0 for unfinished, 1 for lose, 2 for win
var time = 0
var rank = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$VBox/Statistics.hide()
	$FadeAnimation.play("countdown_start")
	self.show()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Player_lose(player_node):
	if self.is_visible_in_tree():
		$FadeAnimation.play("fade_in")
		self.show()
	else:
		$FadeAnimation.stop()
	$VBox/WinLose.text = "Player " + str(player_node.id) + " Lose!"
	$VBox/Statistics.text = "Player " + str(player_node.id) + " finished 2nd\nwith total time of " + str(player_node.finish_time/1000) + "s!"
	emit_signal("finished_waiting")
	
func _on_Player_waiting():
	$FadeAnimation.play("countdown_lose")
	self.show()

func _on_Player_win(player_node):
	$VBox/WinLose.text = "Player " + str(player_node.id) + " Win!"
	$VBox/Statistics.text = "Player " + str(player_node.id) + " finished 1st\nwith total time of " + str(player_node.finish_time/1000) + "s!"
	$FadeAnimation.play("fade_in")
	self.show()
	

func _on_FadeAnimation_animation_finished(anim_name):
	._on_FadeAnimation_animation_finished(anim_name)
	if anim_name == "countdown_start":
		emit_signal("start_game")
		$FadeAnimation.play("fade_out")
		$VBox/Statistics.show()
	elif anim_name == "countdown_lose":
		print($VBox/Statistics.text)
		emit_signal("finished_waiting")


