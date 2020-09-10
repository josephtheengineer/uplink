extends Node
class_name ServerSystem
#warning-ignore:unused_class_variable
const meta := {
	script_name = "sys.server",
	description = """
		
	"""
}
#warning-ignore:unused_class_variable
const DEFAULT_DATA := {
	online = false,
	port = 8888,
	max_players = 100,
	map = {
		seed = 0,
		path = "user://worlds/videogame-museum",
		name = "Videogame Museum",
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
var data := DEFAULT_DATA

################################################################################

func _ready(): #################################################################
	Core.connect("reset", self, "_reset")
	Core.emit_signal("system_ready", Core.scripts.core.system.SERVER, self)            ##### READY #####

func _process(_delta):
	if not custom_multiplayer:
		return
	#Core.emit_signal("msg", "Server status: " + str(custom_multiplayer.network_peer.get_connection_status()), Core.INFO, meta)
	#if not custom_multiplayer.has_network_peer():
		#return
	custom_multiplayer.poll()


func _reset():
	data = DEFAULT_DATA

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
	name_id = "player",
	type = "input",
	id = 0,
	position = Vector3(0, 100, 0),
	velocity = Vector3(),
	direction = Vector3(),
	move_direction = null,
	mouse_sensitivity = 0.3,
	pressed = false,
	move_mode = "walk",
	mouse_attached = false,
	render_distance = 2,
	move_forward = false,
	action_mode = "nothing",
	color = Color8(255, 0, 255),
	looking_at_block = Vector3(),
	looking_at_chunk = Vector3(),
	cursor_pos = Vector3()
}

func spawn_player_at_default_pos(username: String):
	Core.emit_signal("msg", "Spawning player at last known location: " 
		+ str(Core.Server.data.map.last_location), Core.DEBUG, meta)
	
	var chunk_position = Core.scripts.chunk.tools.get_chunk(Core.Server.data.map.last_location)
	chunk_position.y = 0
	spawn_player(Core.Server.data.map.last_location, username)
	Core.scripts.client.player.main.attach(Core.get_parent().get_node("/root/World/Inputs/" + username))
	
	Core.emit_signal("msg", "Chunk: " + str(chunk_position), Core.DEBUG, 
		meta)

func spawn_player(location: Vector3, username: String):
	var player = DEFAULT_PLAYER
	player.id = username
	player.position = Vector3(location.x, 100, location.z)
	
	Core.scripts.core.manager.create(player)
	Core.scripts.client.player.main.attach(Core.get_parent().get_node("/root/World/Inputs/" + username))

func send_message(msg): #######################################################
	Core.Client.rpc("send_data", msg)
