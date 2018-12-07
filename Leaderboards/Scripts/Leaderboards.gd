extends "res://Main/Scripts/Base/SceneFade.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var fastest_races = $MainPage/Main/Container/Scroll/VBoxContainer/FastestRaces
onready var fastest_players = $MainPage/Main/Container/Scroll/VBoxContainer/FastestPlayers

func _ready():
	ready_fade()
	# Called when the node is added to the scene for the first time.
	# Initialization here
	_init_fastest_races()
	_init_fastest_players()

func _init_fastest_races():
	fastest_races.set_column_title(0, "Player Name")
	fastest_races.set_column_min_width(0, 100)
	fastest_races.set_column_title(1, "Date/Time")
	fastest_races.set_column_min_width(1, 120)
	fastest_races.set_column_title(2, "Time (s)")
	fastest_races.set_column_min_width(2, 50)
	fastest_races.set_column_title(3, "Mode")
	fastest_races.set_column_min_width(3, 40)
	fastest_races.set_column_title(4, "Map Name")
	fastest_races.set_column_min_width(4, 90)
	fastest_races.set_column_titles_visible(true)
	var root = fastest_races.create_item()
	var arr = DB.get_records_best_10()
	for row in arr:
		var child = fastest_races.create_item(root)
		var i = 0
		for key in row:
			child.set_text(i, str(row[key]))
			i += 1

func _init_fastest_players():
	fastest_players.set_column_title(0, "Player Name")
	fastest_players.set_column_min_width(0, 200)
	fastest_players.set_column_title(1, "Date/Time")
	fastest_players.set_column_min_width(1, 110)
	fastest_players.set_column_title(2, "Time (s)")
	fastest_players.set_column_min_width(2, 50)
	fastest_players.set_column_titles_visible(true)
	var root = fastest_players.create_item()
	var arr = DB.get_records_player_best_10()
	for row in arr:
		var child = fastest_players.create_item(root)
		var i = 0
		for key in row:
			child.set_text(i, str(row[key]))
			i += 1

func _on_Back_pressed():
	$Fade.fade_in()

func _on_Fade_fade_in_finished():
	get_tree().change_scene("res://Main/Scenes/TitleScreen.tscn")
