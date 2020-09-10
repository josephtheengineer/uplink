#warning-ignore:unused_class_variable
const meta := {
	script_name = "client.connect",
	type = "process",
	steps = [
		"find_server",
		"connect_to_server",
		"register_world_metadata"
	],
	description = """
		
	"""
}

static func find_server():
	Core.emit_signal("system_process", meta, "find_server", true)
	Core.Client.data.server_ip = "localhost"
	Core.emit_signal("system_process", meta, "find_server")

static func connect_to_server():
	Core.emit_signal("system_process", meta, "connect_to_server", true)
	Core.scripts.client.network.join_server(Core.Client.data.subsystem.input.Link.data.player, Core.Client.data.host.ip + ":" + str(Core.Client.data.host.port))
	yield(Core.Client.custom_multiplayer.network_peer, "connection_succeeded")
	Core.emit_signal("system_process", meta, "connect_to_server")

static func register_world_metadata():
	Core.emit_signal("system_process", meta, "register_world_metadata", true)
	Core.emit_signal("system_process", meta, "register_world_metadata")
