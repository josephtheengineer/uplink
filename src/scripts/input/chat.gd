extends Control
#warning-ignore:unused_class_variable
const meta := {
	script_name = "input.chat",
	type = "impure",
	description = """
		
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
	"/full-reset - resets Uplink back to its default state",
	"/break - executes a breakpoint",
	"/quit - exits Uplink",
	"/get-var system(Client, Server, Chunk, Download, Input, Interface, Sound) path(path.to.var)",
	"/init-vr - enables stereoscopic output and head tracking"
]


func _ready():
	var node = Core.get_node("/root/World/Systems/Input")
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
		Core.Server.send_message(input)
		return
	
	input = input.substr(1)
	if enter_is_char:
		input = input.replace(">", "")
	else:
		input = input.replace("\n", "")
	var cmd
	if " " in input:
		cmd = input.split(" ", false)[0]
	else:
		if enter_is_char:
			cmd = input.replace(">", "")
		else:
			cmd = input.replace("\n", "")
	
	match cmd:
		"help":
			help()
		"demo":
			Core.emit_signal("msg", "Running demo preset...", Core.INFO, meta)
			msg("Running demo preset...", meta)
			Core.get_parent().get_node("World/Interfaces/Hud/Hud/Background").visible = false
			#reset()
			Core.emit_signal("system_process_start", "server.bootup")
			Core.emit_signal("system_process_start", "client.connect")
			Core.emit_signal("system_process_start", "client.spawn")
		"voxel-editor":
			Core.emit_signal("msg", "Opening voxel editor...", Core.INFO, meta)
			msg("Opening voxel editor...", meta)
			Core.get_parent().get_node("World/Interfaces/Hud/Hud/Background").visible = false
			reset()
			Core.emit_signal("system_process_start", "server.bootup")
			Core.emit_signal("system_process_start", "client.connect")
			Core.emit_signal("system_process_start", "client.spawn")
		"test-world":
			#reset()
			#yield(get_tree().create_timer(2), "timeout")
			Core.get_parent().get_node("World/Interfaces/Hud/Hud/Background").visible = false
			Core.Server.data.map.path = "user://worlds/empty.eden"
			Core.Server.data.map.seed = 0
			Core.emit_signal("system_process_start", "server.bootup")
			Core.emit_signal("system_process_start", "client.connect")
			Core.emit_signal("system_process_start", "client.spawn")
		"host": # host(world_path, port=8888, max_players=100)
			var args = input.split(" ", false)
			if args.size() < 2 or args.size() > 4:
				invalid_command_usage(cmd)
				return
			
			Core.Server.data.map.path = args[1]
			Core.emit_signal("msg", "map.path = " + str(args[1]), Core.INFO, meta)
			if args.size() > 2:
				Core.Server.data.port = args[2]
				Core.emit_signal("msg", "port = " + str(args[2]), Core.INFO, meta)
			if args.size() > 3:
				Core.Server.data.max_players = args[3]
				Core.emit_signal("msg", "max_players = " + str(args[3]), Core.INFO, meta)
			Core.emit_signal("system_process_start", "server.bootup")
			
		"connect": # connect(username, host=127.0.0.1, port=8888)
			Core.get_parent().get_node("World/Interfaces/Hud/Hud/Background").visible = false
			var args = input.split(" ", false)
			if args.size() < 2 or args.size() > 4:
				invalid_command_usage(cmd)
				return
			
			Core.emit_signal("msg", "players[" + str(args[1]) + "] added", Core.INFO, meta)
			Core.Client.data.subsystem.input.Link.data.player = args[1]
			if args.size() > 2:
				Core.Client.data.host.host = args[2]
				Core.emit_signal("msg", "host = " + str(args[2]), Core.INFO, meta)
			if args.size() > 3:
				Core.Server.data.host.port = args[3]
				Core.emit_signal("msg", "port = " + str(args[3]), Core.INFO, meta)
			
			reset()
			Core.emit_signal("system_process_start", "client.connect")
			Core.emit_signal("system_process_start", "client.spawn")
			#Core.emit_signal("system_process_start", "client.print_world_stats")
		"tp": # tp(x, y, z)
			var args = input.split(" ", false)
			if args.size() != 4:
				invalid_command_usage(cmd)
				return
			var player_name = Core.Client.data.subsystem.input.Link.data.player
			var player = Core.get_parent().get_node("World/Inputs/" + player_name)
			var teleport_vector := Vector3()
			
			if args[1] == "~":
				teleport_vector.x = player.get_node("Player").translation.x
			else:
				teleport_vector.x = float(args[1])
			
			if args[2] == "~":
				teleport_vector.y = player.get_node("Player").translation.y
			else:
				teleport_vector.y =  float(args[2])
			
			if args[3] == "~":
				teleport_vector.z = player.get_node("Player").translation.z
			else:
				teleport_vector.x =  float(args[3])
			
			player.get_node("Player").translation = teleport_vector
		"full-reset": # full-reset()
			Core.get_parent().get_node("World/Interfaces/Hud/Hud/Background").visible = true
			reset()
		"break": # break()
			breakpoint
		"quit": # quit()
			Core.get_tree().quit()
		"get-var": # get_var(sys, path)
			var args = input.split(" ", false)
			if args.size() != 3:
				invalid_command_usage(cmd)
				return
			get_var(args)
		"init-vr":
			#print(ARVRServer.get_interfaces())
			var arvr_interface = ARVRServer.find_interface("Native mobile")
			if arvr_interface and arvr_interface.initialize():
				get_viewport().arvr = true
		_:
			if cmd == null:
				msg("Please provide a command string", meta)
				Core.emit_signal("msg", "Please provide a command string", Core.WARN, meta)
			else:
				invalid_command(cmd)

func get_var(args: Array):
	var sys = Core.get_parent().get_node("World/Systems/" + args[1])
	var data = Core.scripts.dictionary.main.get_from_dict(sys.data, args[2].split("."))
	msg(args[1] + ": " + args[2] + " = " + str(data), meta)
	Core.emit_signal("msg", args[1] + ": " + args[2] + " = " + str(data), Core.INFO, meta)

func invalid_command(cmd: String):
	msg("Invalid command " + cmd, meta)
	Core.emit_signal("msg", "Invalid command " + cmd, Core.WARN, meta)

func invalid_command_usage(cmd: String):
	msg("Invalid useage of " + cmd + "! Missing required argument(s): " + str(commands), meta)
	Core.emit_signal("msg", "Invalid useage of " + cmd + "! Missing required argument(s): " + str(commands), Core.WARN, meta)

func help():
	msg("Available commands: ", meta)
	Core.emit_signal("msg", "Available commands: ", Core.INFO, meta)
	for cmd in commands:
		msg(cmd, meta)
		Core.emit_signal("msg", cmd, Core.INFO, meta)

func reset():
	Core.emit_signal("msg", "Deleting entities...", Core.INFO, meta)
	if Core.get_parent().has_node("World/Chunks"):
		for c in Core.get_parent().get_node("World/Chunks").get_children():
			remove_child(c)
			c.queue_free()
	if Core.get_parent().has_node("World/Inputs"):
		for c in Core.get_parent().get_node("World/Inputs").get_children():
			remove_child(c)
			c.queue_free()
	Core.emit_signal("msg", "Reseting system databases...", Core.INFO, meta)
	Core.emit_signal("reset")
