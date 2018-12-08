extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal game_change_status(active_status)
signal need_restart()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$PopupDialog/Settings.toggle(true)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func toggle(status):
	if not status and self.is_visible_in_tree():
		$PopupDialog.fade_out()
	elif status and not self.is_visible_in_tree():
		self.show()
		$PopupDialog.fade_in()
		$PopupDialog.popup_centered()

func _on_PopupDialog_fade_out_finished():
	$PopupDialog.hide() # replace with function body
	self.hide()
	emit_signal("game_change_status", true)

func _on_Close_pressed():
	self.toggle(false) # replace with function body


func _need_restart():
	emit_signal("need_restart")
