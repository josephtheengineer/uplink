extends Node
class_name ClientSystem
#warning-ignore:unused_class_variable
const script_name := "client_system"
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

#warning-ignore:unused_class_variable
onready var ChunkSystem
#warning-ignore:unused_class_variable
onready var DownloadSystem
#warning-ignore:unused_class_variable
onready var InputSystem
#warning-ignore:unused_class_variable
onready var InterfaceSystem
#warning-ignore:unused_class_variable
onready var SoundSystem

onready var Debug :=            preload("res://src/scripts/debug/debug.gd").new()
onready var Diagnostics :=      preload("res://src/scripts/debug/diagnostics.gd").new()
onready var Player :=           preload("res://src/scripts/world/player.gd").new()
onready var Manager :=          preload("res://src/scripts/manager/manager.gd").new()
onready var SystemManager :=    preload("res://src/scripts/manager/system.gd").new()
onready var Hud :=              preload("res://src/scripts/hud/hud.gd").new()

#warning-ignore:unused_class_variable
var version := "Uplink v0.0.0 beta0"
#warning-ignore:unused_class_variable
var total_players := 0
#warning-ignore:unused_class_variable
var players := Array()
#warning-ignore:unused_class_variable
var total_entities := 0
#warning-ignore:unused_class_variable
var blocks_loaded := 0
#warning-ignore:unused_class_variable
var blocks_found := 0
#warning-ignore:unused_class_variable
var chunk_index := []


############################# System Loaded Check ##############################
#warning-ignore:unused_class_variable
var chunk := false
const CHUNK_REQUIRED := false

#warning-ignore:unused_class_variable
var client := false
const CLIENT_REQUIRED := true

#warning-ignore:unused_class_variable
var download := false
const DOWNLOAD_REQUIRED := false

#warning-ignore:unused_class_variable
var input := false
const INPUT_REQUIRED := false

#warning-ignore:unused_class_variable
var interface := false
const INTERFACE_REQUIRED := false

#warning-ignore:unused_class_variable
var server := false
const SERVER_REQUIRED := true

#warning-ignore:unused_class_variable
var sound := false
const SOUND_REQUIRED := false

const TOTAL_SYSTEMS := 7

const DEFAULT_LOG_LOC := "user://logs/"
var log_loc := "user://logs/"

var pressed := false
var move_mode := "walk"
var mouse_attached := false

#var map_file = File.new()
#var ChunkLocations = Dictionary()
#var ChunkAddresses = Dictionary()
#var ChunkMetadata = Array()


#var worldAreaX = 0
#var worldAreaY = 0
#var worldAreaWidth = 0
#var worldAreaHeight = 0

var render_distance := 2
var player_move_forward := false
var action_mode := "nothing"
var username := "JosephTheEngineer"

#var local_data = {}
const DEFAULT_HOST := "josephtheengineer.ddns.net"
const DEFAULT_IP := "101.183.54.6"
const DEFAULT_PORT := 8888
const DEFAULT_MAX_PLAYERS := 100

const MAIN_MENU_SEED := -1


# Player info, associate ID to data
var player_info := {}
# Info we send to other players
var my_info := { name = "Ari", color = Color8(255, 0, 255) }


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

func _ready(): ################################################################# APP ENTRY POINT
	Debug.init(log_loc)
	SystemManager.setup()
	Core.emit_signal("system_ready", SystemManager.CLIENT, self)                ##### READY #####
	
	create_chunk_system()
	create_download_system()
	create_input_system()
	create_interface_system()
	create_sound_system()
	
	var error = Core.connect("app_ready", self, "_on_app_ready")
	if error:
		Core.emit_signal("msg", "Error on binding to app_ready: " + str(error), Debug.WARN, self)
	


func create_chunk_system(): ####################################################
	Core.emit_signal("msg", "Creating chunk system...", Debug.DEBUG, self)
	var node = Node.new()
	node.set_name("Chunk")
	node.set_script(load("res://scripts/systems/chunk_system.gd"))
	get_node("/root/World/Systems").call_deferred("add_child", node)


func create_download_system(): #################################################
	Core.emit_signal("msg", "Creating download system...", Debug.DEBUG, self)
	var node = Node.new()
	node.set_name("Download")
	node.set_script(load("res://scripts/systems/download_system.gd"))
	get_node("/root/World/Systems").call_deferred("add_child", node)


func create_input_system(): ####################################################
	Core.emit_signal("msg", "Creating input system...", Debug.DEBUG, self)
	var node = Node.new()
	node.set_name("Input")
	node.set_script(load("res://scripts/systems/input_system.gd"))
	get_node("/root/World/Systems").call_deferred("add_child", node)


func create_interface_system(): ################################################
	Core.emit_signal("msg", "Creating interface system...", Debug.DEBUG, self)
	var node = Node.new()
	node.set_name("Interface")
	node.set_script(load("res://scripts/systems/interface_system.gd"))
	get_node("/root/World/Systems").call_deferred("add_child", node)


