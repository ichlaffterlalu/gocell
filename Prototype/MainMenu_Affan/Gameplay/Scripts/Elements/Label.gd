extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var v = 0

onready var player1 = get_node("../../Player")
onready var player2 = get_node("../../Player2")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if self.get_parent() == player1:
		v = "Stamina = %d" % player1.stamina
	if self.get_parent() == player2:
		v = "Stamina = %d" % player2.stamina
	self.text = str(v)
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func setVar(value):
	v = value