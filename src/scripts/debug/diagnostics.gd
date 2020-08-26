#warning-ignore:unused_class_variable
var script_name = "diagnostics"
var Debug = preload("res://src/scripts/debug/debug.gd").new()
var Manager = preload("res://src/scripts/manager/manager.gd").new()

var progress = 0
var timer = Timer.new()

const keyword = "eden"

signal diagnostics

func run(object, method):
	var error = connect("diagnostics", object, method)
	if error:
		Core.emit_signal("msg", "Event diagnostics failed to bind", Debug.WARN, self)
	
	randomize()
	var tty = Dictionary()
	tty.name_id = "tty"
	tty.type = "interface"
	tty.debug = true
	tty.text = ""
	
	var id = Manager.create(tty)
	Core.emit_signal("msg", "Staring tty on id " + str(id), Debug.INFO, self)
	
	timer.connect("timeout", self, "_update_terminal")
	timer.set_name("TimerTTY")
	timer.wait_time = 0.01
	Core.add_child(timer)
	Core.get_node("TimerTTY").start()

func _update_terminal():
	#Core.emit_signal("msg", "Update called!", Debug.DEBUG, self)
	#timer.wait_time = rand_range(0, 1)
	match progress:
		0:
			Core.emit_signal("msg", "Welcome to " + Core.Client.version, Debug.INFO, self)
		1:
			Core.emit_signal("msg", "Please submit bug reports to joseph@theengineer.life or #dev at discord.me/EdenUniverseBuilder", Debug.INFO, self)
		2:
			Core.emit_signal("msg", "Starting diagnostics...", Debug.INFO, self)
		3:
			Core.emit_signal("msg", "Window Size: " + str(OS.window_size), Debug.INFO, self)
		4:
			Core.emit_signal("msg", "Threads Enabled: " + str(OS.can_use_threads()), Debug.INFO, self)
		5:
			Core.emit_signal("msg", "Video Driver: " + str(OS.get_current_video_driver()), Debug.INFO, self)
		6:
			Core.emit_signal("msg", "Datetime: " + str(OS.get_datetime(true)), Debug.INFO, self)
		7:
			Core.emit_signal("msg", "Dynamic Memory Usage: " + str(OS.get_dynamic_memory_usage()), Debug.INFO, self)
		8:
			Core.emit_signal("msg", "Executable Path: " + str(OS.get_executable_path()), Debug.INFO, self)
		9:
			Core.emit_signal("msg", "Locale: " + str(OS.get_locale()), Debug.INFO, self)
		10:
			Core.emit_signal("msg", "Device Model: " + str(OS.get_model_name()), Debug.INFO, self)
		11:
			Core.emit_signal("msg", "OS Name: " + str(OS.get_name()), Debug.INFO, self)
		12:
			Core.emit_signal("msg", "Power State: " + str(OS.get_power_state()), Debug.INFO, self)
		13:
			Core.emit_signal("msg", "Power Percent Left: " + str(OS.get_power_percent_left()), Debug.INFO, self)
		14:
			Core.emit_signal("msg", "Power Seconds Left: " + str(OS.get_power_seconds_left()), Debug.INFO, self)
		15:
			Core.emit_signal("msg", "Process ID: " + str(OS.get_process_id()), Debug.INFO, self)
		16:
			Core.emit_signal("msg", "Processor Count: " + str(OS.get_processor_count()), Debug.INFO, self)
		17:
			Core.emit_signal("msg", "Screen Count: " + str(OS.get_screen_count()), Debug.INFO, self)
		18:
			Core.emit_signal("msg", "Screen DPI: " + str(OS.get_screen_dpi()), Debug.INFO, self)
		19:
			Core.emit_signal("msg", "Screen Position: " + str(OS.get_screen_position()), Debug.INFO, self)
		20:
			Core.emit_signal("msg", "Screen Size: " + str(OS.get_screen_size()), Debug.INFO, self)
		21:
			Core.emit_signal("msg", "Static Memory Peak Usage: " + str(OS.get_static_memory_peak_usage()), Debug.INFO, self)
		22:
			Core.emit_signal("msg", "Static Memory Usage: " + str(OS.get_static_memory_usage()), Debug.INFO, self)
		23:
			Core.emit_signal("msg", "System Time: " + str(OS.get_system_time_secs()), Debug.INFO, self)
		24:
			Core.emit_signal("msg", "Ticks (msec): " + str(OS.get_ticks_msec()), Debug.INFO, self)
		25:
			Core.emit_signal("msg", "OS Time: " + str(OS.get_time()), Debug.INFO, self)
		26:
			Core.emit_signal("msg", "Time Zone: " + str(OS.get_time_zone_info()), Debug.INFO, self)
		27:
			Core.emit_signal("msg", "Unique ID: " + str(OS.get_unique_id()), Debug.INFO, self)
		28:
			Core.emit_signal("msg", "User Data Directory: " + str(OS.get_user_data_dir()), Debug.INFO, self)
		29:
			Core.emit_signal("msg", "Video Driver: " + str(OS.get_video_driver_name(OS.get_video_driver_count())), Debug.INFO, self)
		30:
			Core.emit_signal("msg", "Virtual Keyboard Height: " + str(OS.get_virtual_keyboard_height()), Debug.INFO, self)
		31:
			Core.emit_signal("msg", "Window Safe Area: " + str(OS.get_window_safe_area()), Debug.INFO, self)
		32:
			Core.emit_signal("msg", "Is Debug Feature: " + str(OS.has_feature("debug")), Debug.INFO, self)
		33:
			Core.emit_signal("msg", "Has Touchscreen: " + str(OS.has_touchscreen_ui_hint()), Debug.INFO, self)
		34:
			Core.emit_signal("msg", "Has Virtual Keyboard: " + str(OS.has_virtual_keyboard()), Debug.INFO, self)
		35:
			Core.emit_signal("msg", "Is Debug Build: " + str(OS.is_debug_build()), Debug.INFO, self)
		36:
			Core.emit_signal("msg", "Is Ok Left and Cancel Right: " + str(OS.is_ok_left_and_cancel_right()), Debug.INFO, self)
		37:
			Core.emit_signal("msg", "Is Userfs Persistent: " + str(OS.is_userfs_persistent()), Debug.INFO, self)
		38:
			Core.emit_signal("msg", "Is Window Always on Top: " + str(OS.is_window_always_on_top()), Debug.INFO, self)
		39:
			emit_signal("diagnostics")
			#show_text(id, components, "Type '" + keyword +"' to continue: ")
			#OS.show_virtual_keyboard()
			#create_text_input()
	progress+=1

#func create_text_input():
#	var text_input = Dictionary()
#	text_input.rendered = false
#	text_input.object = self
#	text_input.method = "text_submit"
#	text_input.text = ""
#	var id = Entity.create({"text_input": text_input})

#func text_submit(id):
#	var input = Entity.objects[id].components.text_input.text
#	Entity.destory(id)
#	if input.to_lower().find(keyword):
#		Core.emit_signal("msg", "Keyword correct, diagnostics complete!", Debug.INFO, self)
#		OS.hide_virtual_keyboard()
#	else:
#		Core.emit_signal("msg", "Response: " + input.to_lower(), Debug.DEBUG, self)
#		Core.emit_signal("msg", "Keyword incorrect!", Debug.WARN, self)
#		#Core.emit_signal("msg", "Please type '" + keyword + "' to continue: ", Debug.INFO, self)
#		Core.emit_signal("msg", "Good enough I guess...", Debug.INFO, self)
#		Core.emit_signal("msg", "== Manual Override Engaged ==", Debug.WARN, self)
#		Core.emit_signal("msg", "Keyword correct, diagnostics complete!", Debug.INFO, self)
#		#OS.show_virtual_keyboard()
#		#create_text_input()
#	timer.stop()
#	emit_signal("diagnostics")
