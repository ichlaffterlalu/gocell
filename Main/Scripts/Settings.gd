extends Control

onready var int_bus_master = AudioServer.get_bus_index("Master")
onready var int_bus_music = AudioServer.get_bus_index("Music")
onready var int_bus_sfx = AudioServer.get_bus_index("SFX")
onready var sfx_control = $TabContainer/Sounds/MarginContainer/Container/Sliders/SFX
onready var master_control = $TabContainer/Sounds/MarginContainer/Container/Sliders/Master
onready var music_control = $TabContainer/Sounds/MarginContainer/Container/Sliders/Music
onready var sound_demo = $AudioSettingSFX

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

func toggle(status):
	if not status and self.is_visible_in_tree():
		$TabContainer.fade_out()
	elif status and not self.is_visible_in_tree():
		$TabContainer.fade_in()
		self.show()

func _on_TabContainer_fade_out_finished():
	$TabContainer.hide() # replace with function body
	self.hide()

func set_bus_to_vol_percent(bus_idx, vol_percent):
	AudioServer.set_bus_volume_db(bus_idx, 10*log(vol_percent/100))


func _on_Master_sound_value_changed(value):
	set_bus_to_vol_percent(int_bus_master, value)


func _on_SFX_value_changed(value):
	var snd_now = OS.get_ticks_msec()
	if (snd_now - snd_last_play > 200):
		sound_demo.play()
		snd_last_play = snd_now
	set_bus_to_vol_percent(int_bus_sfx, value)


func _on_Music_value_changed(value):
	set_bus_to_vol_percent(int_bus_music, value)
