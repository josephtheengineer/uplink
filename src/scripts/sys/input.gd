# just routes input signals to other systems
extends Node
#warning-ignore:unused_class_variable
const script_name := "input_system"
onready var Debug = preload("res://src/scripts/debug/debug.gd").new()
onready var Player = preload("res://src/scripts/world/player.gd").new()
onready var Manager = preload("res://src/scripts/manager/manager.gd").new()
onready var Comp = preload("res://src/scripts/entity/comp.gd").new()
onready var SystemManager = preload("res://src/scripts/manager/system.gd").new()
onready var DebugPanel = preload("res://src/scripts/debug/panel.gd").new()

enum direction {
	UP
	DOWN
	LEFT
	RIGHT
}

################################################################################

func _ready(): #################################################################
	set_process_input(true)
	Core.emit_signal("system_ready", SystemManager.INPUT, self)             ##### READY #####


func _input(event): ############################################################p
	if Core.get_parent().has_node("World/Inputs/JosephTheEngineer"):
		var player = get_node("/root/World/Inputs/JosephTheEngineer")
		if Core.Client.mouse_attached:
			if event is InputEventMouseMotion:
				Player.player_move_head(event, player)
		
		#elif event.is_action_pressed("action"):
			#Player.player_action(event, player)
	
	if event.is_action_pressed("fly"):
		if Core.Client.move_mode == "walk":
			Core.emit_signal("msg", "Changing move_mode to fly...", Debug.INFO, self)
			Core.Client.move_mode = "fly"
		else:
			Core.emit_signal("msg", "Changing move_mode to walk...", Debug.INFO, self)
			Core.Client.move_mode = "walk"
	
	if event is InputEventScreenTouch:
		pass
		#action(event.position)
	
	if event.is_action_pressed("burn"):
		Core.emit_signal("msg", "Changing action_mode to burn...", Debug.INFO, self)
		Core.Client.action_mode = "burn"
	
	if event.is_action_pressed("mine"):
		Core.emit_signal("msg", "Changing action_mode to mine...", Debug.INFO, self)
		Core.Client.action_mode = "mine"
	
	if event.is_action_pressed("build"):
		Core.emit_signal("msg", "Changing action_mode to build...", Debug.INFO, self)
		Core.Client.action_mode = "build"
	
	if event.is_action_pressed("paint"):
		Core.emit_signal("msg", "Changing action_mode to paint...", Debug.INFO, self)
		Core.Client.action_mode = "paint"
	
	if event.is_action_pressed("ui_cancel"):
		Core.emit_signal("msg", "Cancel event received", Debug.DEBUG, self)
		if Core.Client.mouse_attached:
			detach_mouse()
		else:
			attach_mouse()
	
	if event.is_action_pressed("open_world_map"):
		DebugPanel.open_world_map()
	if event.is_action_pressed("open_region_map"):
		DebugPanel.open_region_map()
	if event.is_action_pressed("open_chunk_map"):
		DebugPanel.open_chunk_map()
	if event.is_action_pressed("open_system_status"):
		DebugPanel.open_system_status()
	if event.is_action_pressed("open_entity_analysis"):
		DebugPanel.open_entity_analysis()
	if event.is_action_pressed("open_core_analysis"):
		DebugPanel.open_core_analysis()
	if event.is_action_pressed("open_chat"):
		DebugPanel.open_chat()

func detach_mouse(): ###########################################################
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#mouse_attached = false

func attach_mouse(): ###########################################################
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#mouse_attached = true

func _physics_process(delta): ##################################################
#	for node in Manager.get_entities_with("Input"):
#		var components = node.components
#		if components.has("player"):
#			connect("submit", components.text_input.object, components.text_input.method, [id])

	if Core.get_parent().has_node("World/Inputs/JosephTheEngineer"):
		var player_path = "/root/World/Inputs/JosephTheEngineer/"
		var node = get_node(player_path)
		var capsule: CollisionShape = get_node(player_path + "Player/Capsule")
		if Core.Client.move_mode == "walk":
			Player.walk(delta, node)
			#capsule.disabled = false
		else:
			Player.fly(delta, node)
			#capsule.disabled = true

		#if event is InputEventKey and event.pressed:
			#if event.scancode == KEY_ENTER:
				#emit_signal("submit")
			#components.text_input.text += event.as_text()
