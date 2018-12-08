extends Control

signal game_change_status(active_status)
signal stage_restart()
signal return_to_title_screen()

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
		get_tree().paused = false
		emit_signal("game_change_status", true)
		$PopupDialog.fade_out()
	else:
		get_tree().paused = true
		$PopupDialog.fade_in()
		$PopupDialog.popup_centered()


func _on_Continue_pressed():
	$PopupDialog.fade_out()


func _on_Restart_pressed():
	get_tree().paused = false
	emit_signal("stage_restart")


func _on_Settings_pressed():
	$PopupDialog.fade_out()
	$Settings.toggle(true)


func _on_Return_pressed():
	get_tree().paused = false
	emit_signal("return_to_title_screen")


func _on_PopupDialog_fade_out_finished():
	$PopupDialog.hide()
	if not $Settings.is_visible_in_tree():
		get_tree().paused = false
		emit_signal("game_change_status", true)

func _game_change_status(active_status):
	get_tree().paused = !active_status
	if GameplayVar.is_game_started():
		emit_signal("game_change_status", active_status)
