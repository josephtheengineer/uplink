extends Node
#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.system",
	description = """
		scripts, signals, consts.
		Main hub for infomation flow in Uplink
		This is the only signton in the game, it handles 
		public signals and Client and Server reference
	"""
}
#warning-ignore:unused_class_variable
const scripts := {
	chunk = {
		eden = {
			block_data = preload("res://src/scripts/chunk/eden/block_data.gd"),
			world_decoder = preload("res://src/scripts/chunk/eden/world_decoder.gd")
		},
		generator = preload("res://src/scripts/chunk/generator.gd"),
		geometry = preload("res://src/scripts/chunk/geometry.gd"),
		helper = preload("res://src/scripts/chunk/helper.gd"),
		manager = preload("res://src/scripts/chunk/manager.gd"),
		modify = preload("res://src/scripts/chunk/modify.gd"),
		system = preload("res://src/scripts/chunk/system.gd"),
		thread = preload("res://src/scripts/chunk/thread.gd"),
		tools = preload("res://src/scripts/chunk/tools.gd")
	},
	client = {
		player = {
			interact = preload("res://src/scripts/client/player/interact.gd"),
			main = preload("res://src/scripts/client/player/main.gd"),
			move = preload("res://src/scripts/client/player/move.gd")
		},
		bootup = preload("res://src/scripts/client/bootup.gd"),
		connect = preload("res://src/scripts/client/connect.gd"),
		network = preload("res://src/scripts/client/network.gd"),
		break_block = preload("res://src/scripts/client/break_block.gd"),
		place_block = preload("res://src/scripts/client/place_block.gd"),
		spawn = preload("res://src/scripts/client/spawn.gd"),
		system = preload("res://src/scripts/client/system.gd"),
	},
	core = {
		debug = {
			camera = preload("res://src/scripts/core/debug/camera.gd"),
			diagnostics = preload("res://src/scripts/core/debug/diagnostics.gd"),
			info = preload("res://src/scripts/core/debug/info.gd"),
			msg = preload("res://src/scripts/core/debug/msg.gd"),
			panel = preload("res://src/scripts/core/debug/panel.gd")
		},
		dictionary = {
			main = preload("res://src/scripts/core/dictionary/main.gd")
		},
		entity = {
			comp = preload("res://src/scripts/core/entity/comp.gd"),
			main = preload("res://src/scripts/core/entity/main.gd")
		},
		test = {
			single_block = preload("res://src/scripts/core/test/single_block.gd"),
			alias = preload("res://src/scripts/core/test/alias.gd")
		},
		files = preload("res://src/scripts/core/files.gd"),
		manager = preload("res://src/scripts/core/manager.gd"),
		memory = preload("res://src/scripts/core/memory.gd"),
		#system = preload("res://src/scripts/core/system.gd"),
		system_manager = preload("res://src/scripts/core/system_manager.gd")
	},
	download = {
		system = preload("res://src/scripts/download/system.gd")
	},
	input = {
		chat = preload("res://src/scripts/input/chat.gd"),
		other = preload("res://src/scripts/input/other.gd"),
		cli = preload("res://src/scripts/input/cli.gd"),
		system = preload("res://src/scripts/input/system.gd")
	},
	interface = {
		browser = {
			
		},
		calendar = {
			day = preload("res://src/scripts/interface/calendar/day.gd"),
			hour = preload("res://src/scripts/interface/calendar/hour.gd"),
			month = preload("res://src/scripts/interface/calendar/month.gd"),
			schedule = preload("res://src/scripts/interface/calendar/schedule.gd"),
			week = preload("res://src/scripts/interface/calendar/week.gd"),
			year = preload("res://src/scripts/interface/calendar/year.gd"),
			new_task = preload("res://src/scripts/interface/calendar/new_task.gd"),
			task = preload("res://src/scripts/interface/calendar/task.gd")
		},
		catalyst = {
			main = preload("res://src/scripts/interface/catalyst/main.gd")
		},
		chat = {
			discord = {
				
			},
			irc = {
				
			},
			mail = {
				
			}
		},
		radio = {
			
		},
		video = {
			
		},
		vr = {
			
		},
		build_window = preload("res://src/scripts/interface/build_window.gd"),
		hud = preload("res://src/scripts/interface/hud.gd"),
		joystick = preload("res://src/scripts/interface/joystick.gd"),
		system = preload("res://src/scripts/interface/system.gd"),
		tile_map = preload("res://src/scripts/interface/tile_map.gd"),
		toolbox = preload("res://src/scripts/interface/toolbox.gd")
	},
	server = {
		bootup = preload("res://src/scripts/server/bootup.gd"),
		system = preload("res://src/scripts/server/system.gd")
	},
	sound = {
		system = preload("res://src/scripts/sound/system.gd")
	}
}
#warning-ignore:unused_class_variable
const scenes = {
	interface = {
		calendar = {
			calendar = preload("res://src/scenes/interface/calendar/calendar.tscn"),
			dates = preload("res://src/scenes/interface/calendar/dates.tscn")
		},
		debug = {
			stats = preload("res://src/scenes/interface/debug/stats.tscn")
		},
		hud = {
			build_window = preload("res://src/scenes/interface/hud/build_window.tscn"),
			hud = preload("res://src/scenes/interface/hud/hud.tscn"),
			navbox = preload("res://src/scenes/interface/hud/navbox.tscn"),
			paint_window = preload("res://src/scenes/interface/hud/paint_window.tscn"),
			pause_window = preload("res://src/scenes/interface/hud/pause_window.tscn"),
			toolbox = preload("res://src/scenes/interface/hud/toolbox.tscn")
		},
		input = {
			joystick = preload("res://src/scenes/interface/input/joystick.tscn"),
			jump_button = preload("res://src/scenes/interface/input/jump_button.tscn")
		},
		main_menu = {
			dot = preload("res://src/scenes/interface/main_menu/dot.tscn"),
			main_menu = preload("res://src/scenes/interface/main_menu/main_menu.tscn"),
			new_world_panel = preload("res://src/scenes/interface/main_menu/new_world_panel.tscn")
		},
		terminal = {
			background = preload("res://src/scenes/interface/terminal/background.tscn"),
			tty = preload("res://src/scenes/interface/terminal/tty.tscn")
		}
	},
	world = {
		chunk_debug = preload("res://src/scenes/world/chunk_debug.tscn"),
		default_env = preload("res://src/scenes/world/default_env.tres"),
		entity = preload("res://src/scenes/world/entity.tscn"),
		environment = preload("res://src/scenes/world/environment.tres"),
		player = preload("res://src/scenes/world/player.tscn"),
		region_map = preload("res://src/scenes/world/region_map.tscn"),
		spatial = preload("res://src/scenes/world/spatial.tscn"),
		world = preload("res://src/scenes/world/world.tscn"),
		world_map = preload("res://src/scenes/world/world_map.tscn")
	}
}
#warning-ignore:unused_class_variable
#const lib = {
#	voxel = preload("res://src/code/voxel_mesh.gdns")
#}
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
onready var client = world.get_node("Client")
#warning-ignore:unused_class_variable
onready var server = world.get_node("Server")

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
    

