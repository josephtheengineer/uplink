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
		host = Core.Client.DEFAULT_HOST
	if port == null or host == "":
		port = Core.Client.DEFAULT_PORT
	
	var network = NetworkedMultiplayerENet.new()
	Core.emit_signal("msg", "Connecting to host " + str(host) + ":" + str(port), Core.INFO, meta)
	Core.emit_signal("msg", "Client status: " + str(network.create_client(host, port)), Core.DEBUG, meta)
	
	Core.get_tree().set_network_peer(network)
	network.connect("connection_failed", meta, "_on_connection_failed")
	
	var error = Core.get_tree().multiplayer.connect("network_peer_packet", Core, "_on_packet_received")
	if error:
		Core.emit_signal("msg", "Error on binding to network_peer_packet: " 
			+ str(error), Core.WARN, meta)
	
	Core.get_tree().set_meta("network_peer", network)


static func leave_server(): ##########################################################
	Core.get_tree().set_network_peer(null)


static func _on_connection_failed(error):
	Core.emit_signal("msg", "Error connecting to server: " + error, Core.ERROR, meta)


static func send_message(msg): #######################################################
	pass
	#rpc("send_data", msg)
