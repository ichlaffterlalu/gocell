extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Button_pressed():
	if $TabContainer.is_visible_in_tree():
		$TabContainer.fade_out()
	else:
		$TabContainer.fade_in()
		self.show()
		$TabContainer.show()


func _on_TabContainer_fade_out_finished():
	$TabContainer.hide() # replace with function body
	self.hide()
