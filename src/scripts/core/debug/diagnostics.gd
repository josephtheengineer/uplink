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

static func run(signal_link, meta_data, name):
	randomize()
	var tty = DEFAULT_TTY.duplicate(true)
	var id = Core.client.data.subsystem.interface.Link.create(tty)
	Core.emit_signal("msg", "Staring tty on id " + str(id), Core.INFO, meta)
	
	var timer = Timer.new()
	timer.connect("timeout", Core.scripts.core.debug.diagnostics, "_update_terminal", [signal_link, meta_data, name])
	timer.set_name("TimerTTY")
	timer.wait_time = 0.01
	Core.add_child(timer)
	Core.get_node("TimerTTY").start()

static func _update_terminal(signal_link, meta_data, name):
	#Core.emit_signal("msg", "Update called!", Core.DEBUG, meta)
	#timer.wait_time = rand_range(0, 1)
	match Core.client.data.diagnostics.progress:
		0:
			Core.emit_signal("msg", "Welcome to " + Core.client.data.version, Core.INFO, meta)
		1:
			Core.emit_signal("msg", "Please submit bug reports to joseph@theengineer.life or #dev at discord.me/EdenUniverseBuilder", Core.INFO, meta)
		2:
			Core.emit_signal("msg", "Starting diagnostics...", Core.INFO, meta)
		3:
			Core.emit_signal("msg", "Window Size: " + str(OS.window_size), Core.INFO, meta)
		4:
			Core.emit_signal("msg", "Threads Enabled: " + str(OS.can_use_threads()), Core.INFO, meta)
		5:
			Core.emit_signal("msg", "Video Driver: " + str(OS.get_current_video_driver()), Core.INFO, meta)
		6:
			Core.emit_signal("msg", "Datetime: " + str(OS.get_datetime(true)), Core.INFO, meta)
		7:
			Core.emit_signal("msg", "Dynamic Memory Usage: " + str(OS.get_dynamic_memory_usage()), Core.INFO, meta)
		8:
			Core.emit_signal("msg", "Executable Path: " + str(OS.get_executable_path()), Core.INFO, meta)
		9:
			Core.emit_signal("msg", "Locale: " + str(OS.get_locale()), Core.INFO, meta)
		10:
			Core.emit_signal("msg", "Device Model: " + str(OS.get_model_name()), Core.INFO, meta)
		11:
			Core.emit_signal("msg", "OS Name: " + str(OS.get_name()), Core.INFO, meta)
		12:
			Core.emit_signal("msg", "Power State: " + str(OS.get_power_state()), Core.INFO, meta)
		13:
			Core.emit_signal("msg", "Power Percent Left: " + str(OS.get_power_percent_left()), Core.INFO, meta)
		14:
			Core.emit_signal("msg", "Power Seconds Left: " + str(OS.get_power_seconds_left()), Core.INFO, meta)
		15:
			Core.emit_signal("msg", "Process ID: " + str(OS.get_process_id()), Core.INFO, meta)
		16:
			Core.emit_signal("msg", "Processor Count: " + str(OS.get_processor_count()), Core.INFO, meta)
		17:
			Core.emit_signal("msg", "Screen Count: " + str(OS.get_screen_count()), Core.INFO, meta)
		18:
			Core.emit_signal("msg", "Screen DPI: " + str(OS.get_screen_dpi()), Core.INFO, meta)
		19:
			Core.emit_signal("msg", "Screen Position: " + str(OS.get_screen_position()), Core.INFO, meta)
		20:
			Core.emit_signal("msg", "Screen Size: " + str(OS.get_screen_size()), Core.INFO, meta)
		21:
			Core.emit_signal("msg", "Static Memory Peak Usage: " + str(OS.get_static_memory_peak_usage()), Core.INFO, meta)
		22:
			Core.emit_signal("msg", "Static Memory Usage: " + str(OS.get_static_memory_usage()), Core.INFO, meta)
		23:
			Core.emit_signal("msg", "System Time: " + str(OS.get_system_time_secs()), Core.INFO, meta)
		24:
			Core.emit_signal("msg", "Ticks (msec): " + str(OS.get_ticks_msec()), Core.INFO, meta)
		25:
			Core.emit_signal("msg", "OS Time: " + str(OS.get_time()), Core.INFO, meta)
		26:
			Core.emit_signal("msg", "Time Zone: " + str(OS.get_time_zone_info()), Core.INFO, meta)
		27:
			Core.emit_signal("msg", "Unique ID: " + str(OS.get_unique_id()), Core.INFO, meta)
		28:
			Core.emit_signal("msg", "User Data Directory: " + str(OS.get_user_data_dir()), Core.INFO, meta)
		29:
			Core.emit_signal("msg", "Video Driver: " + str(OS.get_video_driver_name(OS.get_video_driver_count())), Core.INFO, meta)
		30:
			Core.emit_signal("msg", "Virtual Keyboard Height: " + str(OS.get_virtual_keyboard_height()), Core.INFO, meta)
		31:
			Core.emit_signal("msg", "Window Safe Area: " + str(OS.get_window_safe_area()), Core.INFO, meta)
		32:
			Core.emit_signal("msg", "Is Debug Feature: " + str(OS.has_feature("debug")), Core.INFO, meta)
		33:
			Core.emit_signal("msg", "Has Touchscreen: " + str(OS.has_touchscreen_ui_hint()), Core.INFO, meta)
		34:
			Core.emit_signal("msg", "Has Virtual Keyboard: " + str(OS.has_virtual_keyboard()), Core.INFO, meta)
		35:
			Core.emit_signal("msg", "Is Debug Build: " + str(OS.is_debug_build()), Core.INFO, meta)
		36:
			Core.emit_signal("msg", "Is Ok Left and Cancel Right: " + str(OS.is_ok_left_and_cancel_right()), Core.INFO, meta)
		37:
			Core.emit_signal("msg", "Is Userfs Persistent: " + str(OS.is_userfs_persistent()), Core.INFO, meta)
		38:
			Core.emit_signal("msg", "Is Window Always on Top: " + str(OS.is_window_always_on_top()), Core.INFO, meta)
		39:
			Core.emit_signal(signal_link, meta_data, name, "success")
			#show_text(id, components, "Type '" + keyword +"' to continue: ")
			#OS.show_virtual_keyboard()
			#create_text_input()
	Core.client.data.diagnostics.progress+=1

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
