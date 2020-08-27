extends Control
#warning-ignore:unused_class_variable
const meta := {
	script_name = "calendar.schedule",
	type = "impure",
	description = """
		
	"""
}

var path = "HBoxContainer/VBox/Dates"
#var good_num_daily_effort = 4 # hours

const task_template = {
	name = "Get a life",
	time_allocation = "1h",
	due_date = "5w",
	urgency = "M",
	difficulty = "M",
	enjoyability = "M",
	types = ["writing", "creative"],
	dependencies = -1,
	projects = ["catalyst", "calendar", "docs"],
	notes = "",
	recur = "no",
	timeslot = "2d 10->11"
}

func _ready():
	#print("Hello?")
	var tasks = Array()
	tasks.append(task_template)
	
	for task in tasks:
		var dates: Label = get_node(path)
		dates.text += task.name + '\n' + str(task) + '\n'

#func create_task(task: Dictionary):
#	pass
