extends "res://Main/Scripts/Base/SceneFade.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var fastest_races = $MainPage/Main/Container/Scroll/VBoxContainer/FastestRaces

func _ready():
	ready_fade()
	# Called when the node is added to the scene for the first time.
	# Initialization here
	_init_fastest_races()
	_init_fastest_players()

func _init_fastest_races():
	fastest_races.set_column_title(0, "Player Name")
	fastest_races.set_column_title(1, "Date/Time")
	fastest_races.set_column_title(2, "Time (s)")
	fastest_races.set_column_title(3, "Mode")
	fastest_races.set_column_title(4, "Map Name")
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
	pass