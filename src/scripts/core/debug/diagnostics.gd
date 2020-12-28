#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.debug.diagnostics",
	description = """
		
	"""
}

const keyword = "eden"

const DEFAULT_TTY = {
	meta = {
		system = "interface",
		type = "tty",
		id = 0
	},
	debug = true,
	text = ""
}

# core.debug.diagnostics.run ###################################################
const run_meta := {
	func_name = "core.debug.diagnostics.run",
	description = """
		Starts the diagnostics process
	""",
		signal_link = "",
		meta_data = {},
		name = "" }
static func run(args := run_meta) -> void: #####################################
	randomize()
	var tty = DEFAULT_TTY.duplicate(true)
	var id = Core.client.data.subsystem.interface.Link.create(tty)
	Core.emit_signal("msg", "Staring tty on id " + str(id), Core.INFO, meta)
	
	var timer = Timer.new()
	
	var targ = _update_terminal_meta.duplicate(true)
	targ.signal_link = args.signal_link
	targ.meta_data = args.meta_data
	targ.name = args.name
	timer.connect("timeout", Core.scripts.core.debug.diagnostics, "_update_terminal", [targ])
	
	timer.set_name("TimerTTY")
	timer.wait_time = 0.01
	Core.add_child(timer)
	Core.get_node("TimerTTY").start()
# ^ core.debug.diagnostics.run #################################################


# core.debug.diagnostics._update_terminal ######################################
const _update_terminal_meta := {
	func_name = "core.debug.diagnostics._update_terminal",
	description = """
		Updates the terminal with diagnostics messages
	""",
		signal_link = "",
		meta_data = {},
		name = "" }
