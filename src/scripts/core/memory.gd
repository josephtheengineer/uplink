#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.memory",
	description = """
		
	"""
}

# core.memory.check ############################################################
const check_meta := {
	func_name = "core.memory.check",
	description = """
		
	""",
		}
static func check(args := check_meta) -> void: ################################
	var mem = OS.get_static_memory_usage()
	if mem > 2*1073741824:
		if Core.client.data.since_2gb_warn == -1 or Core.client.data.since_2gb_warn == 0:
			Core.emit_signal("msg", "Memory usage is above 2gb!", Core.WARN, args)
		if Core.client.data.since_2gb_warn == -1:
			Core.emit_signal("msg", "Stopping chunk process...", Core.WARN, args)
			Core.client.data.subsystem.chunk.Link.data.mem_max = true
		if Core.client.data.since_2gb_warn == 0:
			Core.client.data.since_2gb_warn = 60
	if mem > 2*1073741824:
		if Core.client.data.since_3gb_warn == -1 or Core.Client.data.since_3gb_warn == 0:
			Core.emit_signal("msg", "Memory usage is above 3gb!", Core.WARN, args)
		if Core.client.data.since_3gb_warn == -1:
			Core.emit_signal("msg", "Forcefully terminating the chunk system...", Core.ERROR, args)
			#Core.Client.data.subsystem.chunk.Link
		if Core.client.data.since_3gb_warn == 0:
			Core.client.data.since_3gb_warn = 60
	if mem > 4*1073741824:
		Core.emit_signal("msg", "Memory usage is above 4gb!", Core.FATAL, args)
		Core.emit_signal("msg", "This may indicate a memory leak.", Core.WARN, args)
		Core.get_tree().quit()
	
	if Core.client.data.since_2gb_warn > 0:
		Core.client.data.since_2gb_warn -= 1
		
	if Core.client.data.since_3gb_warn > 0:
		Core.client.data.since_3gb_warn -= 1
# ^ core.memory.check ##########################################################
