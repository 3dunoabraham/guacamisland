extends Control

onready var certificate_sound_clip = load("res://import/audio/action/pageturn1.wav")
onready var input_change = load("res://import/audio/ticks/ticking clock - tick4.wav")

signal island_row_mouse_entered
signal island_row_mouse_exited
signal island_row_play_clicked

export (PackedScene) var island_row = load("res://scenes/partials/island_row.tscn")

onready var islandlist_list = get_node("container/panel 2/islandlist_panel/margin/islandlist_container/control/islandlist_list")
onready var map_location = get_node("container/map/map_location")

var islandlist = {}

func _ready():
	AUDIO_MANAGER.set_regular_button_sfx()
	islandlist = GLOBAL.game_data.levels
	map_location.hide()
	fill_island_list()

func _on_go_main_menu_button_pressed():
	return get_tree().change_scene(GLOBAL.title_screen)

func fill_island_list():	
	var _conx = connect("island_row_mouse_entered", self, "_island_row_mouse_entered")
	_conx = connect("island_row_mouse_exited", self, "_island_row_mouse_exited")
	_conx = connect("island_row_play_clicked", self, "_island_row_play_clicked")
	
	for x in islandlist:
		var a = island_row.instance()
		a.get_node("margin/grid/island_info/island_name_label").text = x.capitalize()
		
		var item_list = a.get_node("margin/grid/island_info/items")
		
		for item in islandlist[x].items_count.keys():
			item_list.add_child(a.get_node("margin/grid/island_info/items/dump").duplicate())
			var new_item = item_list.get_child(item_list.get_child_count()-1)
			
			new_item.get_node("value").text = str(islandlist[x].items_count[item])
			
			new_item.get_node("icon").texture = load("res://import/2d/icons/"+item+"_sm.png")
			
			new_item.show()
			
			
		
		if islandlist[x].certificate:
			a.get_node("certificate").show()
		else:
			a.get_node("certificate").hide()
			
		a.island_data = islandlist[x]
		islandlist_list.add_child(a)

func _island_row_mouse_entered(event):
	AUDIO_MANAGER.play_sfx(input_change, 0, -15)
	event.border_panel.show()
	map_location.show()
func _island_row_mouse_exited(event):
	event.border_panel.hide()
	map_location.hide()
func _island_row_play_clicked(event):
	var world = "margarita"
#	var world = event.island_data.name
	if !event.island_data.certificate:
		TRANSITION.change_scene("res://levels/"+world+"/"+world+"_certificate.tscn")
	else:
		TRANSITION.change_scene("res://levels/"+world+"/"+world+"_hub.tscn")