static func _update_terminal(args := _update_terminal_meta) -> void: ###########
	#Core.emit_signal("msg", "Update called!", Core.DEBUG, meta)
	#timer.wait_time = rand_range(0, 1)
	match Core.client.data.diagnostics.progress:
		0:
			Core.emit_signal("msg", "Welcome to " + Core.client.data.version, Core.DEBUG, args)
		1:
			Core.emit_signal("msg", "Please submit bug reports to joseph@theengineer.life or #dev at discord.me/EdenUniverseBuilder", Core.DEBUG, args)
		2:
			Core.emit_signal("msg", "Starting diagnostics...", Core.DEBUG, args)
		3:
			Core.emit_signal("msg", "Window Size: " + str(OS.window_size), Core.DEBUG, args)
		4:
			Core.emit_signal("msg", "Threads Enabled: " + str(OS.can_use_threads()), Core.DEBUG, args)
		5:
			Core.emit_signal("msg", "Video Driver: " + str(OS.get_current_video_driver()), Core.DEBUG, args)
		6:
			Core.emit_signal("msg", "Datetime: " + str(OS.get_datetime(true)), Core.DEBUG, args)
		7:
			Core.emit_signal("msg", "Dynamic Memory Usage: " + str(OS.get_dynamic_memory_usage()), Core.DEBUG, args)
		8:
			Core.emit_signal("msg", "Executable Path: " + str(OS.get_executable_path()), Core.DEBUG, args)
		9:
			Core.emit_signal("msg", "Locale: " + str(OS.get_locale()), Core.DEBUG, args)
		10:
			Core.emit_signal("msg", "Device Model: " + str(OS.get_model_name()), Core.DEBUG, args)
		11:
			Core.emit_signal("msg", "OS Name: " + str(OS.get_name()), Core.DEBUG, args)
		12:
			Core.emit_signal("msg", "Power State: " + str(OS.get_power_state()), Core.DEBUG, args)
		13:
			Core.emit_signal("msg", "Power Percent Left: " + str(OS.get_power_percent_left()), Core.DEBUG, args)
		14:
			Core.emit_signal("msg", "Power Seconds Left: " + str(OS.get_power_seconds_left()), Core.DEBUG, args)
		15:
			Core.emit_signal("msg", "Process ID: " + str(OS.get_process_id()), Core.DEBUG, args)
		16:
			Core.emit_signal("msg", "Processor Count: " + str(OS.get_processor_count()), Core.DEBUG, args)
		17:
			Core.emit_signal("msg", "Screen Count: " + str(OS.get_screen_count()), Core.DEBUG, args)
		18:
			Core.emit_signal("msg", "Screen DPI: " + str(OS.get_screen_dpi()), Core.DEBUG, args)
		19:
			Core.emit_signal("msg", "Screen Position: " + str(OS.get_screen_position()), Core.DEBUG, args)
		20:
			Core.emit_signal("msg", "Screen Size: " + str(OS.get_screen_size()), Core.DEBUG, args)
		21:
			Core.emit_signal("msg", "Static Memory Peak Usage: " + str(OS.get_static_memory_peak_usage()), Core.DEBUG, args)
		22:
			Core.emit_signal("msg", "Static Memory Usage: " + str(OS.get_static_memory_usage()), Core.DEBUG, args)
		23:
			Core.emit_signal("msg", "System Time: " + str(OS.get_system_time_secs()), Core.DEBUG, args)
		24:
			Core.emit_signal("msg", "Ticks (msec): " + str(OS.get_ticks_msec()), Core.DEBUG, args)
		25:
			Core.emit_signal("msg", "OS Time: " + str(OS.get_time()), Core.DEBUG, args)
		26:
			Core.emit_signal("msg", "Time Zone: " + str(OS.get_time_zone_info()), Core.DEBUG, args)
		27:
			Core.emit_signal("msg", "Unique ID: " + str(OS.get_unique_id()), Core.DEBUG, args)
		28:
			Core.emit_signal("msg", "User Data Directory: " + str(OS.get_user_data_dir()), Core.DEBUG, args)
		29:
			Core.emit_signal("msg", "Video Driver: " + str(OS.get_video_driver_name(OS.get_video_driver_count())), Core.DEBUG, args)
		30:
			Core.emit_signal("msg", "Virtual Keyboard Height: " + str(OS.get_virtual_keyboard_height()), Core.DEBUG, args)
		31:
			Core.emit_signal("msg", "Window Safe Area: " + str(OS.get_window_safe_area()), Core.DEBUG, args)
		32:
			Core.emit_signal("msg", "Is Debug Feature: " + str(OS.has_feature("debug")), Core.DEBUG, args)
		33:
			Core.emit_signal("msg", "Has Touchscreen: " + str(OS.has_touchscreen_ui_hint()), Core.DEBUG, args)
		34:
			Core.emit_signal("msg", "Has Virtual Keyboard: " + str(OS.has_virtual_keyboard()), Core.DEBUG, args)
		35:
			Core.emit_signal("msg", "Is Debug Build: " + str(OS.is_debug_build()), Core.DEBUG, args)
		36:
			Core.emit_signal("msg", "Is Ok Left and Cancel Right: " + str(OS.is_ok_left_and_cancel_right()), Core.DEBUG, args)
		37:
			Core.emit_signal("msg", "Is Userfs Persistent: " + str(OS.is_userfs_persistent()), Core.DEBUG, args)
		38:
			Core.emit_signal("msg", "Is Window Always on Top: " + str(OS.is_window_always_on_top()), Core.DEBUG, args)
		39:
			Core.emit_signal(args.signal_link, args.meta_data, args.name, "success")
			#show_text(id, components, "Type '" + keyword +"' to continue: ")
			#OS.show_virtual_keyboard()
			#create_text_input()
	Core.client.data.diagnostics.progress+=1
# ^ core.debug.diagnostics._update_terminal ####################################

#static func create_text_input():
#	var text_input = Dictionary()
#	text_input.rendered = false
#	text_input.object = meta
#	text_input.method = "text_submit"
#	text_input.text = ""
#	var id = Entity.create({"text_input": text_input})

#static func text_submit(id):
#	var input = Entity.objects[id].components.text_input.text
#	Entity.destory(id)
#	if input.to_lower().find(keyword):
#		Core.emit_signal("msg", "Keyword correct, diagnostics complete!", Core.INFO, meta)
#		OS.hide_virtual_keyboard()
#	else:
#		Core.emit_signal("msg", "Response: " + input.to_lower(), Core.DEBUG, meta)
#		Core.emit_signal("msg", "Keyword incorrect!", Core.WARN, meta)
#		#Core.emit_signal("msg", "Please type '" + keyword + "' to continue: ", Core.INFO, meta)
#		Core.emit_signal("msg", "Good enough I guess...", Core.INFO, meta)
#		Core.emit_signal("msg", "== Manual Override Engaged ==", Core.WARN, meta)
#		Core.emit_signal("msg", "Keyword correct, diagnostics complete!", Core.INFO, meta)
#		#OS.show_virtual_keyboard()
#		#create_text_input()
#	timer.stop()
#	emit_signal("diagnostics")
