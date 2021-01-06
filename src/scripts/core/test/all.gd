#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.test.all",
	type = "process",
	steps = [
		"alias",
		#"block_floor",
		#"single_block"
	],
	description = """
		
	"""
}


# core.test.all.start ########################################################
const start_meta := {
	func_name = "core.test.all.start",
	description = """
		
	"""
		}
static func start(_args := start_meta) -> void: ################################
	Core.emit_signal("system_process_start", "core.test.all")
# ^ core.test.all.start ######################################################


static func alias():
	Core.emit_signal("system_process", meta, "alias", "start")
	
	Core.emit_signal("system_process_start", "core.test.alias")
	
	Core.emit_signal("system_process", meta, "alias", "success")


#static func block_floor():
#	Core.emit_signal("system_process", meta, "block_floor", "start")
#
#	Core.emit_signal("system_process_start", "core.test.block_floor")
#
#	Core.emit_signal("system_process", meta, "block_floor", "success")
#
#
#static func single_block():
#	Core.emit_signal("system_process", meta, "single_block", "start")
#
#	Core.emit_signal("system_process_start", "core.test.single_block")
#
#	Core.emit_signal("system_process", meta, "single_block", "success")
