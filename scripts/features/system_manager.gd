#warning-ignore:unused_class_variable
const script_name = "system_manager"
var Debug = preload("res://scripts/features/debug.gd").new()

const CHUNK = 0
const CLIENT = 1
const DOWNLOAD = 2
const INPUT = 3
const INTERFACE = 4
const SERVER = 5
const SOUND = 6

func setup(): ##################################################################
	var error = Core.connect("system_ready", self, "_on_system_ready")
	if error:
		emit_signal("msg", "Error on binding to system_ready: " + str(error), Debug.WARN, self)

func _on_system_ready(system: int, obj: Object): ###############################
	match system:
		CHUNK:
			if Core.Client.chunk:
				Core.emit_signal("msg", "Chunk System ready called when already registered", Debug.WARN, self)
			else:
				Core.Client.ChunkSystem = obj
				Core.Client.chunk = true
				Core.emit_signal("msg", "Chunk System ready.", Debug.INFO, self)
		CLIENT:
			if Core.Client.client:
				Core.emit_signal("msg", "Client System ready called when already registered", Debug.WARN, self)
			else:
				Core.Client.client = true
				Core.emit_signal("msg", "Client System ready.", Debug.INFO, self)
		DOWNLOAD:
			if Core.Client.download:
				Core.emit_signal("msg", "Download System ready called when already registered", Debug.WARN, self)
			else:
				Core.Client.DownloadSystem = obj
				Core.Client.download = true
				Core.emit_signal("msg", "Download System ready.", Debug.INFO, self)
		INPUT:
			if Core.Client.input:
				Core.emit_signal("msg", "Input System ready called when already registered", Debug.WARN, self)
			else:
				Core.Client.InputSystem = obj
				Core.Client.input = true
				Core.emit_signal("msg", "Input System ready.", Debug.INFO, self)
		INTERFACE:
			if Core.Client.interface:
				Core.emit_signal("msg", "Interface System ready called when already registered", Debug.WARN, self)
			else:
				Core.Client.InterfaceSystem = obj
				Core.Client.interface = true
				Core.emit_signal("msg", "Interface System ready.", Debug.INFO, self)
		SERVER:
			if Core.Client.server:
				Core.emit_signal("msg", "Server System ready called when already registered", Debug.WARN, self)
			else:
				Core.Client.server = true
				Core.emit_signal("msg", "Server System ready.", Debug.INFO, self)
		SOUND:
			if Core.Client.sound:
				Core.emit_signal("msg", "Sound System ready called when already registered", Debug.WARN, self)
			else:
				Core.Client.SoundSystem = obj
				Core.Client.sound = true
				Core.emit_signal("msg", "Sound System ready.", Debug.INFO, self)
		_:
			Core.emit_signal("msg", "Unknown system bootup", Debug.WARN, self)
	Core.emit_signal("msg", str(get_online_systems()) + " of " + str(Core.Client.TOTAL_SYSTEMS) + " Systems online", Debug.INFO, self)
	if get_online_systems() == Core.Client.TOTAL_SYSTEMS:
		Core.emit_signal("app_ready")

func get_online_systems(): #####################################################
	var online = 0
	if Core.Client.chunk:
		online+=1
	if Core.Client.client:
		online+=1
	if Core.Client.download:
		online+=1
	if Core.Client.input:
		online+=1
	if Core.Client.interface:
		online+=1
	if Core.Client.server:
		online+=1
	if Core.Client.sound:
		online+=1
	return online

func check_systems(): ##########################################################
	var offline = []
	if !Core.Client.chunk:
		Core.emit_signal("msg", "Chunk System offline", Debug.WARN, self)
		offline.append(CHUNK)
	if !Core.Client.client:
		Core.emit_signal("msg", "Client System offline", Debug.WARN, self)
		offline.append(CLIENT)
	if !Core.Client.download:
		Core.emit_signal("msg", "Download System offline", Debug.WARN, self)
		offline.append(DOWNLOAD)
	if !Core.Client.input:
		Core.emit_signal("msg", "Input System offline", Debug.WARN, self)
		offline.append(INPUT)
	if !Core.Client.interface:
		Core.emit_signal("msg", "Interface System offline", Debug.WARN, self)
		offline.append(INTERFACE)
	if !Core.Client.server:
		Core.emit_signal("msg", "Server System offline", Debug.WARN, self)
		offline.append(SERVER)
	if !Core.Client.sound:
		Core.emit_signal("msg", "Sound System offline", Debug.WARN, self)
		offline.append(SOUND)
	return offline
