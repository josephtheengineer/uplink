#warning-ignore:unused_class_variable
const meta := {
	script_name = "server.bootup",
	type = "process",
	steps = [
		"load_world",
		"accept_connections"
	],
	description = """
		
	"""
}

static func load_world():
	Core.emit_signal("system_process", meta, "load_world", true)
	
	#Core.emit_signal("msg", "Removing all entities...", Core.DEBUG, meta)
	#for id in Entity.objects:
		#Entity.destory(id)
	
	Core.emit_signal("msg", "Loading world...", Core.INFO, meta)
	Core.scripts.chunk.eden.world_decoder.load_world()
	#Core.scripts.chunk.manager.create_chunk(Vector3(0, 0, 0))
	
	Core.emit_signal("system_process", meta, "load_world")

static func accept_connections():
	Core.emit_signal("system_process", meta, "accept_connections", true)
	
	Core.emit_signal("msg", "Creating server...", Core.INFO, meta)
	
	# Create new MultiplayerAPI so that client and server can run on the same scene
	Core.server.custom_multiplayer = MultiplayerAPI.new()
	Core.server.custom_multiplayer.set_root_node(Core.client)
	
	var network = NetworkedMultiplayerENet.new()
	network.connect("peer_connected", Core.server, "_peer_connected")
	network.connect("peer_disconnected", Core.server, "_peer_disconnected")
	var error = network.create_server(Core.server.data.port, Core.server.data.max_players)
	Core.emit_signal("msg", "Server start code: " + str(error), Core.INFO, meta)
	Core.server.custom_multiplayer.network_peer = network
	#network.refuse_new_connections = false
	#network.connect("connected_to_server", Core.Server, "_peer_disconnected")
	#network.connect("connection_failed", Core.Server, "_peer_disconnected")
	#network.connect("server_disconnected", Core.Server, "_peer_disconnected")
	#Core.get_tree().set_meta("network_peer", network)
	
	Core.emit_signal("system_process", meta, "accept_connections")
