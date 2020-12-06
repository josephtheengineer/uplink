#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.system_manager",
	description = """
		
	"""
}

const CHUNK = 0
const CLIENT = 1
const DOWNLOAD = 2
const INPUT = 3
const INTERFACE = 4
const SERVER = 5
const SOUND = 6


# core.system_manager.setup ####################################################
const setup_meta := {
	func_name = "core.system_manager.setup",
	description = """
		
	""",
		}
static func setup(args := setup_meta) -> void: #################################
	var error = Core.connect("system_ready", Core, "_on_system_ready_fancy")
	if error:
		Core.emit_signal("msg", "Error on binding to system_ready: " + str(error), Core.WARN, args)
# ^ core.system_manager.setup ##################################################


# core.system_manager.get_online_systems #######################################
const get_online_systems_meta := {
	func_name = "core.system_manager.get_online_systems",
	description = """
		
	""",
		}
static func get_online_systems(args := get_online_systems_meta) -> int: ########
	var online = 0
	if Core.client.data.subsystem.chunk.online:
		online+=1
	if Core.client.data.online:
		online+=1
	if Core.client.data.subsystem.download.online:
		online+=1
	if Core.client.data.subsystem.input.online:
		online+=1
	if Core.client.data.subsystem.interface.online:
		online+=1
	if Core.server.data.online:
		online+=1
	if Core.client.data.subsystem.sound.online:
		online+=1
	return online
# ^ core.system_manager.get_online_systems #####################################


# core.system_manager.check_systems ############################################
const check_systems_meta := {
	func_name = "core.system_manager.check_systems",
	description = """
		
	""",
		}
static func check_systems(args := check_systems_meta) -> Array: ################
	var offline = []
	if !Core.client.data.subsystem.chunk.online:
		Core.emit_signal("msg", "Chunk System offline", Core.WARN, args)
		offline.append(CHUNK)
	if !Core.client.data.online:
		Core.emit_signal("msg", "Client System offline", Core.WARN, args)
		offline.append(CLIENT)
	if !Core.client.data.subsystem.download.online:
		Core.emit_signal("msg", "Download System offline", Core.WARN, args)
		offline.append(DOWNLOAD)
	if !Core.client.data.subsystem.input.online:
		Core.emit_signal("msg", "Input System offline", Core.WARN, args)
		offline.append(INPUT)
	if !Core.client.data.subsystem.interface.online:
		Core.emit_signal("msg", "Interface System offline", Core.WARN, args)
		offline.append(INTERFACE)
	if !Core.server.data.online:
		Core.emit_signal("msg", "Server System offline", Core.WARN, args)
		offline.append(SERVER)
	if !Core.client.data.subsystem.sound.online:
		Core.emit_signal("msg", "Sound System offline", Core.WARN, args)
		offline.append(SOUND)
	return offline
# ^ core.system_manager.check_systems ##########################################


# core.system_manager.ready_fancy ##############################################
const ready_fancy_meta := {
	func_name = "core.system_manager.ready_fancy",
	description = """
		
	""",
		}
static func ready_fancy(system: int, obj: Object, args := ready_fancy_meta) -> void: 
	match system:
		CHUNK:
			if !obj:
				Core.emit_signal("msg", "Chunk System ready called with a null object", Core.ERROR, args)
			elif Core.client.data.subsystem.chunk.online:
				Core.emit_signal("msg", "Chunk System ready called when already registered", Core.WARN, args)
			else:
				Core.client.data.subsystem.chunk.Link = obj
				Core.client.data.subsystem.chunk.online = true
				Core.emit_signal("msg", "Chunk System ready.", Core.INFO, args)
		CLIENT:
			if !obj:
				Core.emit_signal("msg", "Client System ready called with a null object", Core.ERROR, args)
			elif Core.client.data.online:
				Core.emit_signal("msg", "Client System ready called when already registered", Core.WARN, args)
			else:
				Core.client.data.online = true
				Core.emit_signal("msg", "Client System ready.", Core.INFO, args)
		DOWNLOAD:
			if !obj:
				Core.emit_signal("msg", "Download System ready called with a null object", Core.ERROR, args)
			elif Core.client.data.subsystem.download.online:
				Core.emit_signal("msg", "Download System ready called when already registered", Core.WARN, args)
			else:
				Core.client.data.subsystem.download.Link = obj
				Core.client.data.subsystem.download.online = true
				Core.emit_signal("msg", "Download System ready.", Core.INFO, args)
		INPUT:
			if !obj:
				Core.emit_signal("msg", "Input System ready called with a null object", Core.ERROR, args)
			elif Core.client.data.subsystem.input.online:
				Core.emit_signal("msg", "Input System ready called when already registered", Core.WARN, args)
			else:
				Core.client.data.subsystem.input.Link = obj
				Core.client.data.subsystem.input.online = true
				Core.emit_signal("msg", "Input System ready.", Core.INFO, args)
		INTERFACE:
			if !obj:
				Core.emit_signal("msg", "Interface System ready called with a null object", Core.ERROR, args)
			elif Core.client.data.subsystem.interface.online:
				Core.emit_signal("msg", "Interface System ready called when already registered", Core.WARN, args)
			else:
				Core.client.data.subsystem.interface.Link = obj
				Core.client.data.subsystem.interface.online = true
				Core.emit_signal("msg", "Interface System ready.", Core.INFO, args)
		SERVER:
			if !obj:
				Core.emit_signal("msg", "Server System ready called with a null object", Core.ERROR, args)
			elif Core.server.data.online:
				Core.emit_signal("msg", "Server System ready called when already registered", Core.WARN, args)
			else:
				Core.server.data.online = true
				Core.emit_signal("msg", "Server System ready.", Core.INFO, args)
		SOUND:
			if !obj:
				Core.emit_signal("msg", "Sound System ready called with a null object", Core.ERROR, args)
			elif Core.client.data.subsystem.sound.online:
				Core.emit_signal("msg", "Sound System ready called when already registered", Core.WARN, args)
			else:
				Core.client.data.subsystem.sound.Link = obj
				Core.client.data.subsystem.sound.online = true
				Core.emit_signal("msg", "Sound System ready.", Core.INFO, args)
		_:
			if !obj:
				Core.emit_signal("msg", "Unknown system called ready with a null object", Core.ERROR, args)
			else:
				Core.emit_signal("msg", "Unknown system bootup", Core.WARN, args)
	Core.emit_signal("msg", str(get_online_systems()) + " of " + str(Core.client.TOTAL_SYSTEMS) + " Systems online", Core.INFO, args)
	if get_online_systems() == Core.client.TOTAL_SYSTEMS:
		Core.emit_signal("app_ready")
# ^ core.system_manager.ready_fancy ############################################
