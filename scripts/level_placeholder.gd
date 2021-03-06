extends Spatial

onready var pause_screen = get_node("../pause_screen")

onready var goals = get_node("Goals")
var current_goal_index = 0;
var goal_list = [
	"goal_ring 1",
	"goal_ring 2",
	"goal_ring 3",
	"goal_ring 4",
	"goal_ring 5",
	"goal_ring 6",
	"goal_ring 7",
	"goal_ring 8",
	"goal_ring 9",
	"goal_ring 10",
	"goal_ring 11",
	"goal_ring 12",
	"goal_ring 13",
	"goal_ring 14",
	"goal_ring 15",
	"goal_ring 16",
	"goal_ring 17",
	"goal_ring 18",
	"goal_ring 19",
];

onready var level_timer: Timer = find_node("general_timer")

onready var player = get_node("../Spawn/Player")
export (PackedScene) var coconut_item = preload("res://assets/entities/coconut_item.tscn")
onready var entities_container = get_node("Entities")

var coconut_count = 0
onready var coconut_count_label = find_node("coconut_count")

func _ready():
	player.level = self
	pause_screen.current_scene = "res://scenes/tutorial_test.tscn"
	
	goals.show()
	for x in goals.get_children():
		x.hide()
		
	var current_goal = goals.get_node(goal_list[current_goal_index])
	current_goal.show()
	current_goal.connect("body_shape_entered", player, "_on_goal_ring_body_shape_entered")


func goal_hit():	
	if	current_goal_index == 0:
		level_timer.start()
		
	var current_goal = goals.get_node(goal_list[current_goal_index])
	print(current_goal.name)
	current_goal.hide()
	current_goal.disconnect("body_shape_entered", player, "_on_goal_ring_body_shape_entered")
	
	current_goal_index += 1
	
	if current_goal_index < len(goal_list):
		current_goal = goals.get_node(goal_list[current_goal_index])
		current_goal.show()
		current_goal.connect("body_shape_entered", player, "_on_goal_ring_body_shape_entered")
	else:
		level_timer.stop()

func _fire_coconut(global_transform):
	var a = coconut_item.instance()
	a.transform.origin = global_transform.origin
	entities_container.add_child(a)
	print(entities_container.get_children())
	
func _add_coconut_to_player():
	coconut_count += 1
	coconut_count_label.text = str(coconut_count)