func create_sound_system(): ####################################################
	Core.emit_signal("msg", "Creating sound system...", Debug.DEBUG, self)
	var node = Node.new()
	node.set_name("Sound")
	node.set_script(load("res://scripts/systems/sound_system.gd"))
	get_node("/root/World/Systems").call_deferred("add_child", node)


func _on_app_ready(): ##########################################################
	SystemManager.check_systems()
	Core.emit_signal("msg", "App ready!", Debug.INFO, self)
	
	Diagnostics.run(self, "_on_diagnostics_finised")
	#world_loaded()


func _on_diagnostics_finised(): ################################################
	#ServerSystem.start()
	Core.Server.load_world(self, "_on_world_loaded")
	Core.get_parent().get_node("World/Interfaces/0").free()
	Hud.create()


func _on_world_loaded(): #######################################################	
	Core.emit_signal("msg", "World loaded!", Debug.INFO, self)
	
	ChunkSystem.load_player_spawn_chunks(self, "_on_chunks_loaded")
	
	#Core.get_parent().get_node("World/Inputs/JosephTheEngineer/Player").translation = Core.Server.last_location
	
	#create_hud()

func _on_chunks_loaded(): ######################################################
	Core.emit_signal("msg", "Player spawn chunks loaded!", Debug.INFO, self)
	#InputSystem.move_mode = "walk"
	InterfaceSystem.update_world_map()
	InterfaceSystem.update_region_map()

func attach_player():
	Core.Client.move_mode = "fly"
	Core.Client.InputSystem.attach_mouse()
	Core.Client.mouse_attached = true

func init_world(): #############################################################
	var t = OS.get_unix_time()
	Core.emit_signal("msg", "Init took " + str(OS.get_unix_time()-t), Debug.INFO, self)



#func _process(delta): #########################################################
#	pass
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


func _player_connected(id: int): ###################################################
	Core.emit_signal("msg", "User " + str(id) + " connected", Debug.INFO, self)
	Core.emit_signal("msg", "Total users: " + str(get_tree().get_network_connected_peers().size()), Debug.INFO, self)


func _player_disconnected(id: int): ################################################
	if !player_info.erase(id): # Erase player from info
		emit_signal("msg", "Player not found in player_info when trying to erase on disconnect.", Debug.WARN, self)
	
	Core.emit_signal("msg", "User " + str(id) + " connected", Debug.INFO, self)
	Core.emit_signal("msg", "Total users: " + str(get_tree().get_network_connected_peers().size()), Debug.INFO, self)


func _connected_ok(): #########################################################
	# Only called on clients, not server. Send my ID and info to all the other peers
	rpc("register_player", get_tree().get_network_unique_id(), my_info)

func _server_disconnected(): ##################################################
	Core.emit_signal("msg", "Kicked from server!", Debug.INFO, self)


func _connected_fail(): #######################################################
	Core.emit_signal("msg", "Error connecting to server! ", Debug.ERROR, self)


func _on_packet_received(id: int, packet: PoolByteArray): #########################################
	Core.emit_signal("msg", packet.get_string_from_ascii(), "Chat")


func _on_ForwardButton_pressed(): #############################################
	player_move_forward = true


func _on_ForwardButton_released(): ############################################
	player_move_forward = false




############################ networking functions #############################


func join_server(nickname: String, address: String): ###################################################
	Core.emit_signal("msg", "Joining server...", Debug.INFO, self)
	var host = address.rsplit(":")[0]
	var port = null
	if address.rsplit(":").size() > 1:
		port = address.rsplit(":")[1]
	
	if host == null or host == "":
		host = DEFAULT_HOST
	if port == null or host == "":
		port = DEFAULT_PORT
	
	var network = NetworkedMultiplayerENet.new()
	Core.emit_signal("msg", "Connecting to host " + str(host) + ":" + str(port), Debug.INFO, self)
	Core.emit_signal("msg", "Client status: " + str(network.create_client(host, port)), Debug.DEBUG, self)
	
	get_tree().set_network_peer(network)
	network.connect("connection_failed", self, "_on_connection_failed")
	
	var error = get_tree().multiplayer.connect("network_peer_packet", self, "_on_packet_received")
	if error:
		emit_signal("msg", "Error on binding to network_peer_packet: " 
			+ str(error), Debug.WARN, self)
	
	get_tree().set_meta("network_peer", network)


func leave_server(): ##########################################################
	get_tree().set_network_peer(null)


func _on_connection_failed(error):
	Core.emit_signal("msg", "Error connecting to server: " + error, Debug.ERROR, self)


func send_message(msg): #######################################################
	rpc("send_data", msg)




############################## remote functions ###############################

remote func send_data(data): ##################################################
	Core.emit_signal("msg", data, "Chat")


remote func register_player(id, info): ########################################
	Core.emit_signal("msg", "Player info: " + str(info), Debug.INFO, self)
	# Store the info
	player_info[id] = info
	# If I'm the server, let the new guy know about existing players
	if get_tree().is_network_server():
		#Send my info to new player
		rpc_id(id, "register_player", 1, my_info)
		# Send the info of existing players
		for peer_id in player_info:
			rpc_id(id, "register_player", peer_id, player_info[peer_id])
