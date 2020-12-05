extends Node
#warning-ignore:unused_class_variable
const meta := {
	script_name = "server.system",
	description = """
		
	"""
}

const GEN_FLAT = 0
const GEN_NATURAL = 1

#warning-ignore:unused_class_variable
const DEFAULT_DATA := {
	online = false,
	port = 8888,
	max_players = 100,
	map = {
		seed = 0,
		generator = {
			single_voxel = false,
			terrain_type = GEN_NATURAL
		},
		path = "unknown path",
		name = "Unknown World",
		last_location = Vector3(0, 0, 0),
		home = {
			location = Vector3(0, 0, 0),
			rotation = 0
		},
		chunks_cache_size = 0,
		total_chunks = 0,
		file = null,
		chunk_metadata = Dictionary(),
		regions = Dictionary(),
		area = Vector2(),
		size = Vector2()
	}
}
#warning-ignore:unused_class_variable
var data := DEFAULT_DATA.duplicate(true)

################################################################################

func _ready(): #################################################################
	Core.connect("reset", self, "_reset")
	Core.emit_signal("system_ready", Core.scripts.core.system_manager.SERVER, self)            ##### READY #####

func _process(_delta):
	if not custom_multiplayer:
		return
	#Core.emit_signal("msg", "Server status: " + str(custom_multiplayer.network_peer.get_connection_status()), Core.INFO, meta)
	#if not custom_multiplayer.has_network_peer():
		#return
	custom_multiplayer.poll()


func _reset():
	Core.emit_signal("msg", "Reseting server system database...", Core.DEBUG, meta)
	data = DEFAULT_DATA.duplicate(true)

func create_world(): ###########################################################
	# Needs to create chunk data but not chunk render
	# Core.Client.Chunk.create_chunk(Vector3(0, 0, 0))
	pass

func _peer_connected(id: int): #################################################
	Core.emit_signal("msg", "User " + str(id) + " connected", Core.INFO, 
		meta)
	
	Core.emit_signal("msg", "Total users: " 
		+ str(get_tree().get_network_connected_peers().size()), 
		Core.INFO, meta)


func _peer_disconnected(id: int): ##############################################
	Core.emit_signal("msg", "User " + str(id) + " disconnected", 
		Core.INFO, meta)
	Core.emit_signal("msg", "Total users: " 
		+ str(get_tree().get_network_connected_peers().size()), 
		Core.INFO, meta)

const DEFAULT_PLAYER := {
	meta = {
		system = "input",
		type = "player",
		id = "0"
	},
	position = {
		world = Vector3(0, 100, 0),
		velocity = Vector3(),
		direction = Vector3(),
		move_direction = null,
		mouse_sensitivity = 0.3,
		pressed = false,
		mode = "walk",
		mouse_attached = false,
		move_forward = false,
	},
	looking_at = {
		block = Vector3(),
		chunk = Vector3(),
	},
	action = {
		mode = "nothing",
		resolution = 1, # RES_1
		cursor_pos = Vector3()
	},
	render_distance = 2,
	color = Color8(255, 0, 255),
}

func spawn_player_at_default_pos(username: String):
	Core.emit_signal("msg", "Spawning player at last known location: " 
		+ str(Core.server.data.map.last_location), Core.DEBUG, meta)
	
	var chunk_position = Core.scripts.chunk.tools.get_chunk(Core.server.data.map.last_location)
	chunk_position.y = 0
	spawn_player(Core.server.data.map.last_location, username)
	Core.scripts.client.player.main.attach(Core.world.get_node("Input/" + username))
	
	Core.emit_signal("msg", "Chunk: " + str(chunk_position), Core.DEBUG, 
		meta)

func spawn_player(location: Vector3, username: String):
	var player = DEFAULT_PLAYER.duplicate(true)
	player.meta.id = username
	player.position.world = Vector3(location.x, 100, location.z)
	
	Core.world.get_node("Input").create(player)
	Core.scripts.client.player.main.attach(Core.world.get_node("Input/" + username))

func send_message(msg): #######################################################
	Core.client.rpc("send_data", msg)
