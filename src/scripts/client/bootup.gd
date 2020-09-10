#warning-ignore:unused_class_variable
const meta := {
	script_name = "client.bootup",
	type = "process",
	steps = [
		"bring_systems_online",
		"check_systems",
		"run_diagnostics",
		"load_interface"
	],
	description = """
		
	"""
}

# systems bootup ###############################################################
static func bring_systems_online():
	Core.emit_signal("system_process", meta, "bring_systems_online", true)
	Core.scripts.core.debug.msg.init(Core.Client.data.log_path)
	Core.scripts.core.system.setup()
	
	# Wait for nodes to init (wait until there is an idle frame)
	yield(Core.get_tree(), "idle_frame")
	
	create_chunk_system()
	create_download_system()
	create_input_system()
	create_interface_system()
	create_sound_system()
	
	yield(Core.get_tree(), "idle_frame")
	
	Core.emit_signal("system_process", meta, "bring_systems_online")

static func create_chunk_system(): #############################################
	Core.emit_signal("msg", "Creating chunk system...", Core.DEBUG, meta)
	var node = Node.new()
	node.set_name("Chunk")
	node.set_script(load("res://src/scripts/sys/chunk.gd"))
	Core.get_node("/root/World/Systems").add_child(node)


static func create_download_system(): ##########################################
	Core.emit_signal("msg", "Creating download system...", Core.DEBUG, meta)
	var node = Node.new()
	node.set_name("Download")
	node.set_script(load("res://src/scripts/sys/download.gd"))
	Core.get_node("/root/World/Systems").add_child(node)


static func create_input_system(): #############################################
	Core.emit_signal("msg", "Creating input system...", Core.DEBUG, meta)
	var node = Node.new()
	node.set_name("Input")
	node.set_script(load("res://src/scripts/sys/input.gd"))
	Core.get_node("/root/World/Systems").add_child(node)


static func create_interface_system(): #########################################
	Core.emit_signal("msg", "Creating interface system...", Core.DEBUG, meta)
	var node = Node.new()
	node.set_name("Interface")
	node.set_script(load("res://src/scripts/sys/interface.gd"))
	Core.get_node("/root/World/Systems").add_child(node)


static func create_sound_system(): #############################################
	Core.emit_signal("msg", "Creating sound system...", Core.DEBUG, meta)
	var node = Node.new()
	node.set_name("Sound")
	node.set_script(load("res://src/scripts/sys/sound.gd"))
	Core.get_node("/root/World/Systems").add_child(node)
################################################################################



################################################################################
static func check_systems():####################################################
	Core.emit_signal("system_process", meta, "check_systems", true)
	Core.scripts.core.system.check_systems()
	Core.emit_signal("msg", "App ready!", Core.INFO, meta)
	Core.emit_signal("system_process", meta, "check_systems")
################################################################################



################################################################################
static func run_diagnostics(): #################################################
	Core.emit_signal("system_process", meta, "run_diagnostics", true)
	Core.scripts.core.debug.diagnostics.run("system_process", meta, "run_diagnostics")
################################################################################



# remove tty, create hud #######################################################
static func load_interface():
	Core.emit_signal("system_process", meta, "load_interface", true)
	Core.get_parent().get_node("World/Interfaces/0").free()
	Core.scripts.interface.hud.create()
	Core.emit_signal("system_process", meta, "load_interface")
################################################################################
