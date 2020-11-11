# Uplink Catalyst CLI

## Godot Script Format

# input.chat.call_cli ##########################################################
const call_cli_meta := {
	func_name = "input.chat.call_cli",
	description = """
		Calls cli method
	""",
	data = {
		args = "" } }
func call_cli(args := call_cli_meta) -> void: ##################################
	# args = "start_server port=2565 world="/user/worlds/dr" username="jte""
	# args_dict = string.split(" ") construct dictionary
	# var script = scripts.core.dictionary.main.get_from_dict(scripts, meta_script.script_name.split(".")) get script
	# script.call(args)
	# if args.error != false:
	# print("Error reported!")
	pass
# ^ input.chat.call_cli ########################################################



# input.chat.start_server ######################################################
const start_server_meta := {
	func_name = "input.chat.start_server",
	description = """
		Starts server and loads world if supplied
	""",
	data = {
		port = 500,
		world = "",
		username = "user",
		error = false } }
func start_server(args := start_server_meta) -> void: ##########################
	args.error = "Not implemented"
# ^ input.chat.start_server ####################################################
