extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var player = get_parent()

func _ready():
	pass

func _process(delta):
	self.text = str(player.stamina)
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
