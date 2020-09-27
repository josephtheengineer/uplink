#warning-ignore:unused_class_variable
const meta := {
	script_name = "client.network",
	description = """
		
	"""
}

static func join_server(_nickname: String, address: String): ###################################################
	Core.emit_signal("msg", "Joining server...", Core.INFO, meta)
	var host = address.rsplit(":")[0]
	var port = null
	if address.rsplit(":").size() > 1:
		port = address.rsplit(":")[1]
	
	if host == null or host == "":
		host = Core.client.DEFAULT_HOST
	if port == null or host == "":
		port = Core.client.DEFAULT_PORT
	
	# Create new MultiplayerAPI so that client and server can run on the same scene
	Core.client.custom_multiplayer = MultiplayerAPI.new()
	Core.client.custom_multiplayer.set_root_node(Core.server)
	
	var network = NetworkedMultiplayerENet.new()
	network.connect("connection_failed", Core.client, "_on_connection_failed")
	network.connect("connection_succeeded", Core.client, "_on_connection_succeeded")
	
	Core.emit_signal("msg", "Connecting to host " + str(host) + ":" + str(port), Core.INFO, meta)
	Core.emit_signal("msg", "Client code: " + str(network.create_client(host, int(port))), Core.INFO, meta)
	Core.client.custom_multiplayer.network_peer = network
	
	Core.emit_signal("msg", "Client status: " + str(network.get_connection_status()), Core.INFO, meta)
	
	var error = Core.client.multiplayer.connect("network_peer_packet", Core.client, "_on_packet_received")
	if error:
		Core.emit_signal("msg", "Error on binding to network_peer_packet: " 
			+ str(error), Core.WARN, meta)
	
	#Core.get_tree().set_meta("network_peer", network)


static func leave_server(): ##########################################################
	Core.get_tree().set_network_peer(null)
