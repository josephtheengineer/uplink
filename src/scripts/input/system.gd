extends Node
#warning-ignore:unused_class_variable
const meta := {
	script_name = "input.system",
	description = """
		just routes input signals to other systems
	"""
}
#warning-ignore:unused_class_variable
const DEFAULT_DATA := {
	setup_chat_input = true,
	input_path = "Interface/Hud/Hud/HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer/Chat/TextEdit",
	player = "default",
	history_line = 0
}
#warning-ignore:unused_class_variable
var data := DEFAULT_DATA.duplicate(true)

signal chat_input(obj, input)

enum direction {
	UP
	DOWN
	LEFT
	RIGHT
}


# input.system._ready ##########################################################
const _ready_meta := {
	func_name = "input.system._ready",
	description = """
		Connects reset and sets input system to online
	""",
		}
func _ready(args := _ready_meta) -> void: ######################################
	set_process_input(true)
	Core.connect("reset", self, "_reset")
	Core.emit_signal("system_ready", Core.scripts.core.system_manager.INPUT, self)             ##### READY #####
# ^ input.system._ready ########################################################


# input.system._reset ##########################################################
const _reset_meta := {
	func_name = "input.system._reset",
	description = """
		Resets the input system database
	""",
		}
func _reset(args := _reset_meta) -> void: ######################################
	Core.emit_signal("msg", "Reseting input system database...", Core.DEBUG, args)
	data = DEFAULT_DATA.duplicate(true)
# input.system._reset ##########################################################


# input.system._chat_input #####################################################
const _chat_input_meta := {
	func_name = "input.system._chat_input",
	description = """
		Handles global chat window type event by sending a signal
	""",
		}
func _chat_input(args := _chat_input_meta) -> void: ############################
	var node: TextEdit = Core.world.get_node(data.input_path)
	emit_signal("chat_input", node, node.text)
# ^ input.system._chat_input ###################################################


# input.system._input ##########################################################
const _input_meta := {
	func_name = "input.system._input",
	description = """
		Main entry point to recieve input events
	""",
		}
func _input(event: InputEvent, args := _input_meta) -> void: ###################
	if has_node(data.player):
		#if !Core.get_parent().has_node("World/Inputs/" + data.player).components.has("player"):
		#	breakpoint
		var Player = get_node(data.player)
		var player_data = Player.components
		
		if player_data.mouse_attached:
			if event is InputEventMouseMotion:
				Core.scripts.client.player.move.look(Player, event)
		
		if event.is_action_pressed("burn"):
			Core.emit_signal("msg", "Changing action_mode to burn...", Core.INFO, args)
			player_data.action.mode = "burn"
	
		if event.is_action_pressed("mine"):
			Core.emit_signal("msg", "Changing action_mode to mine...", Core.INFO, args)
			player_data.action.mode = "mine"
		
		if event.is_action_pressed("build"):
			Core.emit_signal("msg", "Changing action_mode to build...", Core.INFO, args)
			player_data.action.mode = "build"
		
		if event.is_action_pressed("paint"):
			Core.emit_signal("msg", "Changing action_mode to paint...", Core.INFO, args)
			player_data.action.mode = "paint"
		
		if event.is_action_pressed("ui_cancel"):
			Core.emit_signal("msg", "Cancel event received", Core.DEBUG, args)
			if player_data.mouse_attached:
				detach_mouse(Player)
			else:
				attach_mouse(Player)
		
		if event.is_action_pressed("action"):
			var action_event: InputEventMouse = event
			Core.scripts.client.player.interact.action(Player, action_event.position)
		Core.scripts.client.player.interact.update_looking_at_block(Player)
	
	if data.setup_chat_input and Core.world.has_node("Interface/Hud"):
		var error: int = Core.world.get_node(data.input_path).connect("text_changed", self, "_chat_input")
		if error:
			Core.emit_signal("msg", "Error on binding to text_changed on _chat_input"
				+ ": " + str(error), Core.WARN, args)
		data.setup_chat_input = false
	
	if has_node(data.player):
		var player: Entity = get_node(data.player)
		if event.is_action_pressed("fly"):
			if player.components.position.mode == "walk":
				Core.emit_signal("msg", "Changing move_mode to fly...", Core.INFO, args)
				player.components.position.mode = "fly"
			else:
				Core.emit_signal("msg", "Changing move_mode to walk...", Core.INFO, args)
				player.components.position.mode = "walk"
	
	if event is InputEventScreenTouch:
		pass
		#action(event.position)
	
	if event.is_action_pressed("open_world_map"):
		Core.scripts.debug.panel.open_world_map()
	if event.is_action_pressed("open_region_map"):
		Core.scripts.debug.panel.open_region_map()
	if event.is_action_pressed("open_chunk_map"):
		Core.scripts.debug.panel.open_chunk_map()
	if event.is_action_pressed("open_system_status"):
		Core.scripts.debug.panel.open_system_status()
	if event.is_action_pressed("open_entity_analysis"):
		Core.scripts.debug.panel.open_entity_analysis()
	if event.is_action_pressed("open_core_analysis"):
		Core.scripts.debug.panel.open_core_analysis()
	if event.is_action_pressed("open_chat"):
		Core.scripts.debug.panel.open_chat()
	
	if event.is_action_pressed("ui_up"):
		Core.emit_signal("msg", "History index: " + str(data.history_line), Core.DEBUG, args)
		var file = File.new()
		file.open(Core.client.data.cmd_history_file, File.READ)
		var history = file.get_as_text().split("\n", false)
		if history:
			history.invert()
			if data.history_line < history.size():
				data.history_line += 1
			else:
				data.history_line = history.size()
			
			var next_text = history[data.history_line-1]
			Core.world.get_node(data.input_path).text = ""
			Core.world.get_node(data.input_path).call_deferred("insert_text_at_cursor", next_text)
			file.close()
	if event.is_action_pressed("ui_down"):
		if data.history_line > 1:
			data.history_line -= 1
		Core.emit_signal("msg", "History index: " + str(data.history_line), Core.DEBUG, args)
		var file = File.new()
		file.open(Core.client.data.cmd_history_file, File.READ)
		var history = file.get_as_text().split("\n", false)
		if history:
			history.invert()
			var next_text = history[data.history_line-1]
			Core.world.get_node(data.input_path).text = next_text
			file.close()
	if event.is_action_pressed("ui_focus_next"):
		pass
		#Core.world.get_node(data.input_path).text = data.last_text
	if event.is_action_pressed("ui_cancel"):
		Core.world.get_node(data.input_path).text = ""
