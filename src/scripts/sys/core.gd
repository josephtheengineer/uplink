extends Node
#warning-ignore:unused_class_variable
const meta := {
	script_name = "sys.core",
	description = """
		scripts, signals, consts.
		Main hub for infomation flow in Uplink
		This is the only signton in the game, it handles 
		public signals and Client and Server reference
	"""
}
#warning-ignore:unused_class_variable
const scripts := {
	browser = {
		
	},
	calendar = {
		day = preload("res://src/scripts/calendar/day.gd"),
		hour = preload("res://src/scripts/calendar/hour.gd"),
		month = preload("res://src/scripts/calendar/month.gd"),
		schedule = preload("res://src/scripts/calendar/schedule.gd"),
		week = preload("res://src/scripts/calendar/week.gd"),
		year = preload("res://src/scripts/calendar/year.gd")
	},
	catalyst = {
		main = preload("res://src/scripts/catalyst/main.gd")
	},
	chat = {
		discord = {
			
		},
		irc = {
			
		},
		mail = {
			
		},
		item = preload("res://src/scripts/chat/item.gd")
	},
	chunk = {
		generator = preload("res://src/scripts/chunk/generator.gd"),
		geometry = preload("res://src/scripts/chunk/geometry.gd"),
		helper = preload("res://src/scripts/chunk/helper.gd"),
		manager = preload("res://src/scripts/chunk/manager.gd"),
		modify = preload("res://src/scripts/chunk/modify.gd"),
		thread = preload("res://src/scripts/chunk/thread.gd"),
		tools = preload("res://src/scripts/chunk/tools.gd")
	},
	client = {
		network = preload("res://src/scripts/client/network.gd"),
		player = preload("res://src/scripts/client/player.gd")
	},
	core = {
		debug = {
			camera = preload("res://src/scripts/core/debug/camera.gd"),
			diagnostics = preload("res://src/scripts/core/debug/diagnostics.gd"),
			info = preload("res://src/scripts/core/debug/info.gd"),
			msg = preload("res://src/scripts/core/debug/msg.gd"),
			panel = preload("res://src/scripts/core/debug/panel.gd")
		},
		entity = {
			comp = preload("res://src/scripts/core/entity/comp.gd"),
			main = preload("res://src/scripts/core/entity/main.gd")
		},
		manager = preload("res://src/scripts/core/manager.gd"),
		system = preload("res://src/scripts/core/system.gd")
	},
	dictionary = {
		main = preload("res://src/scripts/dictionary/main.gd")
	},
	download = {
		
	},
	eden = {
		block_data = preload("res://src/scripts/eden/block_data.gd"),
		world_decoder = preload("res://src/scripts/eden/world_decoder.gd")
	},
	input = {
		other = preload("res://src/scripts/input/other.gd")
	},
	interface = {
		build_window = preload("res://src/scripts/interface/build_window.gd"),
		hud = preload("res://src/scripts/interface/hud.gd"),
		joystick = preload("res://src/scripts/interface/joystick.gd"),
		tile_map = preload("res://src/scripts/interface/tile_map.gd"),
		toolbox = preload("res://src/scripts/interface/toolbox.gd"),
	},
	radio = {
		
	},
	server = {
		
	},
	sound = {
		
	},
	video = {
		
	},
	vr = {
		
	},
}
#warning-ignore:unused_class_variable
var data := {
	
}

const FATAL = 0
const ERROR = 1
const WARN = 2
const INFO = 3
const DEBUG = 4
const TRACE = 5
const ALL = 6

################################################################################

#warning-ignore:unused_signal
signal system_ready(system, obj)
#warning-ignore:unused_signal
signal entity_loaded(entity)
#warning-ignore:unused_signal
signal request_entity_unload(entity)
#warning-ignore:unused_signal
signal app_ready()
#warning-ignore:unused_signal
signal request_scene_load(scene)
#warning-ignore:unused_signal
signal scene_loaded(scene)
#warning-ignore:unused_signal
signal entity_moved(entity, dir)
#warning-ignore:unused_signal
signal entity_used(entity, amount)
#warning-ignore:unused_signal
signal msg(message, level, obj)
#warning-ignore:unused_signal
signal damage_dealt(target, shooter, weapon_data)
#warning-ignore:unused_signal
signal damage_taken(target, shooter)
#warning-ignore:unused_signal
signal entity_picked_up(picker, entity)
#warning-ignore:unused_signal
signal break_block(block)
#warning-ignore:unused_signal
signal place_block(block)

