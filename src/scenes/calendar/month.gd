extends Control
var script_name := "calendar_month"

const WIDTH = 8
const HEIGHT = 7

const MARGIN_X = 50
const MARGIX_Y = 50

var system_date = OS.get_date()
var sel_year = system_date.year
var sel_month = system_date.month
var sel_day = system_date.day

var months_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

func _ready():
	var date = OS.get_date()
	print(date)
	get_node("HBoxContainer/VBox/Header/Title").text = str(date.year) + " " + str(date.month)
	display_grid(months_days[date.month-1])

func display_grid(end: int): ##########################
	var i = 0
	for x in range(WIDTH):
		var row = HBoxContainer.new()
		row.size_flags_vertical = Control.SIZE_FILL
		#row.rect_min_size = Vector2(50, 50)
		row.size_flags_horizontal = Control.SIZE_FILL
		get_node("HBoxContainer/VBox/Dates").add_child(row)
		for y in range(HEIGHT):
			if i > end:
				return
			i += 1
			row.add_child(create_element(i))

func create_element(date: int):
	var element = Label.new()
	if date == system_date.day:
		pass
	element.text = str(date)
	element.rect_min_size = Vector2(MARGIN_X, MARGIX_Y)
	element.size_flags_vertical = Control.SIZE_FILL
	element.size_flags_horizontal = Control.SIZE_FILL
	return element

func remove_children():
	for c in get_children():
		remove_child(c)
		c.queue_free()
