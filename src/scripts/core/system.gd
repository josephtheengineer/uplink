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
		video = preload("res://src/scripts/client/video.gd")
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
			alias = preload("res://src/scripts/core/test/alias.gd"),
			floor = preload("res://src/scripts/core/test/floor.gd"),
			single_block = preload("res://src/scripts/core/test/single_block.gd")
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
		irc = preload("res://src/scripts/input/irc.gd"),
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


# core.system.ready ############################################################
const ready_meta := {
	func_name = "core.system.ready",
	description = """
		
	""",
		}
func _ready(args := ready_meta) -> void: #######################################
	for app_signal in signals:
		var error = connect(app_signal, self, "_on_" + app_signal)
		if error:
			emit_signal("msg", "Error on binding to " + app_signal 
				+ ": " + str(error), WARN, args)
# ^ core.system.ready ##########################################################


# core.system._process #########################################################
const _process_meta := {
	func_name = "core.system._process",
	description = """
		
	""",
		}
func _process(_delta, _args := _process_meta) -> void: ##########################
	scripts.core.memory.check()
# ^ core.system._process #######################################################


# core.system._on_system_ready #################################################
const _on_system_ready_meta := {
	func_name = "core.system._on_system_ready",
	description = """
		
	""",
		}
func _on_system_ready(system, obj, args := _on_system_ready_meta) -> void: #####
	emit_signal("msg", "Event system_ready called. system: " + str(system) 
		+ ", obj: " + str(obj), TRACE, args)
# ^ core.system._on_system_ready ###############################################


# core.system._on_request_entity_unload ########################################
const _on_request_entity_unload_meta := {
	
	func_name = "core.system._on_request_entity_unload",
	description = """
		
	""",
		}
func _on_request_entity_unload(entity, args := _on_request_entity_unload_meta) -> void:
	emit_signal("msg", "Event request_entity_unload called. entity: " 
		+ str(entity), TRACE, args)
# ^ core.system._on_request_entity_unload ########################################


# core.system._on_app_ready ####################################################
const _on_app_ready_meta := {
	func_name = "core.system._on_app_ready",
	description = """
		
	""",
		}
func _on_app_ready(args := _on_app_ready_meta) -> void: ########################
	emit_signal("msg", "Event app_ready called", TRACE, args)
# ^ core.system._on_app_ready ##################################################


# core.system._on_request_scene_load ###########################################
const _on_request_scene_load_meta := {
	func_name = "core.system._on_request_scene_load",
	description = """
		
	""",
		}
func _on_request_scene_load(scene, args := _on_request_scene_load_meta) -> void: 
	emit_signal("msg", "Event request_scene_load called. scene: " 
		+ str(scene), TRACE, args)
# ^ core.system._on_request_scene_load #########################################


# core.system._on_scene_loaded #################################################
const _on_scene_loaded_meta := {
	func_name = "core.system._on_scene_loaded",
	description = """
		
	""",
		}
func _on_scene_loaded(scene, args := _on_scene_loaded_meta) -> void: ###########
	emit_signal("msg", "Event scene_loaded called. scene: " + str(scene), 
		TRACE, args)
# ^ core.system._on_scene_loaded ###############################################


# core.system._on_entity_moved #################################################
const _on_entity_moved_meta := {
	func_name = "core.system._on_entity_moved",
	description = """
		
	""",
		}
func _on_entity_moved(entity, dir, args := _on_entity_moved_meta) -> void: #####
	emit_signal("msg", "Event entity_moved called. entity: " + str(entity) 
		+ ", dir: " + str(dir), TRACE, args)
# ^ core.system._on_entity_moved ###############################################


# core.system._on_entity_used ##################################################
const _on_entity_used_meta := {
	func_name = "core.system._on_entity_used",
	description = """
		
	""",
		}
func _on_entity_used(entity, amount, args := _on_entity_used_meta) -> void: ####
	emit_signal("msg", "Event entity_used called. entity: " + str(entity) 
		+ ", amount: " + str(amount), TRACE, args)
# ^ core.system._on_entity_used ################################################


# core.system._on_damage_dealt #################################################
const _on_damage_dealt_meta := {
	func_name = "core.system._on_damage_dealt",
	description = """
		
	""",
		}
func _on_damage_dealt(target, shooter, weapon_data, args := _on_damage_dealt_meta) -> void:
	emit_signal("msg", "Event damage_dealt called. target: " + str(target) 
		+ ", shooter: " + str(shooter) + ", weapon_data: " 
		+ str(weapon_data), TRACE, args)
# ^ core.system._on_damage_dealt ###############################################


# core.system._on_damage_taken #################################################
const _on_damage_taken_meta := {
	func_name = "core.system._on_damage_taken",
	description = """
		
	""",
		}
func _on_damage_taken(target, shooter, args := _on_damage_taken_meta) -> void: #
	emit_signal("msg", "Event damage_taken called. target: " + str(target) 
		+ ", shooter: " + str(shooter), TRACE, args)
# ^ core.system._on_damage_taken ###############################################


# core.system._on_entity_picked_up #############################################
const _on_entity_picked_up_meta := {
	func_name = "core.system._on_entity_picked_up",
	description = """
		
	""",
		}
