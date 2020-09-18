#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.memory",
	description = """
		
	"""
}

static func check():
	var mem = OS.get_static_memory_usage()
	if mem > 2*1073741824:
		if Core.Client.data.since_2gb_warn == -1 or Core.Client.data.since_2gb_warn == 0:
			Core.emit_signal("msg", "Memory usage is above 2gb!", Core.WARN, meta)
		if Core.Client.data.since_2gb_warn == -1:
			Core.emit_signal("msg", "Stopping chunk process...", Core.WARN, meta)
			Core.Client.data.subsystem.chunk.Link.data.mem_max = true
		if Core.Client.data.since_2gb_warn == 0:
			Core.Client.data.since_2gb_warn = 60
	if mem > 2*1073741824:
		if Core.Client.data.since_3gb_warn == -1 or Core.Client.data.since_3gb_warn == 0:
			Core.emit_signal("msg", "Memory usage is above 3gb!", Core.WARN, meta)
		if Core.Client.data.since_3gb_warn == -1:
			Core.emit_signal("msg", "Forcefully terminating the chunk system...", Core.ERROR, meta)
			#Core.Client.data.subsystem.chunk.Link
		if Core.Client.data.since_3gb_warn == 0:
			Core.Client.data.since_3gb_warn = 60
	if mem > 4*1073741824:
		Core.emit_signal("msg", "Memory usage is above 4gb!", Core.FATAL, meta)
		Core.emit_signal("msg", "This may indicate a memory leak.", Core.WARN, meta)
		Core.get_tree().quit()
	
	if Core.Client.data.since_2gb_warn > 0:
		Core.Client.data.since_2gb_warn -= 1
		
	if Core.Client.data.since_3gb_warn > 0:
		Core.Client.data.since_3gb_warn -= 1
