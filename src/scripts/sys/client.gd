extends Node
class_name ClientSystem
#warning-ignore:unused_class_variable
const meta := {
	script_name = "sys.client",
	description = """
		the client
		- bring online systems
		- check systems & run diagnostics
		- load hud (interface?)
		
		loading world
		- interface system provides params
		- connect / contact / bootup server
		- fetch player pos and world metadata from server
		- spawn player at position (fly)
		- get surrounding chunks from server
		
		player move
		- input system transfers input into client data & signals
		- client system transfers vars to server && server sends vars
		back
	"""
}
#warning-ignore:unused_class_variable
const DEFAULT_DATA := {
	online = false,
	subsystem = {
		chunk = {
			required = true,
			online = false,
			Link = null,
		},
		download = {
			required = true,
			online = false,
			Link = null,
		},
		input = {
			required = true,
			online = false,
			Link = null,
		},
		interface = {
			required = true,
			online = false,
			Link = null,
		},
		sound = {
			required = true,
			online = false,
			Link = null,
		}
	},
	version = "Uplink v0.0.0 beta0",
	total_players = 0,
	players = Array(),
	total_entities = 0,
	blocks_loaded = 0,
	blocks_found = 0,
	chunk_index = [],
	log_path = "user://logs/",
	diagnostics = {
		progress = 0
	},
	host = {
		ip = "localhost",
		port = 8888
	},
	since_2gb_warn = -1,
	since_3gb_warn = -1,
}
#warning-ignore:unused_class_variable
var data := DEFAULT_DATA.duplicate()

const TOTAL_SYSTEMS := 7
const REQUIRED_SYSTEMS := 7
const DEFAULT_LOG_LOC := "user://logs/"
const DEFAULT_HOST := "josephtheengineer.ddns.net"
const DEFAULT_IP := "101.183.54.6"
const DEFAULT_PORT := 8888
const DEFAULT_MAX_PLAYERS := 100
const MAIN_MENU_SEED := -1

# bootup #######################################################################
func _ready(): ################################################################# APP ENTRY POINT
	Core.emit_signal("system_process_start", "client.bootup")
	Core.connect("reset", self, "_reset")
	Core.emit_signal("system_ready", Core.scripts.core.system.CLIENT, self)                ##### READY #####

func _process(_delta):
	if not custom_multiplayer:
		return
	#if not custom_multiplayer.network_peer:
		#return
	custom_multiplayer.poll()
	#Core.emit_signal("msg", "Client status: " + str(custom_multiplayer.network_peer.get_connection_status()), Core.INFO, meta)

func _reset():
	Core.emit_signal("msg", "Terminating subsystems...", Core.DEBUG, meta)
	data.subsystem.chunk.Link.queue_free()
	data.subsystem.download.Link.queue_free()
	data.subsystem.input.Link.queue_free()
	data.subsystem.interface.Link.queue_free()
	data.subsystem.sound.Link.queue_free()
	Core.emit_signal("msg", "Reseting client system database...", Core.DEBUG, meta)
	data = DEFAULT_DATA.duplicate()
	Core.emit_signal("msg", "Booting subsystems...", Core.DEBUG, meta)
	#Core.scripts.client.bootup.bring_systems_online()
	#Core.scripts.client.bootup.check_systems()

# make sure that the chunks that the player is in are loaded ###################
#signal chunks_loaded
func _on_world_loaded(): #######################################################
	Core.emit_signal("msg", "World loaded!", Core.INFO, meta)
	
	
	
	#Core.get_parent().get_node("World/Inputs/JosephTheEngineer/Player").translation = Core.Server.last_location
	
	#create_hud()



# render maps ##################################################################
func _on_chunks_loaded(): ######################################################
	Core.emit_signal("msg", "Player spawn chunks loaded!", Core.INFO, meta)
	#InputSystem.move_mode = "walk"
	data.subsystem.interface.Link.update_world_map()
	data.subsystem.interface.Link.update_region_map()

################################################################################



# signal processing ############################################################
func _player_connected(id: int): ###############################################
	Core.emit_signal("msg", "User " + str(id) + " connected", Core.INFO, meta)
	Core.emit_signal("msg", "Total users: " + str(get_tree().get_network_connected_peers().size()), Core.INFO, meta)


func _player_disconnected(id: int): ############################################
	if !data.player.erase(id): # Erase player from info
		emit_signal("msg", "Player not found in player_info when trying to erase on disconnect.", Core.WARN, meta)
	
	Core.emit_signal("msg", "User " + str(id) + " connected", Core.INFO, meta)
	Core.emit_signal("msg", "Total users: " + str(get_tree().get_network_connected_peers().size()), Core.INFO, meta)


func _connected_ok(): ##########################################################
	# Only called on clients, not server. Send my ID and info to all the other peers
	rpc("register_player", get_tree().get_network_unique_id(), data.player)

func _server_disconnected(): ###################################################
	Core.emit_signal("msg", "Kicked from server!", Core.INFO, meta)


func _connected_fail(): ########################################################
	Core.emit_signal("msg", "Error connecting to server! ", Core.ERROR, meta)


func _on_packet_received(_id: int, packet: PoolByteArray): #####################
	Core.emit_signal("msg", packet.get_string_from_ascii(), "Chat")

func _on_connection_succeeded():
	Core.emit_signal("msg", "Connection succeeded!", Core.INFO, meta)

func _on_ForwardButton_pressed(): ##############################################
	data.player.move_forward = true


func _on_ForwardButton_released(): #############################################
	data.player.move_forward = false

func _on_connection_failed():
	Core.emit_signal("msg", "Error connecting to server! ", Core.ERROR, meta)

func _stop_player(player: AudioStreamPlayer3D):
	player.stop()
	player.queue_free()

# remote functions #############################################################
remote func send_data(remote_data): ############################################
	Core.emit_signal("msg", "CHAT: " + str(remote_data), Core.INFO, meta)


remote func register_player(id, info): #########################################
	Core.emit_signal("msg", "Player info: " + str(info), Core.INFO, meta)
	# Store the info
	#data.player[id] = info
	var my_info = {}
	# If I'm the server, let the new guy know about existing players
	if get_tree().is_network_server():
		#Send my info to new player
		rpc_id(id, "register_player", 1, my_info)
		# Send the info of existing players
		#for peer_id in player_info:
			#rpc_id(id, "register_player", peer_id, player_info[peer_id])
