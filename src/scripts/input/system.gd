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

func _ready(): #################################################################
	set_process_input(true)
	Core.connect("reset", self, "_reset")
	Core.emit_signal("system_ready", Core.scripts.core.system_manager.INPUT, self)             ##### READY #####

func _reset():
	Core.emit_signal("msg", "Reseting input system database...", Core.DEBUG, meta)
	data = DEFAULT_DATA.duplicate(true)

func _chat_input():
	var node: TextEdit = Core.world.get_node(data.input_path)
	emit_signal("chat_input", node, node.text)

func _input(event: InputEvent): ############################################################	
	if has_node(data.player):
		#if !Core.get_parent().has_node("World/Inputs/" + data.player).components.has("player"):
		#	breakpoint
		var Player = get_node(data.player)
		var player_data = Player.components
		
		if player_data.mouse_attached:
			if event is InputEventMouseMotion:
				Core.scripts.client.player.move.look(Player, event)
		
		if event.is_action_pressed("burn"):
			Core.emit_signal("msg", "Changing action_mode to burn...", Core.INFO, meta)
			player_data.action.mode = "burn"
	
		if event.is_action_pressed("mine"):
			Core.emit_signal("msg", "Changing action_mode to mine...", Core.INFO, meta)
			player_data.action.mode = "mine"
		
		if event.is_action_pressed("build"):
			Core.emit_signal("msg", "Changing action_mode to build...", Core.INFO, meta)
			player_data.action.mode = "build"
		
		if event.is_action_pressed("paint"):
			Core.emit_signal("msg", "Changing action_mode to paint...", Core.INFO, meta)
			player_data.action.mode = "paint"
		
		if event.is_action_pressed("ui_cancel"):
			Core.emit_signal("msg", "Cancel event received", Core.DEBUG, meta)
			if player_data.mouse_attached:
				detach_mouse(Player)
			else:
				attach_mouse(Player)
		
		if event.is_action_pressed("action"):
			Core.scripts.client.player.interact.action(Player, event.position)
		Core.scripts.client.player.interact.update_looking_at_block(Player)
	
	if data.setup_chat_input and Core.world.has_node("Interface/Hud"):
		var error: int = Core.world.get_node(data.input_path).connect("text_changed", self, "_chat_input")
		if error:
			Core.emit_signal("msg", "Error on binding to text_changed on _chat_input"
				+ ": " + str(error), Core.WARN, meta)
		data.setup_chat_input = false
	
	if has_node(data.player):
		var player: Entity = get_node(data.player)
		if event.is_action_pressed("fly"):
			if player.components.position.mode == "walk":
				Core.emit_signal("msg", "Changing move_mode to fly...", Core.INFO, meta)
				player.components.position.mode = "fly"
			else:
				Core.emit_signal("msg", "Changing move_mode to walk...", Core.INFO, meta)
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
		data.history_line += 1
		print(data.history_line)
		if data.history_line >= 0:
			var file = File.new()
			file.open(Core.client.data.cmd_history_file, File.READ_WRITE)
			var history = file.get_as_text().split("\n", false)
			history.invert()
			if data.history_line < history.size():
				var next_text = history[data.history_line-1]
				Core.world.get_node(data.input_path).text = next_text
			else:
				data.history_line = history.size()
			file.close()
		else:
			data.history_line = 0
	if event.is_action_pressed("ui_down"):
		data.history_line -= 1
		print(data.history_line)
		if data.history_line >= 0:
			var file = File.new()
			file.open(Core.client.data.cmd_history_file, File.READ_WRITE)
			var history = file.get_as_text().split("\n", false)
			history.invert()
			if data.history_line < history.size():
				var next_text = history[data.history_line-1]
				Core.world.get_node(data.input_path).text = next_text
			else:
				data.history_line = history.size()
			file.close()
		else:
			data.history_line = 0
	if event.is_action_pressed("ui_focus_next"):
		pass
		#Core.world.get_node(data.input_path).text = data.last_text
	if event.is_action_pressed("ui_cancel"):
		Core.world.get_node(data.input_path).text = ""

func create(entity: Dictionary):
	if entity.meta.system != "input":
		Core.emit_signal("msg", "Input entity create called with incorrect system set", Core.WARN, meta)
		return false
	
	if entity.meta.type == "player":
		var node = Entity.new()
		node.set_name(entity.meta.id)
		add_child(node)
		get_node(entity.meta.id).components = entity
		get_node(entity.meta.id).add_child(Core.scenes.world.player.instance())
		get_node(entity.meta.id + "/Player").translation = entity.position.world

func detach_mouse(Player: Entity): ###########################################################
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Player.components.mouse_attached = false

func attach_mouse(Player: Entity): ###########################################################
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Player.components.mouse_attached = true

func _physics_process(delta): ##################################################
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
