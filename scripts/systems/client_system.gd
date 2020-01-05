extends Node
################################################################################
#     _____ _                             
#    / ____| |                            
#   | (___ | |_ ___  _ __ __ _  __ _  ___ 
#    \___ \| __/ _ \| '__/ _` |/ _` |/ _ \
#    ____) | || (_) | | | (_| | (_| |  __/
#   |_____/ \__\___/|_|  \__,_|\__, |\___|
#                               __/ |     
#                              |___/      
################################################################################

var Debug = load("res://scripts/features/debug.gd").new()
var Diagnostics = load("res://scripts/features/diagnostics.gd").new()
var Player = load("res://scripts/features/player.gd").new()
var Entity = load("res://scripts/features/entity.gd").new()
var Comp = load("res://scripts/features/comp.gd").new()
var Manager = load("res://scripts/features/manager.gd").new()
var SystemManager = load("res://scripts/features/system_manager.gd").new()
onready var ServerSystem = get_node("/root/World/Systems/Server")
onready var ChunkSystem = get_node("/root/World/Systems/Chunk")
onready var Events = get_node("/root/Events")

var version = "EdenUniverseBuilder v3.0.0 beta6"
var total_players = 0
var players = Array()
var total_entities = 0
var blocks_loaded = 0
var blocks_found = 0
var chunk_index = []


############################# System Loaded Check ##############################
var chunk = false
var client = false
var download = false
var input = false
var interface = false
var server = false
var sound = false


#var map_file = File.new()
#var ChunkLocations = Dictionary()
#var ChunkAddresses = Dictionary()
#var ChunkMetadata = Array()


#var worldAreaX = 0
#var worldAreaY = 0
#var worldAreaWidth = 0
#var worldAreaHeight = 0

var render_distance = 2
var player_move_forward = false
var action_mode = "nothing"


#var local_data = {}
const DEFAULT_HOST = "josephtheengineer.ddns.net"
const DEFAULT_IP = "101.183.54.6"
const DEFAULT_PORT = 8888
const DEFAULT_MAX_PLAYERS = 100

const MAIN_MENU_SEED = -1


# Player info, associate ID to data
var player_info = {}
# Info we send to other players
var my_info = { name = "Ari", color = Color8(255, 0, 255) }


################################################################################
#    ______                _   _                 
#   |  ____|              | | (_)                
#   | |__ _   _ _ __   ___| |_ _  ___  _ __  ___ 
#   |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#   | |  | |_| | | | | (__| |_| | (_) | | | \__ \
#   |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#
#
################################################################################

func _ready(): #################################################################
	SystemManager.setup()
	Debug.msg("Client System ready.", "Info")
	Events.emit_signal("system_ready", "client")
	.connect("timeout", self, "_on_Timer_timeout")
	Debug.msg("Logs stored at user://logs/", "Info")
	Debug.init()
	#Diagnostics.run(self, "diagnostics_finised")
	world_loaded()


func diagnostics_finised(): ####################################################
	ServerSystem.start()
	ServerSystem.load_world(self, "world_loaded")


func world_loaded(): ###########################################################
	Debug.msg("World loaded!", "Info")
	
	var entity = Dictionary()
	entity.type = "player"
	entity.position = Vector3(0, 100, 0) #Vector3(9*16, 100, 130*16) 
	#ServerSystem.last_location * 16
	entity.username = "JosephTheEngineer"
	
	Manager.create(entity)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	#create_hud()


func create_hud(): #############################################################
	var hud = Dictionary()
	#var hud_id = Entity.create({"hud" : hud})
	
#	var terminal = Dictionary()
#	terminal.parent = Dictionary()
#	terminal.position = Vector2(0, 0)
#	terminal.debug = true
#	terminal.text = ""
#	terminal.min_size =  Vector2(500, 500)
#	terminal.parent.id = gamearea_id
#	terminal.parent.component = "horizontal_container"
#	Entity.create({"terminal" : terminal})


func init_main_menu(): #########################################################
	ChunkSystem.create_chunk(Vector3(0, 0, 0))


func init_world(): #############################################################
	var t = OS.get_unix_time()
	Debug.msg("Init took " + str(OS.get_unix_time()-t), "Info")



func _process(delta): #########################################################
	pass
