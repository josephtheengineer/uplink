#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.debug.msg",
	description = """
		sets up logging
	"""
}

const log_loc = "user://logs/"

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
