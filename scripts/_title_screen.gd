extends Control

onready var input_change = load("res://import/audio/ticks/ticking clock - tick4.wav")

onready var buttons_panel = get_node("panel container/panel 1")
onready var buttons_animation = buttons_panel.get_node("buttons_animation")
onready var newgame_panel = get_node("panel container/panel 2/newgame_panel")
onready var newgame_animation = newgame_panel.get_node("setting_animation")

onready var inputgroup_gametype = find_node("inputgroup_gametype")
var gametype = "speedrun"
onready var inputgroup_world = find_node("inputgroup_world")
var world = "margarita"

var difficulty = 1
onready var label_difficulty = find_node("label_difficulty")

func _ready():
	AUDIO_MANAGER.set_regular_button_sfx()
	newgame_panel.hide()
	buttons_animation.play("Fade_In")
		

func _on_Button_New_Game_pressed():
	newgame_panel.show()
	newgame_animation.play("Slide In")
func _on_button_cancel_pressed():
	newgame_panel.hide()
	
func _on_button_play_pressed():
	print("")
	print("start_game")
	print("game type: "+gametype)
	print("world: "+world)
	
	GLOBAL.difficulty = difficulty
	
#	return
	return get_tree().change_scene("res://levels/"+gametype+"/"+world+".tscn")

func _on_Button_Tutorial_pressed():	return get_tree().change_scene("res://scenes/tutorial.tscn")


func _on_input_gametype_pressed(buttonName, _isPressed):
	gametype = buttonName
	change_difficulty_label()

func _on_input_speedrun_toggled(button_pressed): _on_input_gametype_pressed("speedrun", button_pressed)
func _on_input_coconutstash_toggled(button_pressed): _on_input_gametype_pressed("coconutstash", button_pressed)
func _on_input_multiplayer_toggled(button_pressed): _on_input_gametype_pressed("multiplayer", button_pressed)

func _on_input_world_pressed(buttonName, _isPressed):
	world = buttonName
	
func _on_input_margarita_toggled(button_pressed): _on_input_world_pressed("margarita", button_pressed)
func _on_input_coche_toggled(button_pressed): _on_input_world_pressed("coche", button_pressed)
func _on_input_cubagua_toggled(button_pressed): _on_input_world_pressed("cubagua", button_pressed)

func _on_input_difficulty_value_changed(value):
	AUDIO_MANAGER.play_sfx(input_change, 0, -15)
	difficulty = value
	change_difficulty_label()
	
func change_difficulty_label():
	if	gametype == "speedrun":		label_difficulty.text = "Laps: "+str(difficulty)
	if	gametype == "coconutstash":		label_difficulty.text = "Stash size: "+str(difficulty)
		

func _on_Button_Exit_pressed():	return get_tree().quit()



