extends Node
class_name ClientSystem
#warning-ignore:unused_class_variable
const meta := {
	script_name = "sys.client",
	description = """
		the client
	"""
}
#warning-ignore:unused_class_variable
var data := {
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
	player = {
		pressed = false,
		move_mode = "walk",
		mouse_attached = false,
		render_distance = 2,
		move_forward = false,
		action_mode = "nothing",
		username = "josephtheengineer",
		color = Color8(255, 0, 255)
	},
	diagnostics = {
		progress = 0
	}
}

const TOTAL_SYSTEMS := 7
const REQUIRED_SYSTEMS := 7
const DEFAULT_LOG_LOC := "user://logs/"
const DEFAULT_HOST := "josephtheengineer.ddns.net"
const DEFAULT_IP := "101.183.54.6"
const DEFAULT_PORT := 8888
const DEFAULT_MAX_PLAYERS := 100
const MAIN_MENU_SEED := -1


func _ready(): ################################################################# APP ENTRY POINT
	Core.scripts.core.debug.msg.init(data.log_path)
	Core.scripts.core.system.setup()
	Core.emit_signal("system_ready", Core.scripts.core.system.CLIENT, meta)                ##### READY #####
	
	create_chunk_system()
	create_download_system()
	create_input_system()
	create_interface_system()
	create_sound_system()
	
	var error = Core.connect("app_ready", self, "_on_app_ready")
	if error:
		Core.emit_signal("msg", "Error on binding to app_ready: " + str(error), Core.WARN, meta)
	


func create_chunk_system(): ####################################################
	Core.emit_signal("msg", "Creating chunk system...", Core.DEBUG, meta)
	var node = Node.new()
	node.set_name("Chunk")
	node.set_script(load("res://src/scripts/sys/chunk.gd"))
	get_node("/root/World/Systems").call_deferred("add_child", node)


func create_download_system(): #################################################
	Core.emit_signal("msg", "Creating download system...", Core.DEBUG, meta)
	var node = Node.new()
	node.set_name("Download")
	node.set_script(load("res://src/scripts/sys/download.gd"))
	get_node("/root/World/Systems").call_deferred("add_child", node)


func create_input_system(): ####################################################
	Core.emit_signal("msg", "Creating input system...", Core.DEBUG, meta)
	var node = Node.new()
	node.set_name("Input")
	node.set_script(load("res://src/scripts/sys/input.gd"))
	get_node("/root/World/Systems").call_deferred("add_child", node)


func create_interface_system(): ################################################
	Core.emit_signal("msg", "Creating interface system...", Core.DEBUG, meta)
	var node = Node.new()
	node.set_name("Interface")
	node.set_script(load("res://src/scripts/sys/interface.gd"))
	get_node("/root/World/Systems").call_deferred("add_child", node)


func create_sound_system(): ####################################################
	Core.emit_signal("msg", "Creating sound system...", Core.DEBUG, meta)
	var node = Node.new()
	node.set_name("Sound")
	node.set_script(load("res://src/scripts/sys/sound.gd"))
	get_node("/root/World/Systems").call_deferred("add_child", node)

signal diagnostics
func _on_app_ready(): ##########################################################
	Core.scripts.core.system.check_systems()
	Core.emit_signal("msg", "App ready!", Core.INFO, meta)
	
	Core.scripts.core.debug.diagnostics.run("diagnostics", self, "_on_diagnostics_finised")
	#world_loaded()


func _on_diagnostics_finised(): ################################################
	#ServerSystem.start()
	Core.Server.load_world(self, "_on_world_loaded")
	Core.get_parent().get_node("World/Interfaces/0").free()
	Core.scripts.interface.hud.create()


func _on_world_loaded(): #######################################################	
	Core.emit_signal("msg", "World loaded!", Core.INFO, meta)
	
	Core.scripts.chunk.helper.load_player_spawn_chunks(self, "_on_chunks_loaded")
	
	#Core.get_parent().get_node("World/Inputs/JosephTheEngineer/Player").translation = Core.Server.last_location
	
	#create_hud()

func _on_chunks_loaded(): ######################################################
	Core.emit_signal("msg", "Player spawn chunks loaded!", Core.INFO, meta)
	#InputSystem.move_mode = "walk"
	data.subsystem.Interface.update_world_map()
	data.subsystem.Interface.update_region_map()

func attach_player():
	data.player.move_mode = "fly"
	data.subsystem.input.Link.attach_mouse()
	data.player.mouse_attached = true

func init_world(): #############################################################
	var t = OS.get_unix_time()
	Core.emit_signal("msg", "Init took " + str(OS.get_unix_time()-t), Core.INFO, meta)



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
	Core.emit_signal("msg", "User " + str(id) + " connected", Core.INFO, meta)
	Core.emit_signal("msg", "Total users: " + str(get_tree().get_network_connected_peers().size()), Core.INFO, meta)


func _player_disconnected(id: int): ################################################
	if !data.player.erase(id): # Erase player from info
		emit_signal("msg", "Player not found in player_info when trying to erase on disconnect.", Core.WARN, meta)
	
	Core.emit_signal("msg", "User " + str(id) + " connected", Core.INFO, meta)
	Core.emit_signal("msg", "Total users: " + str(get_tree().get_network_connected_peers().size()), Core.INFO, meta)


func _connected_ok(): #########################################################
	# Only called on clients, not server. Send my ID and info to all the other peers
	rpc("register_player", get_tree().get_network_unique_id(), data.player)

func _server_disconnected(): ##################################################
	Core.emit_signal("msg", "Kicked from server!", Core.INFO, meta)


func _connected_fail(): #######################################################
	Core.emit_signal("msg", "Error connecting to server! ", Core.ERROR, meta)


func _on_packet_received(_id: int, packet: PoolByteArray): #########################################
	Core.emit_signal("msg", packet.get_string_from_ascii(), "Chat")


func _on_ForwardButton_pressed(): #############################################
	data.player.move_forward = true


func _on_ForwardButton_released(): ############################################
	data.player.move_forward = false

############################## remote functions ###############################

remote func send_data(data): ##################################################
	Core.emit_signal("msg", data, "Chat")


remote func register_player(id, info): ########################################
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
