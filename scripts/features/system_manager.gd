extends Node
var Debug = load("res://scripts/features/debug.gd").new()
onready var Events = get_node("/root/Events")
onready var ClientSystem = get_node("/root/World/Systems/Client")

const CHUNK = 0
const CLIENT = 1
const DOWNLOAD = 2
const INPUT = 3
const INTERFACE = 4
const SERVER = 5
const SOUND = 6

func setup():
	Events.connect("system_ready", self, "_on_system_ready")

func _on_system_ready(system):
	match system:
		CHUNK:
			ClientSystem.chunk = true
		CLIENT:
			ClientSystem.client = true
		DOWNLOAD:
			ClientSystem.download = true
		INPUT:
			ClientSystem.input = true
		INTERFACE:
			ClientSystem.interface = true
		SERVER:
			ClientSystem.server = true
	Debug.msg(str(get_online_systems()) + " Systems online", "Info")

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
	return online