#warning-ignore:unused_signal
signal gui_loaded(name, entity)
#warning-ignore:unused_signal
signal gui_pushed(name, init_param)

################################################################################

#warning-ignore:unused_class_variable
onready var Client: ClientSystem = get_node("/root/World/Systems/Client")
#warning-ignore:unused_class_variable
onready var Server: ServerSystem = get_node("/root/World/Systems/Server")

var signals = [ "system_ready", "entity_loaded", "request_entity_unload", 
		"app_ready", "request_scene_load", "scene_loaded", 
		"entity_moved", "entity_used", "damage_dealt", 
		"entity_picked_up", "break_block", "place_block", "gui_loaded", 
		"gui_pushed" ]

################################################################################

func _ready(): #################################################################
	for app_signal in signals:
		var error = connect(app_signal, self, "_on_" + app_signal)
		if error:
			emit_signal("msg", "Error on binding to " + app_signal 
				+ ": " + str(error), Core.WARN, meta)


func _on_system_ready(system, obj): ############################################
	emit_signal("msg", "Event system_ready called. system: " + str(system) 
		+ ", obj: " + str(obj), Core.TRACE, meta)


func _on_entity_loaded(entity): ################################################
	emit_signal("msg", "Event entity_loaded called. entity: " 
		+ str(entity), Core.TRACE, meta)


func _on_request_entity_unload(entity): ########################################
	emit_signal("msg", "Event request_entity_unload called. entity: " 
		+ str(entity), Core.TRACE, meta)


func _on_app_ready(): ##########################################################
	emit_signal("msg", "Event app_ready called", Core.TRACE, meta)


func _on_request_scene_load(scene): ############################################
	emit_signal("msg", "Event request_scene_load called. scene: " 
		+ str(scene), Core.TRACE, meta)


func _on_scene_loaded(scene): ##################################################
	emit_signal("msg", "Event scene_loaded called. scene: " + str(scene), 
		Core.TRACE, meta)


func _on_entity_moved(entity, dir): ############################################
	emit_signal("msg", "Event entity_moved called. entity: " + str(entity) 
		+ ", dir: " + str(dir), Core.TRACE, meta)


func _on_entity_used(entity, amount): ##########################################
	emit_signal("msg", "Event entity_used called. entity: " + str(entity) 
		+ ", amount: " + str(amount), Core.TRACE, meta)


func _on_damage_dealt(target, shooter, weapon_data): ###########################
	emit_signal("msg", "Event damage_dealt called. target: " + str(target) 
		+ ", shooter: " + str(shooter) + ", weapon_data: " 
		+ str(weapon_data), Core.TRACE, meta)


func _on_damage_taken(target, shooter): ########################################
	emit_signal("msg", "Event damage_taken called. target: " + str(target) 
		+ ", shooter: " + str(shooter), Core.TRACE, meta)


func _on_entity_picked_up(picker, entity): #####################################
	emit_signal("msg", "Event entity_picked_up called. picker: " 
		+ str(picker) + ", entity: " + str(entity), Core.TRACE, meta)


func _on_break_block(block): ###################################################
	emit_signal("msg", "Event break_block called. block: " 
		+ str(block), Core.TRACE, meta)


func _on_place_block(block): ###################################################
	emit_signal("msg", "Event place_block called. block: " + str(block), 
		Core.TRACE, meta)


func _on_gui_loaded(name, entity): #############################################
	emit_signal("msg", "Event gui_loaded called. name: " + str(name) 
		+ ", entity: " + str(entity), Core.TRACE, meta)


func _on_gui_pushed(name, init_param): #########################################
	emit_signal("msg", "Event gui_pushed called. name: " + str(name) 
		+ ", init_param: " + str(init_param), Core.TRACE, meta)


################################################################################

