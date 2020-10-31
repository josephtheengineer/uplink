extends Control
#warning-ignore:unused_class_variable
const meta := {
	script_name = "interface.calendar.hour",
	type = "impure",
	description = """
		
	"""
}

const WIDTH = 8
const HEIGHT = 7

const MARGIN_X = 50
const MARGIX_Y = 50

#var system_date = OS.get_date()
#var sel_year = system_date.year
#var sel_month = system_date.month
#var sel_day = system_date.day

#func _ready():
#	var date = OS.get_date()

func _process(_delta):
	var title: Button = get_node("HBoxContainer/VBox/Header/Title")
	title.text =  "UTC:  " + str(OS.get_time().hour) + " : " + str(OS.get_time().minute) + " : " + str(OS.get_time().second)
	
	var title_local: Button = get_node("HBoxContainer/VBox/HeaderLocal/Title")
	var hour = OS.get_time().hour + 10
	if hour > 24:
		hour -= 24
	title_local.text = "Local:  " + str(hour) + " : " + str(OS.get_time().minute) + " : " + str(OS.get_time().second)

#func start_timer():
#	var timer = Timer.new()
#	timer.connect("timeout", self, "_second")
#	timer.wait_time = 2
#	add_child(timer)
#	timer.start()
