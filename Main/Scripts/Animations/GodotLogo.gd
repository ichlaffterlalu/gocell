extends "res://Main/Scripts/Animations/Fade.gd"

var last_stopped = 0

func _ready():
	$OrbitAnim.play("rotate")