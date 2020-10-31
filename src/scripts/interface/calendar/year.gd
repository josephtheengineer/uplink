extends Control
#warning-ignore:unused_class_variable
const meta := {
	script_name = "interface.calendar.year",
	type = "impure",
	description = """
		
	"""
}

const YEAR_WIDTH = 10
const YEAR_HEIGHT = 3

const WIDTH = 8
const HEIGHT = 7

const YEAR_MARGIN_X = 180
const YEAR_MARGIN_Y = 180

const MARGIN_X = 10
const MARGIX_Y = 10

#var system_date = OS.get_date()
#var sel_year = system_date.year
#var sel_month = system_date.month
#var sel_day = system_date.day

var months_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

func _ready():
	var date = OS.get_date()
	var title: Button = get_node("HBoxContainer/VBox/Header/Title")
	title.text = str(date.year)
	display_grid(12)

func display_grid(end: int): ##########################
	var i = 0
	for _x in range(YEAR_WIDTH):
		var row = HBoxContainer.new()
		row.size_flags_vertical = Control.SIZE_FILL
		#row.rect_min_size = Vector2(50, 50)
		row.size_flags_horizontal = Control.SIZE_FILL
		get_node("HBoxContainer/VBox/Dates").add_child(row)
		for _y in range(YEAR_HEIGHT):
			if i >= end:
				return
			i += 1
			create_element(row, i)

func create_element(row, text: int):
	return display_grid2(row, text)

func display_grid2(row2, end: int): ##########################
	end = months_days[end-1]
	var dates = VBoxContainer.new()
	dates.size_flags_vertical = Control.SIZE_FILL
	dates.rect_min_size = Vector2(YEAR_MARGIN_X, YEAR_MARGIN_Y)
	dates.size_flags_horizontal = Control.SIZE_FILL
	row2.add_child(dates)
	var i = 0
	for _x in range(WIDTH):
		var row = HBoxContainer.new()
		row.size_flags_vertical = Control.SIZE_FILL
		#row.rect_min_size = Vector2(50, 50)
		row.size_flags_horizontal = Control.SIZE_FILL
		dates.add_child(row)
		for _y in range(HEIGHT):
			if i > end:
				return
			i += 1
			row.add_child(create_element2(i))
	return dates

func create_element2(text: int):
	var element = Label.new()
	element.text = str(text)
	element.rect_min_size = Vector2(MARGIN_X, MARGIX_Y)
	element.size_flags_vertical = Control.SIZE_FILL
	element.size_flags_horizontal = Control.SIZE_FILL
	return element

func remove_children():
	for c in get_children():
		remove_child(c)
		c.queue_free()