# ^ input.system._input ########################################################


# input.system.create ##########################################################
const create_meta := {
	func_name = "input.system.create",
	description = """
		Creates interface system nodes
	""",
		error = null}
func create(entity: Dictionary, args := create_meta) -> void: ##################
	if entity.meta.system != "input":
		Core.emit_signal("msg", "Input entity create called with incorrect system set", Core.WARN, args)
		args.error = "Input entity create called with incorrect system set"
		return
	
	if entity.meta.type == "player":
		var node = Entity.new()
		node.set_name(entity.meta.id)
		add_child(node)
		var player: Entity = get_node(entity.meta.id)
		player.components = entity
		player.add_child(Core.scenes.world.player.instance())
		var player_node: KinematicBody = player.get_node("Player")
		player_node.translation = entity.position.world
# ^ input.system.create ########################################################


# input.system.detach_mouse ####################################################
const detach_mouse_meta := {
	func_name = "input.system.detach_mouse",
	description = """
		
	""",
		}
func detach_mouse(Player: Entity, args := detach_mouse_meta) -> void: ##########
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Player.components.mouse_attached = false
# ^ input.system.detach_mouse ##################################################


# input.system.attach_mouse ####################################################
const attach_mouse_meta := {
	func_name = "input.system.attach_mouse",
	description = """
		
	""",
		}
func attach_mouse(Player: Entity, args := attach_mouse_meta) -> void: ##########
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Player.components.mouse_attached = true
# ^ input.system.attach_mouse ##################################################


# input.system._physics_process ################################################
const _physics_process_meta := {
	func_name = "input.system._physics_process",
	description = """
		
	""",
		}
func _physics_process(delta: float, args := _physics_process_meta) -> void: ####
#	for node in Manager.get_entities_with("Input"):
#		var components = node.components
#		if components.has("player"):
#			connect("submit", components.text_input.object, components.text_input.method, [id])
	if data.has("player"):
		if has_node(data.player):
			var player_path = data.player + "/" 
			var node = get_node(player_path)
			var capsule: CollisionShape = get_node(player_path + "Player/Capsule")
			if node.components.position.mode == "walk":
				Core.scripts.client.player.move.walk(node, delta)
				capsule.disabled = false
			else:
				Core.scripts.client.player.move.fly(node, delta)
				capsule.disabled = true
	
			#if event is InputEventKey and event.pressed:
				#if event.scancode == KEY_ENTER:
					#emit_signal("submit")
				#components.text_input.text += event.as_text()
# input.system._physics_process ################################################