func _on_entity_picked_up(picker, entity, args := _on_entity_picked_up_meta) -> void: 
	emit_signal("msg", "Event entity_picked_up called. picker: " 
		+ str(picker) + ", entity: " + str(entity), TRACE, args)
# ^ core.system._on_entity_picked_up ###########################################


# core.system._on_break_block ##################################################
const _on_break_block_meta := {
	func_name = "core.system._on_break_block",
	description = """
		
	""",
		}
func _on_break_block(block, args := _on_break_block_meta) -> void: #############
	emit_signal("msg", "Event break_block called. block: " 
		+ str(block), TRACE, args)
# ^ core.system._on_break_block ################################################


# core.system._on_place_block ##################################################
const _on_place_block_meta := {
	func_name = "core.system._on_place_block",
	description = """
		
	""",
		}
func _on_place_block(block, args := _on_place_block_meta) -> void: #############
	emit_signal("msg", "Event place_block called. block: " + str(block), 
		TRACE, args)
# ^ core.system._on_place_block ################################################


# core.system._on_gui_loaded ###################################################
const _on_gui_loaded_meta := {
	func_name = "core.system._on_gui_loaded",
	description = """
		
	""",
		}
func _on_gui_loaded(name, entity, args := _on_gui_loaded_meta) -> void: ########
	emit_signal("msg", "Event gui_loaded called. name: " + str(name) 
		+ ", entity: " + str(entity), TRACE, args)
# ^ core.system._on_gui_loaded #################################################


# core.system._on_gui_pushed ###################################################
const _on_gui_pushed_meta := {
	func_name = "core.system._on_gui_pushed",
	description = """
		
	""",
		}
func _on_gui_pushed(name, init_param, args := _on_gui_pushed_meta) -> void: ####
	emit_signal("msg", "Event gui_pushed called. name: " + str(name) 
		+ ", init_param: " + str(init_param), TRACE, args)
# ^ core.system._on_gui_pushed #################################################


# core.system._on_system_process_start #########################################
const _on_system_process_start_meta := {
	func_name = "core.system._on_system_process_start",
	description = """
		
	""",
		}
func _on_system_process_start(script_name, args := _on_system_process_start_meta) -> void: 
	emit_signal("msg", "Event system_process_start called. script_name: "
		+ str(script_name), TRACE, args)
	emit_signal("msg", "==== Starting " + script_name + " ====", INFO, args)
	var script = scripts.core.dictionary.main.get_from_dict(scripts, script_name.split("."))
	if script:
		script.call(script.meta.steps[0])
	else:
		emit_signal("msg", "Invalid script called!", ERROR, args)
# ^ core.system._on_system_process_start #######################################


# core.system._on_reset ########################################################
const _on_reset_meta := {
	func_name = "core.system._on_reset",
	description = """
		
	""",
		}
func _on_reset(args := _on_reset_meta) -> void: ################################
	emit_signal("msg", "Event reset called.", TRACE, args)
# ^ core.system._on_reset ######################################################


# core.system._on_system_process ###############################################
const _on_system_process_meta := {
	func_name = "core.system._on_system_process",
	description = """
		
	""",
		}
func _on_system_process(meta_script, step, code, args := _on_system_process_meta) -> void: 
	emit_signal("msg", "Event system_process called. meta: [script_name]: "
		+ str(meta_script.script_name) + ", step: " + str(step) + ", code: " 
		+ str(code), TRACE, args)
	
	var script = scripts.core.dictionary.main.get_from_dict(scripts, meta_script.script_name.split("."))
	var num = meta_script.steps.find(step)+1
	match code:
		"start":
			emit_signal("msg", "\t" + meta_script.steps[num-1] + ": ", INFO, args)
		"success":
			if num < meta_script.steps.size():
				script.call(meta_script.steps[num])
			else:
				emit_signal("msg", "==== " + meta_script.script_name + " Finished ====", INFO, args)
				if meta_script.script_name == "client.bootup":
					emit_signal("msg", "Welcome to Uplink! To start a demo sequence type /demo, or for a list of commands type /help", INFO, args)
		_:
			emit_signal("msg", "\t" + step + " finished with error " + str(code), WARN, args)
			if num < meta_script.steps.size():
				script.call(meta_script.steps[num])
# ^ core.system._on_system_process #############################################


################################################################################

func _on_msg(message: String, level: int, meta: Dictionary):
	var args = scripts.core.debug.msg.send_meta.duplicate(true)
	args.message = message
	args.level = level
	args.meta = meta
	scripts.core.debug.msg.send(args)

func _on_system_ready_fancy(system: int, obj: Object): ########################
	scripts.core.system_manager.ready_fancy(system, obj)


static func run(path: String, args=Dictionary()):
	var script_path: Array = path.split(".", false)
	script_path.pop_back()
	
	var script = Core.scripts.core.dictionary.main.get_from_dict(Core.scripts, script_path)
	var func_name = path.split(".", false)[-1]
	
	if typeof(script) != TYPE_OBJECT or not script.new().has_method(func_name):
		Core.emit_signal("msg", "Invalid script called " + path, Core.ERROR, meta)
		return
	
	var func_meta = script.get(str(func_name) + "_meta").duplicate(true)
	
	for arg in args.keys():
		if func_meta.has(arg):
			func_meta[arg] = args[arg]
	
	script.call(func_name, func_meta)
	
	return func_meta
