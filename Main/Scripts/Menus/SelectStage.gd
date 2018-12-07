extends "res://Main/Scripts/Animations/Fade.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var player_1_group = ButtonGroup.new()
onready var player_2_group = ButtonGroup.new()

var to_gameplay_type = "Gameplay"
signal user_choosed(scene_path)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	for button in $Main/Container/Stages.get_children():
		button.connect("pressed", self, "_on_SceneButton_pressed", [button.scene_to_load])
	_initialize_players_modification()

func _initialize_players_modification():
	var characters = DB.list_characters()
	$Main/Container/Players/Player1/Name.text = Global.player_1_name
	$Main/Container/Players/Player2/Name.text = Global.player_2_name
	for character in characters:
		var button_player_1 = Button.new()
		button_player_1.name = str(character["id"])
		button_player_1.icon = load(character["texture_address"])
		button_player_1.hint_tooltip = "Name: %s\nStamina: %s\nTop Speed: %f\nAcceleration: %f" % [character["name"], character["stamina"], character["top_speed"], character["acceleration"]]
		button_player_1.group = player_1_group
		button_player_1.toggle_mode = true
		if button_player_1.name == str(Global.player_1_character_id):
			button_player_1.pressed = true
		$Main/Container/Players/Player1/Characters.add_child(button_player_1)
		var button_player_2 = Button.new()
		button_player_2.name = str(character["id"])
		button_player_2.icon = load(character["texture_address"])
		button_player_2.hint_tooltip = "Name: %s\nStamina: %s\nTop Speed: %f\nAcceleration%f" % [character["name"], character["stamina"], character["top_speed"], character["acceleration"]]
		button_player_2.group = player_2_group
		button_player_2.toggle_mode = true
		if button_player_2.name == str(Global.player_2_character_id):
			button_player_2.pressed = true
		$Main/Container/Players/Player2/Characters.add_child(button_player_2)
func _on_Button_pressed(gameplay_type="Gameplay"):
	if to_gameplay_type != gameplay_type && self.is_visible_in_tree():
		to_gameplay_type = gameplay_type
	elif self.is_visible_in_tree():
		self.fade_out()
	else:
		to_gameplay_type = gameplay_type
		self.fade_in()
		self.show()
	
	if gameplay_type=="Gameplay":
		$Main/Container/Players/Player2.show()
	elif gameplay_type=="TimeTrial":
		$Main/Container/Players/Player2.hide()

func _on_SceneButton_pressed(path):
	Global.player_1_name = $Main/Container/Players/Player1/Name.text
	Global.player_2_name = $Main/Container/Players/Player2/Name.text
	Global.player_1_character_id = player_1_group.get_pressed_button().name
	Global.player_2_character_id = player_2_group.get_pressed_button().name
	emit_signal("user_choosed", "res://" + to_gameplay_type + "/" + path)
