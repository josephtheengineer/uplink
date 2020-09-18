extends Control
#warning-ignore:unused_class_variable
const meta := {
	script_name = "catalyst.main",
	type = "impure",
	description = """
		lack direction?
	"""
}

var mode = "none"
var index = 0

func _ready():
	var node = Core.get_node("/root/World/Systems/Input")
	node.connect("chat_input", self, "_chat_input")

func msg(message: String, _meta: Dictionary):
	var chat = get_node("RichTextLabel")
	chat.text += message + '\n'

func _chat_input(box: TextEdit, input: String):
	if not "\n" in input:
		return
	if not visible:
		return
	box.text = ""
	
	msg("> " + input, meta)
	
	if mode == "start_day":
		start_day(input)
		return
	
	if "start" in input and "day" in input:
		msg("Starting start day routine...", meta)
		var time = OS.get_time()
		msg("Good morning, it is currently " + str(time.hour) + ":" +str(time.minute), meta)
		start_day(input)
		mode = "start_day"
	elif "hello" in input or "hi" in input or "o/" in input or "hey" in input or "yo" in input:
		msg("hello! how are you doing today?", meta)
	elif "not" in input and "bad" in input:
		msg("thats great to hear!\n", meta)
	elif "bad" in input or "suck" in input:
		msg("awwww thats no good, what happened?", meta)
	elif "good" in input and "not" in input:
		msg("awwww thats no good, what happened?", meta)
	elif "good" in input and not "bad" in input and not "not" in input:
		msg("thats great to hear!", meta)
	elif "ikr" in input and not "bad" in input and not "not" in input:
		msg("those are definitely rare", meta)
	else:
		msg("What was that?", meta)

func start_day(input: String):
	var day_options = {
		projects = []
	}
	match index:
		0:
			msg("What projects do you want to work on today?", meta)
		1:
			day_options.projects = input.split(" ", false)
		2:
			mode = "none"
			index = 0
	index += 1
