extends Node
var Debug = load("res://scripts/features/debug.gd").new()
onready var Events
onready var ClientSystem

const CHUNK = 0
const CLIENT = 1
const DOWNLOAD = 2
const INPUT = 3
const INTERFACE = 4
const SERVER = 5
const SOUND = 6

func setup(events, client_system):
	Events = events
	ClientSystem = client_system
	Events.connect("system_ready", self, "_on_system_ready")

func _on_system_ready(system):
	match system:
		CHUNK:
			if ClientSystem.chunk:
				Debug.msg("Chunk System ready called when already registered", "Warn")
			else:
				ClientSystem.chunk = true
				Debug.msg("Chunk System ready.", "Info")
		CLIENT:
			if ClientSystem.client:
				Debug.msg("Client System ready called when already registered", "Warn")
			else:
				ClientSystem.client = true
				Debug.msg("Client System ready.", "Info")
		DOWNLOAD:
			if ClientSystem.download:
				Debug.msg("Download System ready called when already registered", "Warn")
			else:
				ClientSystem.download = true
				Debug.msg("Download System ready.", "Info")
		INPUT:
			if ClientSystem.input:
				Debug.msg("Input System ready called when already registered", "Warn")
			else:
				ClientSystem.input = true
				Debug.msg("Input System ready.", "Info")
		INTERFACE:
			if ClientSystem.interface:
				Debug.msg("Interface System ready called when already registered", "Warn")
			else:
				ClientSystem.interface = true
				Debug.msg("Interface System ready.", "Info")
		SERVER:
			if ClientSystem.server:
				Debug.msg("Server System ready called when already registered", "Warn")
			else:
				ClientSystem.server = true
				Debug.msg("Server System ready.", "Info")
		SOUND:
			if ClientSystem.sound:
				Debug.msg("Sound System ready called when already registered", "Warn")
			else:
				ClientSystem.sound = true
				Debug.msg("Sound System ready.", "Info")
		_:
			Debug.msg("Unknown system bootup", "Warn")
	Debug.msg(str(get_online_systems()) + " of " + str(ClientSystem.TOTAL_SYSTEMS) + " Systems online", "Info")
	if get_online_systems() == ClientSystem.TOTAL_SYSTEMS:
		Events.emit_signal("app_ready")

func get_online_systems():
	var online = 0
	if ClientSystem.chunk:
		online+=1
	if ClientSystem.client:
		online+=1
	if ClientSystem.download:
		online+=1
	if ClientSystem.input:
		online+=1
	if ClientSystem.interface:
		online+=1
	if ClientSystem.server:
		online+=1
	if ClientSystem.sound:
		online+=1
	return online

func check_systems():
	var offline = []
	if !ClientSystem.chunk:
		Debug.msg("Chunk System offline", "Warn")
		offline.append(CHUNK)
	if !ClientSystem.client:
		Debug.msg("Client System offline", "Warn")
		offline.append(CLIENT)
	if !ClientSystem.download:
		Debug.msg("Download System offline", "Warn")
		offline.append(DOWNLOAD)
	if !ClientSystem.input:
		Debug.msg("Input System offline", "Warn")
		offline.append(INPUT)
	if !ClientSystem.interface:
		Debug.msg("Interface System offline", "Warn")
		offline.append(INTERFACE)
	if !ClientSystem.server:
		Debug.msg("Server System offline", "Warn")
		offline.append(SERVER)
	if !ClientSystem.sound:
		Debug.msg("Sound System offline", "Warn")
		offline.append(SOUND)
	return offline