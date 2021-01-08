extends Node
#warning-ignore:unused_class_variable
const meta := {
	script_name = "interface.status",
	type = "impure",
	description = """
		
	"""
}

onready var display: RichTextLabel = get_node("VBox/HBox/Display")
onready var status_display: RichTextLabel = get_node("VBox/HBox/Status")
onready var scroll_bar: VScrollBar = get_node("VBox/HBox/VScrollBar")

func update():
	var data: Dictionary = Core.data.status
	var new_data := ""
	var status := ""
	
	for process in data:
		new_data += process + ':\n'
		status += '\n'
		for step in data[process]:
			new_data += '    [color=grey]' + step + '[/color]\n'
			
			if data[process][step] == 'success':
				status += '[color=lime]' + data[process][step] + '[/color]\n'
			else:
				status += '[color=red]' + data[process][step] + '[/color]\n'
				var i = 0
				while true:
					i+=12
					if i < data[process][step].length():
						new_data += '\n'
					else:
						break
	
	display.bbcode_text = new_data
	status_display.bbcode_text = status
	scroll_bar.max_value = new_data.split('\n').size() - 15
	scroll_bar.page = 1

func _on_button_pressed():
	update()


func _on_scroll_bar_scrolling():
	display.scroll_to_line(scroll_bar.value)
	status_display.scroll_to_line(scroll_bar.value)
	