func _process(_delta):
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
	var script = scripts.core.dictionary.main.get_from_dict(scripts, script_name.split("."))
	if script:
		script.call(script.meta.steps[0])
	else:
		emit_signal("msg", "Invalid script called!", ERROR, meta)

func _on_reset(): ##############################################################
	emit_signal("msg", "Event reset called.", TRACE, meta)

func _on_system_process(meta_script, step, code): #####################
	emit_signal("msg", "Event system_process called. meta: [script_name]: "
		+ str(meta_script.script_name) + ", step: " + str(step) + ", code: " 
		+ str(code), TRACE, meta)
	
	var script = scripts.core.dictionary.main.get_from_dict(scripts, meta_script.script_name.split("."))
	var num = meta_script.steps.find(step)+1
	match code:
		"start":
			emit_signal("msg", "\t" + meta_script.steps[num-1] + ": ", INFO, meta)
		"success":
			if num < meta_script.steps.size():
				script.call(meta_script.steps[num])
			else:
				emit_signal("msg", "==== " + meta_script.script_name + " Finished ====", INFO, meta)
				if meta_script.script_name == "client.bootup":
					emit_signal("msg", "Welcome to Uplink! To start a demo sequence type /demo, or for a list of commands type /help", INFO, meta)
		_:
			emit_signal("msg", "\t" + step + " finished with error " + str(code), WARN, meta)
			if num < meta_script.steps.size():
				script.call(meta_script.steps[num])

################################################################################

func _on_msg(message: String, level: int, meta: Dictionary):
	var args = scripts.core.debug.msg.send_meta.duplicate(true)
	args.message = message
	args.level = level
	args.meta = meta
	scripts.core.debug.msg.send(args)

func _on_system_ready_fancy(system: int, obj: Object): ########################
	scripts.core.system_manager.ready_fancy(system, obj)
