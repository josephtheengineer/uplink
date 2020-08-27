extends Control
#warning-ignore:unused_class_variable
const meta := {
	script_name = "catalyst.main",
	type = "impure",
	description = """
		
	"""
}

func _ready():
	var node = Core.get_node("/root/World/Systems/Input")
	node.connect("chat_input", self, "_chat_input")

func _chat_input(box: TextEdit, input: String):
	if not "\n" in input:
		return
	
	#print(input)
	var chat = get_node("RichTextLabel")
	chat.text += "> " + input
	
	if "hello" in input or "hi" in input or "o/" in input or "hey" in input or "yo" in input:
		chat.text += "hello! how are you doing today?\n"
	elif "not" in input and "bad" in input:
		chat.text += "thats great to hear!\n"
	elif "bad" in input or "suck" in input:
		chat.text += "awwww thats no good, what happened?\n"
	elif "good" in input and "not" in input:
		chat.text += "awwww thats no good, what happened?\n"
	elif "good" in input and not "bad" in input and not "not" in input:
		chat.text += "thats great to hear!\n"
	elif "ikr" in input and not "bad" in input and not "not" in input:
		chat.text += "those are definitely rare\n"
	else:
		chat.text += "What was that?"
	
	box.text = ""
