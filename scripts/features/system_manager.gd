extends Node

const CHUNK = 0
const CLIENT = 1
const DOWNLOAD = 2
const INPUT = 3
const INTERFACE = 4
const SERVER = 5
const SOUND = 6

func setup():
	var error = Core.connect("system_ready", self, "_on_system_ready")
	if error:
		emit_signal("msg", "Error on binding to system_ready: " + str(error), "Warn")

func _on_system_ready(system, obj):
	match system:
		CHUNK:
			if Core.Client.chunk:
				Core.emit_signal("msg", "Chunk System ready called when already registered", "Warn")
			else:
				Core.Client.ChunkSystem = obj
				Core.Client.chunk = true
				Core.emit_signal("msg", "Chunk System ready.", "Info")
		CLIENT:
			if Core.Client.client:
				Core.emit_signal("msg", "Client System ready called when already registered", "Warn")
			else:
				Core.Client.client = true
				Core.emit_signal("msg", "Client System ready.", "Info")
		DOWNLOAD:
			if Core.Client.download:
				Core.emit_signal("msg", "Download System ready called when already registered", "Warn")
			else:
				Core.Client.DownloadSystem = obj
				Core.Client.download = true
				Core.emit_signal("msg", "Download System ready.", "Info")
		INPUT:
			if Core.Client.input:
				Core.emit_signal("msg", "Input System ready called when already registered", "Warn")
			else:
				Core.Client.InputSystem = obj
				Core.Client.input = true
				Core.emit_signal("msg", "Input System ready.", "Info")
		INTERFACE:
			if Core.Client.interface:
				Core.emit_signal("msg", "Interface System ready called when already registered", "Warn")
			else:
				Core.Client.InterfaceSystem = obj
				Core.Client.interface = true
				Core.emit_signal("msg", "Interface System ready.", "Info")
		SERVER:
			if Core.Client.server:
				Core.emit_signal("msg", "Server System ready called when already registered", "Warn")
			else:
				Core.Client.server = true
				Core.emit_signal("msg", "Server System ready.", "Info")
		SOUND:
			if Core.Client.sound:
				Core.emit_signal("msg", "Sound System ready called when already registered", "Warn")
			else:
				Core.Client.SoundSystem = obj
				Core.Client.sound = true
				Core.emit_signal("msg", "Sound System ready.", "Info")
		_:
			Core.emit_signal("msg", "Unknown system bootup", "Warn")
	Core.emit_signal("msg", str(get_online_systems()) + " of " + str(Core.Client.TOTAL_SYSTEMS) + " Systems online", "Info")
	if get_online_systems() == Core.Client.TOTAL_SYSTEMS:
		Core.emit_signal("app_ready")

func get_online_systems():
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

func check_systems():
	var offline = []
	if !Core.Client.chunk:
		Core.emit_signal("msg", "Chunk System offline", "Warn")
		offline.append(CHUNK)
	if !Core.Client.client:
		Core.emit_signal("msg", "Client System offline", "Warn")
		offline.append(CLIENT)
	if !Core.Client.download:
		Core.emit_signal("msg", "Download System offline", "Warn")
		offline.append(DOWNLOAD)
	if !Core.Client.input:
		Core.emit_signal("msg", "Input System offline", "Warn")
		offline.append(INPUT)
	if !Core.Client.interface:
		Core.emit_signal("msg", "Interface System offline", "Warn")
		offline.append(INTERFACE)
	if !Core.Client.server:
		Core.emit_signal("msg", "Server System offline", "Warn")
		offline.append(SERVER)
	if !Core.Client.sound:
		Core.emit_signal("msg", "Sound System offline", "Warn")
		offline.append(SOUND)
	return offline