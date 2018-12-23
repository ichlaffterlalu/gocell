extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var v = 0

onready var player1 = get_node("../../Player")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	v = player1.stamina
	self.text = str(v)
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func setVar(value):
	v = value