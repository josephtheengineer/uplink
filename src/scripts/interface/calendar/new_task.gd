extends ScrollContainer
#warning-ignore:unused_class_variable
const meta := {
	script_name = "interface.calendar.new_task",
	type = "impure",
	description = """
		
	"""
}

#var path = "HBoxContainer/VBox/Dates"
#var good_num_daily_effort = 4 # hours
var path = "HBoxContainer/VBox/Content/"

func _on_button_pressed():
	var task = Core.scripts.calendar.tasks.task_template.duplicate(true)
	if get_text("Name") != "":
		task.name = get_text("Name")
	
	if get_text("TimeAllocation") != "":
		task.time_allocation = get_text("TimeAllocation")
	
	if get_text("DueDate") != "":
		task.due_date = get_text("DueDate")
	
	if get_text("Urgency") != "":
		task.urgency = get_text("Urgency")
	
	if get_text("Difficulty") != "":
		task.difficulty = get_text("Difficulty")
	
	if get_text("Enjoyability") != "":
		task.enjoyability = get_text("Enjoyability")
	
	if get_text("Types") != "":
		task.types = get_text("Types")
	
	if get_text("Projects") != "":
		task.projects = get_text("Projects")
	
	if get_text("Notes") != "":
		task.notes = get_text("Notes")
	
	if get_text("Recur") != "":
		task.recur = get_text("Recur")
	
	if get_text("Timeslot") != "":
		task.timeslot = get_text("Timeslot")
	
	Core.scripts.calendar.task.create_task(task)

func get_text(name: String):
	return get_node(path + name + "/TextEdit").text
