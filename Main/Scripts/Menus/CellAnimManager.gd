extends AnimationPlayer

var last_anim = ""
func _ready():
	$".".play("fade_in")
	last_anim = "fade_in"
	
func hide_and_stop():
	if last_anim != "fade_out":
		$".".play("fade_out", 0.5)
		last_anim = "fade_out"

func show_and_play():
	if last_anim != "fade_in":
		$".".play("fade_in", 0.5)
		last_anim = "fade_in"