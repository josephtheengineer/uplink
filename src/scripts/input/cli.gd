#warning-ignore:unused_class_variable
const meta := {
	script_name = "input.cli",
	description = """
		Generic methods for the cli
	"""
}



# input.cli.call_cli ###########################################################
const call_cli_meta := {
	func_name = "input.cli.call_cli",
	description = """
		Calls cli method
	""",
		text_input = [],
		enter_is_char = false }
static func call_cli(args := call_cli_meta) -> void: ###########################
	var text_path
	
	if args.enter_is_char:
		text_path = args.text_input.replace(">", "")
	else:
		text_path = args.text_input.replace("\n", "")
		text_path = text_path.replace("/", "")
	
	if " " in args.text_input:
		text_path = text_path.split(" ", false)[0]
	
	var func_arguments = args.text_input.split(" ", false)
	var script_path: Array = text_path.split(".", false)
	script_path.pop_back()
	
	# get script
	var script = Core.scripts.core.dictionary.main.get_from_dict(Core.scripts, script_path)
	var func_name = text_path.split(".", false)[-1]
	
	if typeof(script) != TYPE_OBJECT or not script.new().has_method(func_name):
		Core.scripts.input.cli.invalid_command({ cmd = text_path })
		return
	
	var func_meta = script.get(str(func_name) + "_meta")
	var dict_args = {}
	
	var script_args = Array(func_arguments)
	script_args.pop_front()
	for arg in script_args:
		arg = arg.split("=", false)
		var argument_name = arg[0]
		var argument_value = arg[1]
		
		if func_meta.has(argument_name):
			if typeof(func_meta[argument_name]) == TYPE_ARRAY:
				argument_value = argument_value.split(",", false)
			elif typeof(func_meta[argument_name]) == TYPE_INT:
				argument_value = int(argument_value)
			
			dict_args[argument_name] = argument_value
	
	#script.call(func_name, dict_args)
	Core.run(text_path, dict_args)
# ^ input.cli.call_cli #########################################################



# input.cli.help ###############################################################
const help_meta := {
	func_name = "input.cli.help",
	description = """
		Prints help infomation
	""",
		command = "" }
static func help(args := help_meta) -> void: ###################################
	Core.emit_signal("msg", "Available commands: ", Core.INFO, args)
	for cmd in Core.scripts.input.chat.commands:
		Core.emit_signal("msg", cmd, Core.INFO, args)
# ^ input.cli.help #############################################################



# input.cli.run_demo ###########################################################
const run_demo_meta := {
	func_name = "input.cli.run_demo",
	description = """
		Runs a demo for new users
	""",
		port = 500,
		world = "",
		username = "user",
		error = false } 
static func run_demo(args := run_demo_meta) -> void: ###########################
	Core.emit_signal("msg", "Running demo preset...", Core.INFO, args)
	Core.scripts.input.cli.reset()
	Core.emit_signal("system_process_start", "server.bootup")
	Core.emit_signal("system_process_start", "client.connect")
	Core.emit_signal("system_process_start", "client.spawn")
	Core.world.get_node("Interface/Hud/Hud/Background").visible = false
# ^ input.cli.run_demo #########################################################



# input.cli.reset ##############################################################
const reset_meta := {
	func_name = "input.cli.reset",
	description = """
		Resets all systems
	""",
		}
static func reset(args := reset_meta) -> void: #################################
	Core.world.get_node("Interface/Hud/Hud/Background").visible = true
	Core.emit_signal("msg", "Deleting chunks...", Core.INFO, args)
	if Core.world.has_node("Chunk"):
		for c in Core.world.get_node("Chunk").get_children():
			Core.remove_child(c)
			c.queue_free()
	Core.emit_signal("msg", "Deleting players...", Core.INFO, args)
	if Core.world.has_node("Input"):
		for c in Core.world.get_node("Input").get_children():
			Core.remove_child(c)
			c.queue_free()
	Core.emit_signal("msg", "Reseting system databases...", Core.INFO, args)
	Core.emit_signal("reset")
