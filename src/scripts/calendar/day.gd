extends Control
#warning-ignore:unused_class_variable
const meta := {
	script_name = "calendar.day",
	type = "impure",
	description = """
		
	"""
}

var path := "HBoxContainer/VBox/Dates"

func _ready():
	var date = OS.get_date()
	#print(date)
	var title: Button = get_node("HBoxContainer/VBox/Header/Title")
	title.text = str(date.year) + " " + str(date.month) + " " + str(date.day)
	
	
	var tasks := Array()
	var task := Dictionary()
	task.name = "Lmao"
	task.start = 5
	task.end = 6
	tasks.append(task)
	
	setup(tasks)

func setup(tasks: Array):
	for task in tasks:
		var child = ColorRect.new()
		child.size_flags_vertical = Control.SIZE_FILL
		child.rect_min_size = Vector2(50, 50)
		child.size_flags_horizontal = Control.SIZE_FILL
		get_node(path).add_child(child)

#func add_task(name: String, start: int, end: int):
#	pass
