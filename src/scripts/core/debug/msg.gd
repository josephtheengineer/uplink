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

static func send(message: String, level: int, meta: Dictionary):
	var level_string = level_string(level)
	var elapsed = OS.get_ticks_msec()
	
	if level < Core.ALL:
		print(str(elapsed) + " " + level_string + " [ " + meta.script_name + " ] " + message)
		
	var file = File.new()
	file.open(Core.client.data.log_path + "latest.txt", File.READ_WRITE)
	file.seek_end()
	var date = str(OS.get_date().year) + "-" + str(OS.get_date().month) + "-" + str(OS.get_date().day)
	var time = str(OS.get_time().hour) + ":" + str(OS.get_time().minute) + ":" + str(OS.get_time().second) 
	file.store_string(date + " " + time + " | " + level_string + " [ " + meta.script_name + " ] " + message + '\n')
	file.close()
	
	if level == Core.FATAL:
		print("ERR FATAL received, terminating active processes")
		Core.get_tree().quit()
