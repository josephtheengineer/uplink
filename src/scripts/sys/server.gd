extends Node
class_name ServerSystem
#warning-ignore:unused_class_variable
const meta := {
	script_name = "sys.server",
	description = """
		
	"""
}
#warning-ignore:unused_class_variable
var data := {
	online = false,
	map = {
		seed = 0,
		path = "user://worlds/videogame-museum.eden2",
		name = "Videogame Museum",
		last_location = Vector3(0, 0, 0),
		home_location = Vector3(0, 0, 0),
		home_rotation = 0,
		chunks_cache_size = 0,
		total_chunks = 0,
		file = File.new(),
		chunk_metadata = Dictionary(),
		regions = Dictionary(),
		worldAreaX = 0,
		worldAreaY = 0,
		world_width = 0,
		world_height = 0
	}
}

################################################################################

func _ready(): #################################################################
	#create_world()
	Core.emit_signal("system_ready", Core.scripts.core.system.SERVER, self)            ##### READY #####


func create_world(): ###########################################################
	# Needs to create chunk data but not chunk render
	# Core.Client.Chunk.create_chunk(Vector3(0, 0, 0))
	pass


func create_server(_username: String): ##########################################
	Core.emit_signal("msg", "Creating server...", Core.INFO, self)
	var network = NetworkedMultiplayerENet.new()
	network.create_server(8888, 100)
	get_tree().set_network_peer(network)
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")
	get_tree().set_meta("network_peer", network)


func _peer_connected(id: int): #################################################
	Core.emit_signal("msg", "User " + str(id) + " connected", Core.INFO, 
		self)
	
	Core.emit_signal("msg", "Total users: " 
		+ str(get_tree().get_network_connected_peers().size()), 
		Core.INFO, self)


func _peer_disconnected(id: int): ##############################################
	Core.emit_signal("msg", "User " + str(id) + " disconnected", 
		Core.INFO, self)
	Core.emit_signal("msg", "Total users: " 
		+ str(get_tree().get_network_connected_peers().size()), 
		Core.INFO, self)


signal world_loaded
func load_world(object: Object, method: String):
	var error := connect("world_loaded", object, method)
	if error:
		emit_signal("msg", "Error on binding to world_loaded: " 
			+ str(error), Core.WARN, self)
	
	Core.emit_signal("msg", "Loading world...", Core.INFO, self)
	Core.emit_signal("msg", "Running demo preset...", Core.INFO, self)
	Core.emit_signal("msg", "Removing all entities...", Core.DEBUG, self)
	#for id in Entity.objects:
		#Entity.destory(id)
	
	Core.scripts.eden.world_decoder.load_world()
	Core.emit_signal("msg", "Spawning player at last known location: " 
		+ str(data.map.last_location), Core.DEBUG, self)
	
	var chunk_position = Core.scripts.chunk.tools.get_chunk(data.map.last_location)
	chunk_position.y = 0
	spawn_player(data.map.last_location, Core.Client.data.player.username)
	Core.Client.attach_player()
	
	Core.emit_signal("msg", "Chunk: " + str(chunk_position), Core.DEBUG, 
		self)
	
	#Core.emit_signal("msg", str(EdenWorldDecoder.get_chunk_data(chunk_position)), Core.TRACE, self)
	Core.scripts.chunk.manager.create_chunk(Vector3(0, 0, 0))
	emit_signal("world_loaded")

func spawn_player(location, username):
	var player = Dictionary()
	player.name_id = "player"
	player.type = "input"
	player.id = "JosephTheEngineer"
	player.position = Vector3(location.x, 100, location.z) #Vector3(9*16, 100, 130*16) 
	#ServerSystem.last_location * 16
	player.username = username
	
	Core.scripts.core.manager.create(player)