# ^ input.cli.reset ############################################################



# input.cli.launch_voxel_editor ################################################
const launch_voxel_editor_meta := {
	func_name = "input.cli.launch_voxel_editor",
	description = """
		Loades a specialised world for edditing voxels on a block
	""",
		}
static func launch_voxel_editor(args := launch_voxel_editor_meta) -> void: #####
	Core.emit_signal("msg", "Opening voxel editor...", Core.INFO, args)
	Core.world.get_node("Interface/Hud/Hud/Background").visible = false
	Core.scripts.input.cli.reset()
	Core.world.get_node("Interface/Hud/Hud/Background").visible = false
	
	# Make the world generator generate 1 block only
	Core.server.data.map.generator.single_voxel = true
	
	Core.emit_signal("system_process_start", "server.bootup")
	Core.emit_signal("system_process_start", "client.connect")
	Core.emit_signal("system_process_start", "client.spawn")
	
	# Get the set player from the input system
	var player_name = Core.client.data.subsystem.input.Link.data.player
	var player = Core.world.get_node("Input/" + player_name)
	
	# Set the edit mode on the player to voxels
	player.components.action.resolution = 16 # RES_2
	
	# Tp the player to the correct position
	player.get_node("Player").translation = Vector3(4, 8, 7)
# ^ input.cli.launch_voxel_editor ##############################################



# input.cli.launch_test_world ################################################
const launch_test_world_meta := {
	func_name = "input.cli.launch_test_world",
	description = """
		Loads a world designed to test the voxel engine
	""",
		}
static func launch_test_world(args := launch_test_world_meta) -> void: #########
	Core.emit_signal("msg", "Opening test-world...", Core.INFO, args)
	Core.scripts.input.cli.reset()
	#yield(get_tree().create_timer(2), "timeout")
	Core.world.get_node("Interface/Hud/Hud/Background").visible = false
	Core.server.data.map.path = "user://world/empty.eden"
	Core.server.data.map.seed = 0
	Core.emit_signal("system_process_start", "server.bootup")
	Core.emit_signal("system_process_start", "client.connect")
	Core.emit_signal("system_process_start", "client.spawn")
# ^ input.cli.launch_test_world ################################################



# input.cli.host ###############################################################
const host_meta := {
	func_name = "input.cli.host",
	description = """
		Hosts a world_file online
	""",
		world_path = "",
		port = "8888",
		max_players = "100" }
static func host(args := host_meta) -> void: ###################################
	Core.Server.data.map.path = args.world_path
	Core.emit_signal(
		"msg", "map.path = " + str(args.world_path),
		Core.INFO, meta )
	
	Core.Server.data.port = args.port
	Core.emit_signal(
		"msg", "port = " + str(args.port),
		Core.INFO, meta )
		
	Core.Server.data.max_players = args.max_players
	Core.emit_signal(
		"msg",
		"max_players = " + str(args.max_players),
		Core.INFO, meta )
	
	Core.emit_signal("system_process_start", "server.bootup")
# ^ input.cli.host #############################################################



# input.cli.connect_world ######################################################
const connect_world_meta := {
	func_name = "input.cli.connect_world",
	description = """
		Connects Core world to a server
	""",
		username = "",
		host = "127.0.0.1",
		port = "8888" }
static func connect_world(args := connect_world_meta) -> void: #################
	Core.world.get_node("Interface/Hud/Hud/Background").visible = false
	
	Core.emit_signal(
		"msg", "players[" + str(args.username) + "] added",
		Core.INFO, meta )
	
	Core.Client.data.subsystem.input.Link.data.player = args.username

	Core.Client.data.host.host = args.host
	Core.emit_signal(
		"msg", "host = " + str(args.host),
		Core.INFO, meta )

	Core.Server.data.host.port = args.port
	Core.emit_signal(
		"msg", "port = " + str(args.port),
		Core.INFO, meta )
	
	Core.scripts.input.cli.reset()
	Core.emit_signal("system_process_start", "client.connect")
	Core.emit_signal("system_process_start", "client.spawn")
	#Core.emit_signal("system_process_start", "client.print_world_stats")
