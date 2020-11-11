extends Control
#warning-ignore:unused_class_variable
const meta := {
	script_name = "input.chat",
	type = "impure",
	description = """
		syntax:
		> system command function var1=value1 var2=value2
		Core.system.path.to.function({var1=value1, var2=value2})
		Core.cmd(system command function var1=value1 var2=value2)
	"""
}

const commands = [
	"/help - show this help menu",
	"/demo - open a single player world",
	"/voxel-editor - launch the voxel editor",
	"/test-world - a world for testing the engine",
	"/host world_path port(default=8888) max_players(default=100) - host a server",
	"/connect username host(default=127.0.0.1) port(default=8888) - connect to a server",
	"/tp x y z - teleports the player can subsitute coord for ~",
	"/reset - resets Uplink back to its default state",
	"/break - executes a breakpoint",
	"/quit - exits Uplink",
	"/get-var system(Client, Server, Chunk, Download, Input, Interface, Sound) path(path.to.var)",
	"/init-vr - enables stereoscopic output and head tracking"
]


func _ready():
	var node = Core.get_node("/root/World/Input")
	node.connect("chat_input", self, "_chat_input")
	msg("Welcome to Uplink! To start a demo sequence type /demo or for a list of commands type /help", meta)

func msg(message: String, _meta: Dictionary):
	var chat = get_node("RichTextLabel")
	chat.text += message + '\n'

func _chat_input(box: TextEdit, input: String):
	var enter_is_char = false
	if not "\n" in input and not ">" in input:
		return
	#if not visible:
		#return
	if ">" in input:
		enter_is_char = true
	box.text = ""
	
	msg("> " + input, meta)
	
	if input[0] != '/':
		Core.server.send_message(input)
		return
	
	Core.world.get_node("Input").data.history_line = 0
	
	var file = File.new()
	file.open(Core.client.data.cmd_history_file, File.READ_WRITE)
	file.seek_end()
	file.store_string(input)
	file.close()
	
	Core.scripts.input.cli.call_cli({ text_input = input, enter_is_char = enter_is_char })
	
	#if cmd == null:
	#	msg("Please provide a command string", meta)
	#	Core.emit_signal("msg", "Please provide a command string", Core.WARN, meta)
	#invalid_command(cmd)

func invalid_command_usage(cmd: String):
	msg("Invalid useage of " + cmd + "! Missing required argument(s): " + str(commands), meta)
	Core.emit_signal("msg", "Invalid useage of " + cmd + "! Missing required argument(s): " + str(commands), Core.WARN, meta)
