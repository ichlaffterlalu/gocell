extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var tree = $MainPage/Main/Container/Scroll/VBoxContainer/FastestRaces
	tree.set_column_title(0, "Player Name")
	tree.set_column_title(1, "Date/Time")
	tree.set_column_title(2, "Race Time")
	tree.set_column_title(3, "Mode")
	tree.set_column_title(4, "Map Name")
	tree.set_column_titles_visible(true)
	var root = tree.create_item()
	for x in range(10):
		var child = tree.create_item(root)
		child.set_text(0, "a")
		child.set_text(1, "a")
		child.set_text(2, "a")
		child.set_text(3, "a")
		child.set_text(4, "a")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
