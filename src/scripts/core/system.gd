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
	if Core.Client.data.subsystem.chunk.online:
		online+=1
	if Core.Client.data.online:
		online+=1
	if Core.Client.data.subsystem.download.online:
		online+=1
	if Core.Client.data.subsystem.input.online:
		online+=1
	if Core.Client.data.subsystem.interface.online:
		online+=1
	if Core.Server.data.online:
		online+=1
	if Core.Client.data.subsystem.sound.online:
		online+=1
	return online

static func check_systems(): ###################################################
	var offline = []
	if !Core.Client.data.subsystem.chunk.online:
		Core.emit_signal("msg", "Chunk System offline", Core.WARN, meta)
		offline.append(CHUNK)
	if !Core.Client.data.online:
		Core.emit_signal("msg", "Client System offline", Core.WARN, meta)
		offline.append(CLIENT)
	if !Core.Client.data.subsystem.download.online:
		Core.emit_signal("msg", "Download System offline", Core.WARN, meta)
		offline.append(DOWNLOAD)
	if !Core.Client.data.subsystem.input.online:
		Core.emit_signal("msg", "Input System offline", Core.WARN, meta)
		offline.append(INPUT)
	if !Core.Client.data.subsystem.interface.online:
		Core.emit_signal("msg", "Interface System offline", Core.WARN, meta)
		offline.append(INTERFACE)
	if !Core.Server.data.online:
		Core.emit_signal("msg", "Server System offline", Core.WARN, meta)
		offline.append(SERVER)
	if !Core.Client.data.subsystem.sound.online:
		Core.emit_signal("msg", "Sound System offline", Core.WARN, meta)
		offline.append(SOUND)
	return offline
