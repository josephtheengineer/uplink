#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.system",
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

static func setup(): ###########################################################
	var error = Core.connect("system_ready", Core, "_on_system_ready_fancy")
	if error:
		Core.emit_signal("msg", "Error on binding to system_ready: " + str(error), Core.WARN, meta)

static func get_online_systems(): ##############################################
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

static func check_systems(): ###################################################
	var offline = []
	if !Core.client.data.subsystem.chunk.online:
		Core.emit_signal("msg", "Chunk System offline", Core.WARN, meta)
		offline.append(CHUNK)
	if !Core.client.data.online:
		Core.emit_signal("msg", "Client System offline", Core.WARN, meta)
		offline.append(CLIENT)
	if !Core.client.data.subsystem.download.online:
		Core.emit_signal("msg", "Download System offline", Core.WARN, meta)
		offline.append(DOWNLOAD)
	if !Core.client.data.subsystem.input.online:
		Core.emit_signal("msg", "Input System offline", Core.WARN, meta)
		offline.append(INPUT)
	if !Core.client.data.subsystem.interface.online:
		Core.emit_signal("msg", "Interface System offline", Core.WARN, meta)
		offline.append(INTERFACE)
	if !Core.server.data.online:
		Core.emit_signal("msg", "Server System offline", Core.WARN, meta)
		offline.append(SERVER)
	if !Core.client.data.subsystem.sound.online:
		Core.emit_signal("msg", "Sound System offline", Core.WARN, meta)
		offline.append(SOUND)
	return offline

static func ready_fancy(system: int, obj: Object): ########################
	match system:
		CHUNK:
			if !obj:
				Core.emit_signal("msg", "Chunk System ready called with a null object", Core.ERROR, meta)
			elif Core.client.data.subsystem.chunk.online:
				Core.emit_signal("msg", "Chunk System ready called when already registered", Core.WARN, meta)
			else:
				Core.client.data.subsystem.chunk.Link = obj
				Core.client.data.subsystem.chunk.online = true
				Core.emit_signal("msg", "Chunk System ready.", Core.INFO, meta)
		CLIENT:
			if !obj:
				Core.emit_signal("msg", "Client System ready called with a null object", Core.ERROR, meta)
			elif Core.client.data.online:
				Core.emit_signal("msg", "Client System ready called when already registered", Core.WARN, meta)
			else:
				Core.client.data.online = true
				Core.emit_signal("msg", "Client System ready.", Core.INFO, meta)
		DOWNLOAD:
			if !obj:
				Core.emit_signal("msg", "Download System ready called with a null object", Core.ERROR, meta)
			elif Core.client.data.subsystem.download.online:
				Core.emit_signal("msg", "Download System ready called when already registered", Core.WARN, meta)
			else:
				Core.client.data.subsystem.download.Link = obj
				Core.client.data.subsystem.download.online = true
				Core.emit_signal("msg", "Download System ready.", Core.INFO, meta)
		INPUT:
			if !obj:
				Core.emit_signal("msg", "Input System ready called with a null object", Core.ERROR, meta)
			elif Core.client.data.subsystem.input.online:
				Core.emit_signal("msg", "Input System ready called when already registered", Core.WARN, meta)
			else:
				Core.client.data.subsystem.input.Link = obj
				Core.client.data.subsystem.input.online = true
				Core.emit_signal("msg", "Input System ready.", Core.INFO, meta)
		INTERFACE:
			if !obj:
				Core.emit_signal("msg", "Interface System ready called with a null object", Core.ERROR, meta)
			elif Core.client.data.subsystem.interface.online:
				Core.emit_signal("msg", "Interface System ready called when already registered", Core.WARN, meta)
			else:
				Core.client.data.subsystem.interface.Link = obj
				Core.client.data.subsystem.interface.online = true
				Core.emit_signal("msg", "Interface System ready.", Core.INFO, meta)
		SERVER:
			if !obj:
				Core.emit_signal("msg", "Server System ready called with a null object", Core.ERROR, meta)
			elif Core.server.data.online:
				Core.emit_signal("msg", "Server System ready called when already registered", Core.WARN, meta)
			else:
				Core.server.data.online = true
				Core.emit_signal("msg", "Server System ready.", Core.INFO, meta)
		SOUND:
			if !obj:
				Core.emit_signal("msg", "Sound System ready called with a null object", Core.ERROR, meta)
			elif Core.client.data.subsystem.sound.online:
				Core.emit_signal("msg", "Sound System ready called when already registered", Core.WARN, meta)
			else:
				Core.client.data.subsystem.sound.Link = obj
				Core.client.data.subsystem.sound.online = true
				Core.emit_signal("msg", "Sound System ready.", Core.INFO, meta)
		_:
			if !obj:
				Core.emit_signal("msg", "Unknown system called ready with a null object", Core.ERROR, meta)
			else:
				Core.emit_signal("msg", "Unknown system bootup", Core.WARN, meta)
	Core.emit_signal("msg", str(get_online_systems()) + " of " + str(Core.client.TOTAL_SYSTEMS) + " Systems online", Core.INFO, meta)
	if get_online_systems() == Core.client.TOTAL_SYSTEMS:
		Core.emit_signal("app_ready")
