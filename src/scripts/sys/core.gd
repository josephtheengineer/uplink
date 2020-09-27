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
		year = preload("res://src/scripts/calendar/year.gd"),
		new_task = preload("res://src/scripts/calendar/new_task.gd"),
		task = preload("res://src/scripts/calendar/task.gd")
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
			
		}
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
		player = {
			move = preload("res://src/scripts/client/player/move.gd"),
			interact = preload("res://src/scripts/client/player/interact.gd"),
			main = preload("res://src/scripts/client/player/main.gd")
		},
		bootup = preload("res://src/scripts/client/bootup.gd"),
		connect = preload("res://src/scripts/client/connect.gd"),
		network = preload("res://src/scripts/client/network.gd"),
		break_block = preload("res://src/scripts/client/break_block.gd"),
		place_block = preload("res://src/scripts/client/place_block.gd"),
		spawn = preload("res://src/scripts/client/spawn.gd")
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
		memory = preload("res://src/scripts/core/memory.gd"),
		files = preload("res://src/scripts/core/files.gd"),
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
		chat = preload("res://src/scripts/input/chat.gd"),
		other = preload("res://src/scripts/input/other.gd")
	},
	interface = {
		build_window = preload("res://src/scripts/interface/build_window.gd"),
		hud = preload("res://src/scripts/interface/hud.gd"),
		joystick = preload("res://src/scripts/interface/joystick.gd"),
		tile_map = preload("res://src/scripts/interface/tile_map.gd"),
		toolbox = preload("res://src/scripts/interface/toolbox.gd")
	},
	radio = {
		
	},
	server = {
		bootup = preload("res://src/scripts/server/bootup.gd")
	},
	sound = {
		
	},
	video = {
		
	},
	vr = {
		
	},
}
#warning-ignore:unused_class_variable
const scenes = {
	tty = preload("res://src/scenes/terminal/tty.tscn"),
	hud = preload("res://src/scenes/hud/hud.tscn"),
	player = preload("res://src/scenes/world/player.tscn")
}
#warning-ignore:unused_class_variable
const lib = {
	voxel = preload("res://src/code/voxel_mesh.gdns")
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
#warning-ignore:unused_signal
signal system_process_start(script_name)
#warning-ignore:unused_signal
signal system_process(meta, step, start)
#warning-ignore:unused_signal
signal reset()

################################################################################

#warning-ignore:unused_class_variable
onready var world: Node = get_parent().get_node("World")
#warning-ignore:unused_class_variable
onready var client: ClientSystem = world.get_node("Client")
#warning-ignore:unused_class_variable
onready var server: ServerSystem = world.get_node("Server")

var signals = [ "system_ready", "entity_loaded", "request_entity_unload", 
		"app_ready", "request_scene_load", "scene_loaded", 
		"entity_moved", "entity_used", "damage_dealt", 
		"entity_picked_up", "break_block", "place_block", "gui_loaded", 
		"gui_pushed", "system_process_start", "system_process", "reset"]

################################################################################

func _ready(): #################################################################
	for app_signal in signals:
		var error = connect(app_signal, self, "_on_" + app_signal)
		if error:
			emit_signal("msg", "Error on binding to " + app_signal 
				+ ": " + str(error), WARN, meta)

func _process(delta):
	scripts.core.memory.check()


func _on_system_ready(system, obj): ############################################
	emit_signal("msg", "Event system_ready called. system: " + str(system) 
		+ ", obj: " + str(obj), TRACE, meta)


func _on_entity_loaded(entity): ################################################
	emit_signal("msg", "Event entity_loaded called. entity: " 
		+ str(entity), TRACE, meta)


func _on_request_entity_unload(entity): ########################################
	emit_signal("msg", "Event request_entity_unload called. entity: " 
		+ str(entity), TRACE, meta)


func _on_app_ready(): ##########################################################
	emit_signal("msg", "Event app_ready called", TRACE, meta)


func _on_request_scene_load(scene): ############################################
	emit_signal("msg", "Event request_scene_load called. scene: " 
		+ str(scene), TRACE, meta)


func _on_scene_loaded(scene): ##################################################
	emit_signal("msg", "Event scene_loaded called. scene: " + str(scene), 
		TRACE, meta)


func _on_entity_moved(entity, dir): ############################################
	emit_signal("msg", "Event entity_moved called. entity: " + str(entity) 
		+ ", dir: " + str(dir), TRACE, meta)


func _on_entity_used(entity, amount): ##########################################
	emit_signal("msg", "Event entity_used called. entity: " + str(entity) 
		+ ", amount: " + str(amount), TRACE, meta)


func _on_damage_dealt(target, shooter, weapon_data): ###########################
	emit_signal("msg", "Event damage_dealt called. target: " + str(target) 
		+ ", shooter: " + str(shooter) + ", weapon_data: " 
		+ str(weapon_data), TRACE, meta)


func _on_damage_taken(target, shooter): ########################################
	emit_signal("msg", "Event damage_taken called. target: " + str(target) 
		+ ", shooter: " + str(shooter), TRACE, meta)


func _on_entity_picked_up(picker, entity): #####################################
	emit_signal("msg", "Event entity_picked_up called. picker: " 
		+ str(picker) + ", entity: " + str(entity), TRACE, meta)


func _on_break_block(block): ###################################################
	emit_signal("msg", "Event break_block called. block: " 
		+ str(block), TRACE, meta)


func _on_place_block(block): ###################################################
	emit_signal("msg", "Event place_block called. block: " + str(block), 
		TRACE, meta)


func _on_gui_loaded(name, entity): #############################################
	emit_signal("msg", "Event gui_loaded called. name: " + str(name) 
		+ ", entity: " + str(entity), TRACE, meta)


func _on_gui_pushed(name, init_param): #########################################
	emit_signal("msg", "Event gui_pushed called. name: " + str(name) 
		+ ", init_param: " + str(init_param), TRACE, meta)

func _on_system_process_start(script_name):
	emit_signal("msg", "Event system_process_start called. script_name: "
		+ str(script_name), TRACE, meta)
	emit_signal("msg", "==== Starting " + script_name + " ====", INFO, meta)
	var script = scripts.dictionary.main.get_from_dict(scripts, script_name.split("."))
	script.call(script.meta.steps[0])

func _on_reset(): ##############################################################
	emit_signal("msg", "Event reset called.", TRACE, meta)

func _on_system_process(meta_script, step, start = false): #####################
	emit_signal("msg", "Event system_process called. meta: [script_name]: "
		+ str(meta_script.script_name) + ", step: " + str(step) + ", start: " 
		+ str(start), TRACE, meta)
	
	var script = scripts.dictionary.main.get_from_dict(scripts, meta_script.script_name.split("."))
	var num = meta_script.steps.find(step)+1
	if start:
		emit_signal("msg", "\t" + meta_script.steps[num-1] + ": ", INFO, meta)
	else:
		if num < meta_script.steps.size():
			script.call(meta_script.steps[num])
		else:
			emit_signal("msg", "==== " + meta_script.script_name + " Finished ====", INFO, meta)
			if meta_script.script_name == "client.bootup":
				emit_signal("msg", "Welcome to Uplink! To start a demo sequence type /demo, or for a list of commands type /help", INFO, meta)

################################################################################

func _on_msg(message: String, level: int, meta: Dictionary):
	scripts.core.debug.msg.send(message, level, meta)

func _on_system_ready_fancy(system: int, obj: Object): ########################
	scripts.core.system.ready_fancy(system, obj)
