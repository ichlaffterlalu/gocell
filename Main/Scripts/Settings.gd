extends Control

signal need_restart()

var BUS_MASTER = AudioServer.get_bus_index("Master")
var BUS_MUSIC = AudioServer.get_bus_index("Music")
var BUS_SFX = AudioServer.get_bus_index("SFX")
onready var sfx_control = $TabContainer/Sounds/MarginContainer/Container/Sliders/SFX
onready var master_control = $TabContainer/Sounds/MarginContainer/Container/Sliders/Master
onready var music_control = $TabContainer/Sounds/MarginContainer/Container/Sliders/Music
onready var sound_demo = $AudioSettingSFX
var init_sound_slider = false

var snd_last_play = OS.get_ticks_msec()

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

func _set_bus_vol_percent(bus_idx, vol_percent):
	AudioServer.set_bus_volume_db(bus_idx, 10*log(vol_percent/100))

func _get_vol_percent(bus_idx):
	return exp(AudioServer.get_bus_volume_db(bus_idx)/10) * 100

func _init_sound_controllers():
	sfx_control.value = _get_vol_percent(BUS_SFX)
	master_control.value = _get_vol_percent(BUS_MASTER)
	music_control.value = _get_vol_percent(BUS_MUSIC)
	print("Audio Controls")
	print(sfx_control.value)
	print(master_control.value)
	print(music_control.value)

func toggle(status):
	if not status and self.is_visible_in_tree():
		$TabContainer.fade_out()
		init_sound_slider = false
	elif status and not self.is_visible_in_tree():
		_init_sound_controllers()
		$TabContainer.fade_in()
		self.show()

func _on_TabContainer_fade_out_finished():
	$TabContainer.hide() # replace with function body
	self.hide()

func _on_Master_sound_value_changed(value):
	_set_bus_vol_percent(BUS_MASTER, value)

func _on_SFX_value_changed(value):
	if init_sound_slider:
		var snd_now = OS.get_ticks_msec()
		if (snd_now - snd_last_play > 200):
			sound_demo.play()
			snd_last_play = snd_now
		_set_bus_vol_percent(BUS_SFX, value)
	else:
		init_sound_slider = true

func _on_Music_value_changed(value):
	_set_bus_vol_percent(BUS_MUSIC, value)

func _on_ResetLeaderboards_pressed():
	var dialog = ConfirmationDialog.new()
	dialog.window_title = "Confirm Reset Leaderboards"
	var text = "Reset leaderboards?\n"
	text += "The player records will be erased, but not the player data."
	#text += "The game will be restarted to title screen.\n"
	dialog.dialog_text = text
	dialog.popup_exclusive = true
	dialog.connect("confirmed", self, "_on_ResetLeaderboards_confirmed")
	self.add_child(dialog)
	dialog.popup_centered()

func _on_ResetLeaderboards_confirmed():
	DB.reset_leaderboards()
	emit_signal("need_restart")

func _on_ResetOverallGame_pressed():
	var dialog = ConfirmationDialog.new()
	dialog.window_title = "Confirm Reset Game Data"
	var text = "Reset overall game data?\n"
	text += "All data related to player will be erased."
	#text += "We will delete all player related data, if you confirm."
	dialog.dialog_text = text
	dialog.popup_exclusive = true
	dialog.connect("confirmed", self, "_on_ResetOverallGame_confirmed")
	self.add_child(dialog)
	dialog.popup_centered()

func _on_ResetOverallGame_confirmed():
	DB.reset_game_data()
	emit_signal("need_restart")
