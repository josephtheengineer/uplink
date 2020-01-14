extends Node

var progress = 0
var timer = Timer.new()

const keyword = "eden"

signal diagnostics

func run(object, method):
	var Manager = load("res://scripts/features/manager.gd").new()
	connect("diagnostics", object, method)
	randomize()
	var tty = Dictionary()
	tty.name_id = "tty"
	tty.type = "interface"
	tty.debug = true
	tty.text = ""
	
	var id = Manager.create(tty)
	
	timer.connect("timeout", self, "_update_terminal")
	timer.set_name("TimerTTY")
	timer.wait_time = 0.01
	Core.add_child(timer)
	Core.get_node("TimerTTY").start()

func show_text(id, components, text):
	components.terminal.text += text
	components.terminal.text_rendered = false
	#Manager.edit(id, components)

func _update_terminal():
	#Core.emit_signal("msg", "Update called!", "Debug")
	#timer.wait_time = rand_range(0, 1)
	match progress:
		0:
			Core.emit_signal("msg", "Welcome to " + Core.Client.version, "Info")
		1:
			Core.emit_signal("msg", "Please submit bug reports to joseph@theengineer.life or #dev at discord.me/EdenUniverseBuilder", "Info")
		2:
			Core.emit_signal("msg", "Starting diagnostics...", "Info")
		3:
			Core.emit_signal("msg", "Window Size: " + str(OS.window_size), "Info")
		4:
			Core.emit_signal("msg", "Threads Enabled: " + str(OS.can_use_threads()), "Info")
		5:
			Core.emit_signal("msg", "Video Driver: " + str(OS.get_current_video_driver()), "Info")
		6:
			Core.emit_signal("msg", "Datetime: " + str(OS.get_datetime(true)), "Info")
		7:
			Core.emit_signal("msg", "Dynamic Memory Usage: " + str(OS.get_dynamic_memory_usage()), "Info")
		8:
			Core.emit_signal("msg", "Executable Path: " + str(OS.get_executable_path()), "Info")
		9:
			Core.emit_signal("msg", "Locale: " + str(OS.get_locale()), "Info")
		10:
			Core.emit_signal("msg", "Device Model: " + str(OS.get_model_name()), "Info")
		11:
			Core.emit_signal("msg", "OS Name: " + str(OS.get_name()), "Info")
		12:
			Core.emit_signal("msg", "Power State: " + str(OS.get_power_state()), "Info")
		13:
			Core.emit_signal("msg", "Power Percent Left: " + str(OS.get_power_percent_left()), "Info")
		14:
			Core.emit_signal("msg", "Power Seconds Left: " + str(OS.get_power_seconds_left()), "Info")
		15:
			Core.emit_signal("msg", "Process ID: " + str(OS.get_process_id()), "Info")
		16:
			Core.emit_signal("msg", "Processor Count: " + str(OS.get_processor_count()), "Info")
		17:
			Core.emit_signal("msg", "Screen Count: " + str(OS.get_screen_count()), "Info")
		18:
			Core.emit_signal("msg", "Screen DPI: " + str(OS.get_screen_dpi()), "Info")
		19:
			Core.emit_signal("msg", "Screen Position: " + str(OS.get_screen_position()), "Info")
		20:
			Core.emit_signal("msg", "Screen Size: " + str(OS.get_screen_size()), "Info")
		21:
			Core.emit_signal("msg", "Static Memory Peak Usage: " + str(OS.get_static_memory_peak_usage()), "Info")
		22:
			Core.emit_signal("msg", "Static Memory Usage: " + str(OS.get_static_memory_usage()), "Info")
		23:
			Core.emit_signal("msg", "System Time: " + str(OS.get_system_time_secs()), "Info")
		24:
			Core.emit_signal("msg", "Ticks (msec): " + str(OS.get_ticks_msec()), "Info")
		25:
			Core.emit_signal("msg", "OS Time: " + str(OS.get_time()), "Info")
		26:
			Core.emit_signal("msg", "Time Zone: " + str(OS.get_time_zone_info()), "Info")
		27:
			Core.emit_signal("msg", "Unique ID: " + str(OS.get_unique_id()), "Info")
		28:
			Core.emit_signal("msg", "User Data Directory: " + str(OS.get_user_data_dir()), "Info")
		29:
			Core.emit_signal("msg", "Video Driver: " + str(OS.get_video_driver_name(OS.get_video_driver_count())), "Info")
		30:
			Core.emit_signal("msg", "Virtual Keyboard Height: " + str(OS.get_virtual_keyboard_height()), "Info")
		31:
			Core.emit_signal("msg", "Window Safe Area: " + str(OS.get_window_safe_area()), "Info")
		32:
			Core.emit_signal("msg", "Is Debug Feature: " + str(OS.has_feature("debug")), "Info")
		33:
			Core.emit_signal("msg", "Has Touchscreen: " + str(OS.has_touchscreen_ui_hint()), "Info")
		34:
			Core.emit_signal("msg", "Has Virtual Keyboard: " + str(OS.has_virtual_keyboard()), "Info")
		35:
			Core.emit_signal("msg", "Is Debug Build: " + str(OS.is_debug_build()), "Info")
		36:
			Core.emit_signal("msg", "Is Ok Left and Cancel Right: " + str(OS.is_ok_left_and_cancel_right()), "Info")
		37:
			Core.emit_signal("msg", "Is Userfs Persistent: " + str(OS.is_userfs_persistent()), "Info")
		38:
			Core.emit_signal("msg", "Is Window Always on Top: " + str(OS.is_window_always_on_top()), "Info")
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
#		Core.emit_signal("msg", "Keyword correct, diagnostics complete!", "Info")
#		OS.hide_virtual_keyboard()
#	else:
#		Core.emit_signal("msg", "Response: " + input.to_lower(), "Debug")
#		Core.emit_signal("msg", "Keyword incorrect!", "Warn")
#		#Core.emit_signal("msg", "Please type '" + keyword + "' to continue: ", "Info")
#		Core.emit_signal("msg", "Good enough I guess...", "Info")
#		Core.emit_signal("msg", "== Manual Override Engaged ==", "Warn")
#		Core.emit_signal("msg", "Keyword correct, diagnostics complete!", "Info")
#		#OS.show_virtual_keyboard()
#		#create_text_input()
#	timer.stop()
#	emit_signal("diagnostics")