# ^ input.cli.connect_world ####################################################



# input.cli.tp #################################################################
const tp_meta := {
	func_name = "input.cli.tp",
	description = """
		Teleports the player
	""",
		x = "~",
		y = "~",
		z = "~" }
static func tp(args := tp_meta) -> void: #######################################
	var player_name = Core.Client.data.subsystem.input.Link.data.player
	var player = Core.world.get_node("Input/" + player_name)
	var teleport_vector := Vector3()
	
	if args.x == "~":
		teleport_vector.x = player.get_node("Player").translation.x
	else:
		teleport_vector.x = float(args.x)
	
	if args.y == "~":
		teleport_vector.y = player.get_node("Player").translation.y
	else:
		teleport_vector.y =  float(args.y)
	
	if args.z == "~":
		teleport_vector.z = player.get_node("Player").translation.z
	else:
		teleport_vector.x =  float(args.z)
	
	player.get_node("Player").translation = teleport_vector
# ^ input.cli.tp ###############################################################



# input.cli.break ##############################################################
const break_meta := {
	func_name = "input.cli.break",
	description = """
		A breakpoint
	"""
		}
static func break(args := break_meta) -> void: #################################
	Core.emit_signal("msg", "Executing breakpoint...", Core.INFO, args)
	breakpoint
# ^ input.cli.break ############################################################



# input.cli.quit ###############################################################
const quit_meta := {
	func_name = "input.cli.quit",
	description = """
		Quits Uplink
	"""
		}
static func quit(args := quit_meta) -> void: ###################################
	Core.emit_signal("msg", "Quit command recieved!", Core.FATAL, args)
# ^ input.cli.quit #############################################################



# input.cli.get_var ############################################################
const get_var_meta := {
	func_name = "input.cli.get_var",
	description = """
		Gets a var from storage
	""",
		args = [] }
static func get_var(args := get_var_meta) -> void: #############################
	var sys = Core.world.get_node(args.args[1])
	if sys:
		var data = Core.scripts.dictionary.main.get_from_dict(
			sys.data, args.args[2].split(".") )
		
		Core.emit_signal("msg", args[1] + ": " + args[2] + " = " + 
			str(data), Core.INFO, meta )
# ^ input.cli.get_var ##########################################################



# input.cli.init_vr ############################################################
const init_vr_meta := {
	func_name = "input.cli.init_vr",
	description = """
		Enables steroscopic output + head tracking
	"""
		}
static func init_vr(args := init_vr_meta) -> void: #############################
	Core.emit_signal("msg", "Initializing ARVR Interface...", Core.DEBUG, args)
	#print(ARVRServer.get_interfaces())
	var arvr_interface = ARVRServer.find_interface("Native mobile")
	if arvr_interface and arvr_interface.initialize():
		Core.get_viewport().arvr = true
# ^ input.cli.init_vr ##########################################################



# input.cli.invalid_command ####################################################
const invalid_command_meta := {
	func_name = "input.cli.invalid_command",
	description = """
		Output a message for an invalid command
	""",
		cmd = "" }
static func invalid_command(args := invalid_command_meta) -> void: #############
	Core.emit_signal("msg", "Invalid command " + args.cmd, Core.WARN, meta)
# ^ input.cli.invalid_command ##################################################

# input.cli.create_alias #######################################################
const create_alias_meta := {
	func_name = "input.cli.create_alias",
	description = """
		Stores a alias to a file
	""",
		name = "",
		value = "" }
static func create_alias(args := create_alias_meta) -> void: ###################
	var text = args.name + "=" + args.value + '\n'
	
	var file = File.new()
	if !file.file_exists("user://data.txt"):
		Core.emit_signal("msg", "No file to write to", Core.ERROR, args)
	elif file.open("user://data.txt", File.WRITE) != 0:
		Core.emit_signal("msg", "Error while writing to file", Core.ERROR, args)
	else:
		file.seek_end()
		file.store_line(text)
		file.close()
# ^ input.cli.create_alias #####################################################
