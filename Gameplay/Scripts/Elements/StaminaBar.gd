extends Container

var stam_bars = {}
var MAX_STAM = 0

func init_stam_bars(stamina):
	MAX_STAM = stamina
	var init_stam = $stam_1
	var stam_width = init_stam.get_node("stam_active").texture.get_width() - 1
	stam_bars[1] = init_stam
	for i in range(2, MAX_STAM + 1):
		stam_bars[i] = stam_bars[1].duplicate()
		stam_bars[i].translate(Vector2(stam_width * 1 * (i - 1), 0))
		$".".add_child(stam_bars[i])
	set_position(get_position() + Vector2(-1 * round(stam_width * MAX_STAM / 2), 0))
	
func _ready():
	pass

func _on_Player_add_stam(id):
	var stam_now = stam_bars[id].get_node("stam_active/fill_anim")
	stam_now.stop()
	stam_now.clear_queue()
	stam_now.play("fill_stam")

func _on_Player_delete_stam(id):
	# Remove any progress of the next bar
	if id + 1 <= MAX_STAM:
		var stam_next = stam_bars[id + 1].get_node("stam_active/fill_anim")
		stam_next.stop()
		stam_next.clear_queue()
		stam_next.current_animation = "delete_stam"
		stam_next.seek(1)
	
	# Play animation
	var stam_now = stam_bars[id].get_node("stam_active/fill_anim")
	stam_now.stop()
	stam_now.clear_queue()
	stam_now.play("delete_stam")
