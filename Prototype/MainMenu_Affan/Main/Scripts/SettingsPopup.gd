extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$PopupDialog/Settings._on_Button_pressed()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Button_pressed():
	if $PopupDialog.is_visible_in_tree():
		$PopupDialog.fade_out()
	else:
		$PopupDialog.fade_in()
		$PopupDialog.popup_centered()


func _on_PopupDialog_fade_out_finished():
	$PopupDialog.hide() # replace with function body
