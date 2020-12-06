#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.debug.msg",
	description = """
		sets up logging
	"""
}

const log_loc = "user://log/"

static func init(_client_log_loc):
	#var log_loc = client_log_loc
	var file = File.new()
	var dir = Directory.new()
	dir.make_dir(log_loc)
	file.open(log_loc + "latest.txt", File.WRITE)
	file.close()
	Core.emit_signal("msg", "Logs stored at " + log_loc, Core.INFO, meta)
	var error = Core.connect("msg", Core, "_on_msg")
	if error:
		Core.emit_signal("msg", "Event msg failed to bind", Core.WARN, meta)
		print("Warn: Event msg failed to bind")

static func level_string(level: int):
	match level:
		Core.FATAL:
			return "Fatal"
		Core.ERROR:
			return "Error"
		Core.WARN:
			return " Warn"
		Core.INFO:
			return " Info"
		Core.DEBUG:
			return "Debug"
		Core.TRACE:
			return "Trace"
		Core.ALL:
			return "  All"

# core.debug.msg.send ##########################################################
const send_meta := {
	script = meta,
	func_name = "core.debug.msg.send",
	description = """
		
	""",
		message = "",
		level = "",
		meta = {} }
static func send(args := send_meta) -> void: ###################################
	var level_string = level_string(args.level)
	var elapsed = OS.get_ticks_msec()
	
	var func_path = ""
	if args.meta.has("func_name"):
		func_path = args.meta.func_name
	elif args.meta.has("script_name"):
		
		# Prevent stack overflow
		if args.meta.script_name != "core.debug.msg":
			Core.emit_signal("msg", "Message sent without a function name", Core.WARN, args)
		func_path = args.meta.script_name + ".n/a"
	else:
		Core.emit_signal("msg", "Message sent without a script path", Core.ERROR, args)
		func_path = "n/a"
	
	if args.level < Core.ALL:
		print(str(elapsed) + " " + level_string + " [ " + func_path + " ] " + args.message)
		
	var file = File.new()
	file.open(Core.client.data.log_path + "latest.txt", File.READ_WRITE)
	file.seek_end()
	var date = str(OS.get_date().year) + "-" + str(OS.get_date().month) + "-" + str(OS.get_date().day)
	var time = str(OS.get_time().hour) + ":" + str(OS.get_time().minute) + ":" + str(OS.get_time().second) 
	file.store_string(date + " " + time + " | " + level_string + " [ " + func_path + " ] " + args.message + '\n')
	file.close()
	
	if args.level == Core.FATAL:
		print("ERR FATAL received, terminating active processes")
		Core.get_tree().quit()
# ^ core.debug.msg.send ########################################################
