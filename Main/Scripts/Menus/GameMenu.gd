extends Control

signal stage_restart
signal return_to_title_screen

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

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


func _on_Continue_pressed():
	$PopupDialog.fade_out()


func _on_Restart_pressed():
	emit_signal("stage_restart")


func _on_Settings_pressed():
	$PopupDialog.fade_out()
	$Settings._on_Button_pressed()


func _on_Return_pressed():
	emit_signal("return_to_title_screen")


func _on_PopupDialog_fade_out_finished():
	$PopupDialog.hide()

