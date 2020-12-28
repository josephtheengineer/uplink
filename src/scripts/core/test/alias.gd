#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.test.alias",
	type = "process",
	steps = [
		"create_alias",
		"test_file",
		"call_cli",
		"test_var"
	],
	description = """
		
	"""
}


# core.test.alias.start ########################################################
const start_meta := {
	func_name = "core.test.alias.start",
	description = """
		Tests the cli function for creating and using an alias
	"""
		}
static func start(_args := start_meta) -> void: ################################
	Core.emit_signal("system_process_start", "core.test.alias")
# ^ core.test.alias.start ######################################################


####### >> ########
static func test_call():
	Core.client.data.test_alias = true
####### >> ########


static func create_alias():
	Core.emit_signal("system_process", meta, "create_alias", "start")
	
	Core.client.data.test_alias = false
	Core.scripts.input.cli.create_alias({name="_alias_automatic_test", value="core.test.alias.test_call"})
	
	Core.emit_signal("system_process", meta, "create_alias", "success")

static func test_file():
	Core.emit_signal("system_process", meta, "test_file", "start")
	
	var text := ""
	var file = File.new()
	if file.open("res://data.txt", File.READ) != 0:
		Core.emit_signal("system_process", meta, "test_file", "error opening file")
	else:
		text = file.get_as_text()
		file.close()
	
		if "_alias_automatic_test=core.test.alias.test_call\n" in text:
			Core.emit_signal("system_process", meta, "test_file", "success")
		else:
			Core.emit_signal("system_process", meta, "test_file", "could not find alias in file")

static func call_cli():
	Core.emit_signal("system_process", meta, "call_cli", "start")
	
	var args = Core.scripts.input.cli.call_cli_meta.duplicate(true)
	args.text_input = "_alias_automatic_test"
	Core.scripts.input.cli.call_cli(args)
	
	Core.emit_signal("system_process", meta, "call_cli", "success")

static func test_var():
	Core.emit_signal("system_process", meta, "test_var", "start")
	if Core.client.data.test_alias:
		Core.emit_signal("system_process", meta, "test_var", "success")
	else:
		Core.emit_signal("system_process", meta, "test_var", "alias function not called")
