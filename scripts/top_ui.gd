extends TextureRect

onready var score_label = $MarginContainer/HBoxContainer/VBoxContainer/ScoreLabel
onready var counter_label = $MarginContainer/HBoxContainer/CounterLabel
onready var score_bar = $MarginContainer/HBoxContainer/VBoxContainer/TextureProgress
#onready var goal_container = $MarginContainer/HBoxContainer/HBoxContainer 
onready var goal_container = $"EscañosMarginContainer/EscañosBoxContainer"
export (PackedScene) var goal_prefab
var current_score = 0
var current_counter = 0

func _ready():
	_on_grid_update_score(0)

func _on_grid_update_score(new_value):
	current_score += new_value
	#score_label.text = String(current_score)
	score_label.text = String("%.2f" % get_pertentage_seats(get_total_seats())) + '%'
	update_score_bar()

func _on_grid_update_counter(new_value = -1):
	current_counter += new_value
	counter_label.text = String(current_counter)
	
func setup_score_bar(max_score):
	score_bar.max_value = max_score

func update_score_bar():
	#score_bar.value = current_score
	var escrutinio = get_pertentage_seats(get_total_seats())
	score_bar.value = escrutinio

func get_pertentage_seats(seats):
	return (seats / Utils.MAX_NUMBER_SEATS) * 100

func get_total_seats():
	var current_sum = 0.0
	for i in goal_container.get_child_count():
		current_sum += goal_container.get_child(i).current_number
	return current_sum

func make_goal(goal):
	var current = goal_prefab.instance()
	goal_container.add_child(current)
	current.set_goal_values(goal)

func _on_grid_setup_max_score(max_score):
	setup_score_bar(max_score)

func _on_GoalHolder_create_goal(goal):
	make_goal(goal)

func _on_grid_check_goal(goal_type):
	for i in goal_container.get_child_count():
		goal_container.get_child(i).update_goal_values(goal_type)

func _on_ice_holder_break_ice(goal_type):
	_on_grid_check_goal(goal_type)