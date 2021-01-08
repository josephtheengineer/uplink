extends Node
#warning-ignore:unused_class_variable
const meta := {
	script_name = "server.system",
	description = """
		
	"""
}

const GEN_FLAT = 0
const GEN_NATURAL = 1

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

# server.system._ready #########################################################
const _ready_meta := {
	func_name = "server.system._ready",
	description = """
		
	""",
		}
func _ready(args := _ready_meta) -> void: ######################################
	Core.connect("reset", self, "_reset")
	Core.emit_signal("system_ready", Core.scripts.core.system_manager.SERVER, self)            ##### READY #####
# ^ server.system._ready #######################################################


# server.system._process #######################################################
const _process_meta := {
	func_name = "server.system._process",
	description = """
		
	""",
		}
func _process(_delta, args := _process_meta) -> void: ##########################
	if not custom_multiplayer:
		return
	#Core.emit_signal("msg", "Server status: " + str(custom_multiplayer.network_peer.get_connection_status()), Core.INFO, meta)
	#if not custom_multiplayer.has_network_peer():
		#return
	custom_multiplayer.poll()
# ^ server.system._process #####################################################


# server.system._reset #########################################################
const _reset_meta := {
	func_name = "server.system._reset",
	description = """
		
	""",
		}
func _reset(args := _reset_meta) -> void: ######################################
	Core.emit_signal("msg", "Reseting server system database...", Core.DEBUG, args)
	data = DEFAULT_DATA.duplicate(true)
# ^ server.system._reset #######################################################


# server.system.create_world ###################################################
const create_world_meta := {
	func_name = "server.system.create_world",
	description = """
		
	""",
		}
func create_world(args := create_world_meta) -> void: ##########################
	# Needs to create chunk data but not chunk render
	# Core.Client.Chunk.create_chunk(Vector3(0, 0, 0))
	pass
# ^ server.system.create_world #################################################


# server.system._peer_connected ################################################
const _peer_connected_meta := {
	func_name = "server.system._peer_connected",
	description = """
		
	""",
		}
func _peer_connected(id: int, args := _peer_connected_meta) -> void: ###########
	Core.emit_signal("msg", "User " + str(id) + " connected", Core.INFO, 
		args)
	
	Core.emit_signal("msg", "Total users: " 
		+ str(get_tree().get_network_connected_peers().size()), 
		Core.INFO, meta)
# ^ server.system._peer_connected ##############################################


# server.system._peer_disconnected #############################################
const _peer_disconnected_meta := {
	func_name = "server.system._peer_disconnected",
	description = """
		
	""",
		}
func _peer_disconnected(id: int, args := _peer_disconnected_meta) -> void: #####
	Core.emit_signal("msg", "User " + str(id) + " disconnected", 
		Core.INFO, args)
	Core.emit_signal("msg", "Total users: " 
		+ str(get_tree().get_network_connected_peers().size()), 
		Core.INFO, args)
# ^ server.system._peer_disconnected ###########################################


# server.system.spawn_player_at_default_pos ####################################
const spawn_player_at_default_pos_meta := {
	func_name = "server.system.spawn_player_at_default_pos",
	description = """
		
	""",
		}
func spawn_player_at_default_pos(
		username: String, 
		args := spawn_player_at_default_pos_meta) -> void: #############
	
	Core.emit_signal("msg", "Spawning player at last known location: " 
		+ str(Core.server.data.map.last_location), Core.DEBUG, args)
	
	var chunk_position = Core.scripts.chunk.tools.get_chunk(Core.server.data.map.last_location)
	chunk_position.y = 0
	spawn_player(Core.server.data.map.last_location, username)
	Core.scripts.client.player.main.attach(Core.world.get_node("Input/" + username))
	
	Core.emit_signal("msg", "Chunk: " + str(chunk_position), Core.DEBUG, args)
# ^ server.system.spawn_player_at_default_pos ##################################


# server.system.spawn_player ###################################################
const spawn_player_meta := {
	func_name = "server.system.spawn_player",
	description = """
		
	""",
		}
func spawn_player(location: Vector3, username: String, args := spawn_player_meta) -> void:
	var player = DEFAULT_PLAYER.duplicate(true)
	player.meta.id = username
	player.position.world = Vector3(location.x, 100, location.z)
	
	if Core.world.get_node("Input").has_node(username):
		Core.emit_signal("msg", "Overwriting existing player " + username, Core.WARN, args)
		Core.world.get_node("Input/" + username).free()
	
	Core.world.get_node("Input").create(player)
	Core.scripts.client.player.main.attach(Core.world.get_node("Input/" + username))
# ^ server.system.spawn_player #################################################


# server.system.send_message ###################################################
const send_message_meta := {
	func_name = "server.system.send_message",
	description = """
		
	""",
		}
func send_message(msg, args := send_message_meta) -> void: #####################
	Core.client.rpc("send_data", msg)
# ^ server.system.send_message #################################################
