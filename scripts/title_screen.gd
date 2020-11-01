extends Control

onready var bg_music = load("res://import/audio/background/story time.wav")
onready var input_change = load("res://import/audio/ticks/ticking clock - tick4.wav")
onready var button_hover = load("res://import/audio/interface/Menu Selection Click.wav")

export (PackedScene) var savedgame_row = load("res://scenes/savedgame_row.tscn")

signal savedgame_row_mouse_entered
signal savedgame_row_mouse_exited
signal savedgame_row_clicked

var base_path = "user://"
var base_saves_path = "user://saves/"
var gamelist = []

onready var buttons_animation = get_node("container/panel 1/buttons_animation")
onready var gamelist_panel = get_node("container/panel 2/gamelist_panel")
onready var gamelist_list = find_node("gamelist_list")
onready var gamelist_animation = gamelist_panel.get_node("margin/gamelist_animation")

onready var newgame_name_input = find_node("newgame_name_input")

var gametype = "speedrun"
var world = "margarita"

var difficulty = 1
onready var label_difficulty = find_node("label_difficulty")

func _ready():
	read_gamelist()
	AUDIO_MANAGER.set_regular_button_sfx()
	AUDIO_MANAGER.play_music(bg_music, -15)
	gamelist_panel.hide()
	buttons_animation.play("Fade_In")
	
func read_gamelist():
	var dir = Directory.new()
	if !dir.dir_exists(base_saves_path):
		dir.make_dir(base_saves_path)
		
	dir.open(base_saves_path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			var fileData = File.new()
			var error = fileData.open(base_saves_path+file, File.READ)
			if error == OK:
				var data = fileData.get_var()
				var modified = fileData.get_modified_time(fileData.get_path())
				modified = OS.get_datetime_from_unix_time(modified + OS.get_time_zone_info().bias * 60)
				var last_modified = "%02d/%02d/%02d" % [modified.year, modified.month, modified.day]
				last_modified += " - "
				last_modified += "%02d:%02d:%02d" % [modified.hour, modified.minute, modified.second]
				gamelist.append({
					"name": data.game_name,
					"last_modified": last_modified,
					"size": str(fileData.get_len())+" bytes",
					"data": data,
				})
#				gamelist.append(fileData.get_var())
				fileData.close()

	newgame_name_input.text = "New_Adventure_"+str(gamelist.size() + 1)

	dir.list_dir_end()
	fill_gamelist_list()
			
func fill_gamelist_list():	
	var _conx = connect("savedgame_row_mouse_entered", self, "_savedgame_row_mouse_entered")
	_conx = connect("savedgame_row_mouse_exited", self, "_savedgame_row_mouse_exited")
	_conx = connect("savedgame_row_clicked", self, "_savedgame_row_mouse_clicked")
	
	for x in gamelist:
		var a = savedgame_row.instance()
		a.get_node("margin/grid/game_info/game_name_label").text = x.name
		a.get_node("margin/grid/game_info/file_info/last_modified_label").text = str(x.last_modified)
		a.get_node("margin/grid/game_info/file_info/size_label").text = str(x.size)
		a.game_data = x.data
		gamelist_list.add_child(a)

func _savedgame_row_mouse_entered(event):
	AUDIO_MANAGER.play_sfx(input_change, 0, -15)
	event.index_selector.show()
func _savedgame_row_mouse_exited(event):
	event.index_selector.hide()
func _savedgame_row_mouse_clicked(event):
	GLOBAL.game_data = event.game_data
	return get_tree().change_scene("res://scenes/map_screen.tscn")
	
func _on_newgame_open_button_pressed():
	gamelist_panel.show()
	gamelist_animation.play("Gamelist_SlideIn")
	newgame_name_input.grab_focus()
	gamelist_animation.play("newgame_input_shake")
	newgame_name_input.select_all()
	
func _on_save_newgame_button_pressed():
	var dir = Directory.new()
	if !dir.dir_exists(base_saves_path):
		dir.make_dir(base_saves_path)
	
	var file = File.new()
	var data = {
		"game_name": newgame_name_input.text,
		"levels": {
			"margarita": {
				"certificate": false,
				"time": 0.0,
				"sublevels": {},
			},
		},
	}
	var error = file.open(base_saves_path+newgame_name_input.text+".dat", File.WRITE)
	print("saving new game ("+base_saves_path+newgame_name_input.text+".dat)...")
	if error == OK:
		file.store_var(data)
		file.close()
		print("saved game.")
		
		GLOBAL.game_data = data
		return get_tree().change_scene("res://scenes/map_screen.tscn")
	
func _on_loadgame_open_button_pressed():
	gamelist_panel.show()
	gamelist_animation.play("Gamelist_SlideIn")
	
func _on_Button_Close_pressed(): gamelist_panel.hide()

func _on_tutorial_button_pressed():	return get_tree().change_scene("res://scenes/tutorial.tscn")

func _on_exit_button_pressed():	return get_tree().quit()