#	var entities = Entity.get_entities_with("player")
#	for id in entities:
#		var components = entities[id].components
#		if components.player.rendered == false:
#			var node = get_node("/root/World/" + str(id))
#			
#			var player = load("res://scenes/player.tscn").instance()
#			node.add_child(player)
#			
#			player.translation = components.player.position
#			components.player.rendered = true
#			Entity.edit(id, components)
	
	
	
#	if ServerSystem.map_seed != -1 and Player != null:
#		if loaded == true and player_teleported == false:
#			Player.translation =  first_chunk
#			player_teleported = true
#
#		var player_chunk = get_chunk(Player.translation)
#		if player_chunk != temp_player_chunk:
#			print(player_chunk)
#			temp_player_chunk = player_chunk
		
		#if !(chunk_index.has(get_chunk(Player.translation))):
		#create_surrounding_chunks(get_chunk(Player.translation))
		#create_surrounding_chunks(get_chunk(Player.translation))
	#else:
		#pass
		#create_surrounding_chunks(get_chunk(Vector3(0, 0, 0)))


func _player_connected(id): ###################################################
	Debug.msg("User " + str(id) + " connected", "Info")
	Debug.msg("Total users: " + str(get_tree().get_network_connected_peers().size()), "Info")


func _player_disconnected(id): ################################################
	player_info.erase(id) # Erase player from info
	
	Debug.msg("User " + str(id) + " connected", "Info")
	Debug.msg("Total users: " + str(get_tree().get_network_connected_peers().size()), "Info")


func _connected_ok(): #########################################################
	# Only called on clients, not server. Send my ID and info to all the other peers
	rpc("register_player", get_tree().get_network_unique_id(), my_info)

func _server_disconnected(): ##################################################
	Debug.msg("Kicked from server!", "Info")


func _connected_fail(): #######################################################
	Debug.msg("Error connecting to server! ", "Error")


func _on_packet_received(id, packet): #########################################
	Debug.msg(packet.get_string_from_ascii(), "Chat")


func _on_ForwardButton_pressed(): #############################################
	player_move_forward = true


func _on_ForwardButton_released(): ############################################
	player_move_forward = false




############################ networking functions #############################


func join_server(username, address): ###################################################
	Debug.msg("Joining server...", "Info")
	var host = address.rsplit(":")[0]
	var port = null
	if address.rsplit(":").size() > 1:
		port = address.rsplit(":")[1]
	
	if host == null or host == "":
		host = DEFAULT_HOST
	if port == null or host == "":
		port = DEFAULT_PORT
	
	var network = NetworkedMultiplayerENet.new()
	Debug.msg("Connecting to host " + str(host) + ":" + str(port), "Info")
	Debug.msg("Client status: " + str(network.create_client(host, port)), "Debug")
	
	get_tree().set_network_peer(network)
	network.connect("connection_failed", self, "_on_connection_failed")
	
	get_tree().multiplayer.connect("network_peer_packet", self, "_on_packet_received")
	get_tree().set_meta("network_peer", network)


func leave_server(): ##########################################################
	get_tree().set_network_peer(null)


func _on_connection_failed(error):
	Debug.msg("Error connecting to server: " + error, "Error")


func send_message(msg): #######################################################
	rpc("send_data", msg)




############################## remote functions ###############################

remote func send_data(data): ##################################################
	Debug.msg(data, "Chat")


remote func register_player(id, info): ########################################
	Debug.msg("Player info: " + str(info), "Info")
	# Store the info
	player_info[id] = info
	# If I'm the server, let the new guy know about existing players
	if get_tree().is_network_server():
		#Send my info to new player
		rpc_id(id, "register_player", 1, my_info)
		# Send the info of existing players
		for peer_id in player_info:
			rpc_id(id, "register_player", peer_id, player_info[peer_id])

func world_button(world):
	pass
	#if world == 1:
		#Debug.msg("Opening world creation menu...", "Info")
		#create_new_world()
		#Debug.msg("Loading a new flat terrain world...", "Info")
		#map_path = ""
		#map_name = "New Flat Terrain World"
		#map_seed = 0
		#load_world()
	#elif world == 3:
		#pass
	#else:
		#Debug.msg("Loading a new natural terrain world...", "Info")
		#map_path = ""
		#map_name = "New Natural Terrain World"
		#map_seed = floor(rand_range(0, 9999999))
		#load_world()