func _on_msg(message: String, level: int, meta: Dictionary):
	var level_string = "All"
	match level:
		Core.FATAL:
			level_string = "Fatal"
		Core.ERROR:
			level_string = "Error"
		Core.WARN:
			level_string = " Warn"
		Core.INFO:
			level_string = " Info"
		Core.DEBUG:
			level_string = "Debug"
		Core.TRACE:
			level_string = "Trace"
		Core.ALL:
			level_string = "  All"
	
	#if meta.get_meta()
	
	if level < 4:
		print(level_string + " [ " + meta.script_name + " ] " + message)

	var file = File.new()
	file.open(Client.data.log_path + "latest.txt", File.READ_WRITE)
	file.seek_end()
	file.store_string(level_string + ": " + message + '\n')
	file.close()

	if level == Core.FATAL:
		breakpoint

	#for id in Entity.get_entities_with("terminal"):
	#	var components = Entity.objects[id].components
	#	if Entity.get_component(id, "terminal.debug"):
	#		components.terminal.text += level + ": " + message + '\n'
	#		components.terminal.text_rendered = false

	#for id in Entity.get_entities_with("hud"):
	#	var components = Entity.objects[id].components
	#	var label = get_node("/root/World/" + str(id) + "/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/Chat/Content/Text/RichTextLabel")
	#	if label:
	#		label.text += level + ": " + message + '\n'

func _on_system_ready_fancy(system: int, obj: Object): ########################
	match system:
		scripts.core.system.CHUNK:
			if Core.Client.data.subsystem.chunk.online:
				Core.emit_signal("msg", "Chunk System ready called when already registered", Core.WARN, meta)
			else:
				Core.Client.data.subsystem.chunk.Link = obj
				Core.Client.data.subsystem.chunk.online = true
				Core.emit_signal("msg", "Chunk System ready.", Core.INFO, meta)
		scripts.core.system.CLIENT:
			if Core.Client.data.online:
				Core.emit_signal("msg", "Client System ready called when already registered", Core.WARN, meta)
			else:
				Core.Client.data.online = true
				Core.emit_signal("msg", "Client System ready.", Core.INFO, meta)
		scripts.core.system.DOWNLOAD:
			if Core.Client.data.subsystem.download.online:
				Core.emit_signal("msg", "Download System ready called when already registered", Core.WARN, meta)
			else:
				Core.Client.data.subsystem.download.Link = obj
				Core.Client.data.subsystem.download.online = true
				Core.emit_signal("msg", "Download System ready.", Core.INFO, meta)
		scripts.core.system.INPUT:
			if Core.Client.data.subsystem.input.online:
				Core.emit_signal("msg", "Input System ready called when already registered", Core.WARN, meta)
			else:
				Core.Client.data.subsystem.input.Link = obj
				Core.Client.data.subsystem.input.online = true
				Core.emit_signal("msg", "Input System ready.", Core.INFO, meta)
		scripts.core.system.INTERFACE:
			if Core.Client.data.subsystem.interface.online:
				Core.emit_signal("msg", "Interface System ready called when already registered", Core.WARN, meta)
			else:
				Core.Client.data.subsystem.interface.Link = obj
				Core.Client.data.subsystem.interface.online = true
				Core.emit_signal("msg", "Interface System ready.", Core.INFO, meta)
		scripts.core.system.SERVER:
			if Core.Server.data.online:
				Core.emit_signal("msg", "Server System ready called when already registered", Core.WARN, meta)
			else:
				Core.Server.data.online = true
				Core.emit_signal("msg", "Server System ready.", Core.INFO, meta)
		scripts.core.system.SOUND:
			if Core.Client.data.subsystem.sound.online:
				Core.emit_signal("msg", "Sound System ready called when already registered", Core.WARN, meta)
			else:
				Core.Client.data.subsystem.sound.Link = obj
				Core.Client.data.subsystem.sound.online = true
				Core.emit_signal("msg", "Sound System ready.", Core.INFO, meta)
		_:
			Core.emit_signal("msg", "Unknown system bootup", Core.WARN, meta)
	Core.emit_signal("msg", str(scripts.core.system.get_online_systems()) + " of " + str(Core.Client.TOTAL_SYSTEMS) + " Systems online", Core.INFO, meta)
	if scripts.core.system.get_online_systems() == Core.Client.TOTAL_SYSTEMS:
		Core.emit_signal("app_ready")
