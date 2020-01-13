extends Node
onready var ClientSystem = get_node("/root/World/Systems/Client")
onready var Manager = preload("res://scripts/features/manager.gd")
onready var Debug = preload("res://scripts/features/debug.gd")

var progress = 0
var timer = Timer.new()

const keyword = "eden"

signal diagnostics

func run(object, method):
	connect("diagnostics", object, method)
	randomize()
	var terminal = Dictionary()
	terminal.rendered = false
	terminal.position = Vector2(0, 0)
	terminal.min_size = OS.window_size
	terminal.debug = true
	terminal.text = ""
	
	var text_input = Dictionary()
	text_input.rendered = false
	text_input.terminal = true
	text_input.text = ""
	var components = {"terminal": terminal, "text_input": text_input}
	var id = Manager.create(components)
	
	timer.connect("timeout", self, "_update_terminal", [id, components])
	timer.wait_time = 0.01
	add_child(timer)
	timer.start()

func show_text(id, components, text):
	components.terminal.text += text
	components.terminal.text_rendered = false
	Manager.edit(id, components)

func _update_terminal(id, components):
	#timer.wait_time = rand_range(0, 1)
	match progress:
		0:
			Debug.msg("Welcome to " + ClientSystem.version, "Info")
		1:
			Debug.msg("Please submit bug reports to josephtheengineer@pm.me or #dev at discord.me/EdenUniverseBuilder", "Info")
		2:
			Debug.msg("Starting diagnostics...", "Info")
		3:
			Debug.msg("Window Size: " + str(OS.window_size), "Info")
		4:
			Debug.msg("Threads Enabled: " + str(OS.can_use_threads()), "Info")
		5:
			Debug.msg("Video Driver: " + str(OS.get_current_video_driver()), "Info")
		6:
			Debug.msg("Datetime: " + str(OS.get_datetime(true)), "Info")
		7:
			Debug.msg("Dynamic Memory Usage: " + str(OS.get_dynamic_memory_usage()), "Info")
		8:
			Debug.msg("Executable Path: " + str(OS.get_executable_path()), "Info")
		9:
			Debug.msg("Locale: " + str(OS.get_locale()), "Info")
		10:
			Debug.msg("Device Model: " + str(OS.get_model_name()), "Info")
		11:
			Debug.msg("OS Name: " + str(OS.get_name()), "Info")
		12:
			Debug.msg("Power State: " + str(OS.get_power_state()), "Info")
		13:
			Debug.msg("Power Percent Left: " + str(OS.get_power_percent_left()), "Info")
		14:
			Debug.msg("Power Seconds Left: " + str(OS.get_power_seconds_left()), "Info")
		15:
			Debug.msg("Process ID: " + str(OS.get_process_id()), "Info")
		16:
			Debug.msg("Processor Count: " + str(OS.get_processor_count()), "Info")
		17:
			Debug.msg("Screen Count: " + str(OS.get_screen_count()), "Info")
		18:
			Debug.msg("Screen DPI: " + str(OS.get_screen_dpi()), "Info")
		19:
			Debug.msg("Screen Position: " + str(OS.get_screen_position()), "Info")
		20:
			Debug.msg("Screen Size: " + str(OS.get_screen_size()), "Info")
		21:
			Debug.msg("Static Memory Peak Usage: " + str(OS.get_static_memory_peak_usage()), "Info")
		22:
			Debug.msg("Static Memory Usage: " + str(OS.get_static_memory_usage()), "Info")
		23:
			Debug.msg("System Time: " + str(OS.get_system_time_secs()), "Info")
		24:
			Debug.msg("Ticks (msec): " + str(OS.get_ticks_msec()), "Info")
		25:
			Debug.msg("OS Time: " + str(OS.get_time()), "Info")
		26:
			Debug.msg("Time Zone: " + str(OS.get_time_zone_info()), "Info")
		27:
			Debug.msg("Unique ID: " + str(OS.get_unique_id()), "Info")
		28:
			Debug.msg("User Data Directory: " + str(OS.get_user_data_dir()), "Info")
		29:
			Debug.msg("Video Driver: " + str(OS.get_video_driver_name(OS.get_video_driver_count())), "Info")
		30:
			Debug.msg("Virtual Keyboard Height: " + str(OS.get_virtual_keyboard_height()), "Info")
		31:
			Debug.msg("Window Safe Area: " + str(OS.get_window_safe_area()), "Info")
		32:
			Debug.msg("Is Debug Feature: " + str(OS.has_feature("debug")), "Info")
		33:
			Debug.msg("Has Touchscreen: " + str(OS.has_touchscreen_ui_hint()), "Info")
		34:
			Debug.msg("Has Virtual Keyboard: " + str(OS.has_virtual_keyboard()), "Info")
		35:
			Debug.msg("Is Debug Build: " + str(OS.is_debug_build()), "Info")
		36:
			Debug.msg("Is Ok Left and Cancel Right: " + str(OS.is_ok_left_and_cancel_right()), "Info")
		37:
			Debug.msg("Is Userfs Persistent: " + str(OS.is_userfs_persistent()), "Info")
		38:
			Debug.msg("Is Window Always on Top: " + str(OS.is_window_always_on_top()), "Info")
		39:
			show_text(id, components, "Type '" + keyword +"' to continue: ")
			OS.show_virtual_keyboard()
			create_text_input()
	progress+=1

func create_text_input():
	var text_input = Dictionary()
	text_input.rendered = false
	text_input.object = self
	text_input.method = "text_submit"
	text_input.text = ""
	var id = Entity.create({"text_input": text_input})

func text_submit(id):
	var input = Entity.objects[id].components.text_input.text
	Entity.destory(id)
	if input.to_lower().find(keyword):
		Debug.msg("Keyword correct, diagnostics complete!", "Info")
		OS.hide_virtual_keyboard()
	else:
		Debug.msg("Response: " + input.to_lower(), "Debug")
		Debug.msg("Keyword incorrect!", "Warn")
		#Debug.msg("Please type '" + keyword + "' to continue: ", "Info")
		Debug.msg("Good enough I guess...", "Info")
		Debug.msg("== Manual Override Engaged ==", "Warn")
		Debug.msg("Keyword correct, diagnostics complete!", "Info")
		#OS.show_virtual_keyboard()
		#create_text_input()
	timer.stop()
	emit_signal("diagnostics")