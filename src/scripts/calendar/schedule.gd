extends Control
#warning-ignore:unused_class_variable
const meta := {
	script_name = "calendar.schedule",
	type = "impure",
	description = """
		
	"""
}

const TASKS_FOLDER = "user://tasks/"

var path = "HBoxContainer/VBox/Dates"
#var good_num_daily_effort = 4 # hours

var task_template = {
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

#func _ready():
#	var tasks = []
#
#	tasks.append(create_task(task_template, "### WEDNESDAY ###"))
#	tasks.append(create_task(task_template, "projects: 201 (c#) & uplink"))
#	#tasks.append(create_task(task_template, "18:00 > Building (NEEDS TEMP UI)"))
#	#tasks.append(create_task(task_template, "19:00 > Destroying (NEEDS MAJOR REFACTOR)"))
#	tasks.append(create_task(task_template, "19:00 > Get color UVs working"))
#	tasks.append(create_task(task_template, "22:00 > Atoms"))
#	tasks.append(create_task(task_template, "> 3D UI system (REQUIRES ATOMS)"))
#	tasks.append(create_task(task_template, "Chill + lunch"))
#	tasks.append(create_task(task_template, "12:00 > CAB201 Life"))
#	tasks.append(create_task(task_template, "Chill"))
#	tasks.append(create_task(task_template, "> Radio"))
#	tasks.append(create_task(task_template, "14:00 > Fix warnings"))
#
#	tasks.append(create_task(task_template, "### THURSDAY ###"))
#	tasks.append(create_task(task_template, "projects: 207 (web) & uplink"))
#	tasks.append(create_task(task_template, "Web assignment / IAB207 Task 2 Web prototype"))
#	tasks.append(create_task(task_template, "Chill + lunch"))
#	tasks.append(create_task(task_template, "22:00 > MCL Chat Connection"))
#	tasks.append(create_task(task_template, "12:00 > Calendar / tasks"))
#
#	tasks.append(create_task(task_template, "### FRIDAY ###"))
#	tasks.append(create_task(task_template, "projects: 240(security) & uplink"))
#	tasks.append(create_task(task_template, "12:00 > 240 Security Part 2"))
#	tasks.append(create_task(task_template, "> TBD"))
#	tasks.append(create_task(task_template, "Chill + lunch"))
#	tasks.append(create_task(task_template, "> Catalyst"))
#	tasks.append(create_task(task_template, "> TBD"))
#	tasks.append(create_task(task_template, "12:00 > Chat filter"))
#	tasks.append(create_task(task_template, "14:00 IRC"))
#
#	tasks.append(create_task(task_template, "### SATURDAY ###"))
#	tasks.append(create_task(task_template, "projects: 202(c) & uplink"))
#	tasks.append(create_task(task_template, "202 AMS"))
#	tasks.append(create_task(task_template, "MCL Get World"))
#	tasks.append(create_task(task_template, "> TBD"))
#	tasks.append(create_task(task_template, "> TBD"))
#
#	tasks.append(create_task(task_template, "### SUNDAY ###"))
#	tasks.append(create_task(task_template, "Custom blocks (Atom templates)"))
#
#	tasks.append(create_task(task_template, "### MONDAY2 ###"))
#	tasks.append(create_task(task_template, "UI for custom blocks"))
#
#	tasks.append(create_task(task_template, "### TUESDAY2 ###"))
#	tasks.append(create_task(task_template, "Catalyst Speak"))
#	tasks.append(create_task(task_template, "Catalyst Hear"))
#
#	tasks.append(create_task(task_template, "### WEDNESDAY2 ###"))
#
#	tasks.append(create_task(task_template, "### THURSDAY2 ###"))
#	tasks.append(create_task(task_template, "Phone VR"))
#
#	tasks.append(create_task(task_template, "### FRIDAY2 ###"))
#	tasks.append(create_task(task_template, "ssh"))
#	tasks.append(create_task(task_template, "gnupg"))
#	tasks.append(create_task(task_template, "git"))
#
#	tasks.append(create_task(task_template, "### SATURDAY2 ###"))
#	tasks.append(create_task(task_template, "video player"))
#	tasks.append(create_task(task_template, "browser"))
#
#	tasks.append(create_task(task_template, "### SUNDAY2 ###"))
#	tasks.append(create_task(task_template, "infinity"))
#
#	tasks.append(create_task(task_template, "import tasks"))
#
#	var dates: Label = get_node(path)
#	var text = ""
#
#	var header := 0
#	for i in range(tasks.size()):
#		if "###" in tasks[i].name:
#			text +=  '\n' + tasks[i].name + '\n' #+ str(tasks[i]) + '\n'
#			header += 1
#		else:
#			text += str(i-header) + ". " + tasks[i].name + '\n' #+ str(tasks[i]) + '\n'
#	dates.text = text

func create_task(task: Dictionary, name: String):
	var dir = Directory.new()
	if !dir.file_exists(TASKS_FOLDER):
		dir.make_dir(TASKS_FOLDER)
	for key in task.keys():
		if !dir.file_exists(TASKS_FOLDER):
			dir.make_dir(TASKS_FOLDER)

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true)
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		files.append(file)
	
	dir.list_dir_end()
	
	return files
