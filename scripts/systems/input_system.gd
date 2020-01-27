# just routes input signals to other systems
extends Node
onready var Player = preload("res://scripts/features/player.gd").new()
onready var Manager = preload("res://scripts/features/manager.gd").new()
onready var Comp = preload("res://scripts/features/comp.gd").new()
onready var SystemManager = preload("res://scripts/features/system_manager.gd").new()

var pressed = false
var move_mode = "walk"

enum direction {
	UP
	DOWN
	LEFT
	RIGHT
}

func _ready():
	Core.emit_signal("system_ready", SystemManager.INPUT, self)                ##### READY #####

#func _process(delta):
#	var entities = Entity.get_entities_with("hud")
#	for id in entities:
#		if get_node("/root/World/" + str(id)):
#			var components = entities[id].components
#			if !Entity.get_component(id, "hud.horizontal_main.vertical_main.nav_controls.joystick.input_system") and Entity.get_component(id, "hud.horizontal_main.vertical_main.nav_controls.joystick.interface_system"):
#				var bottom = get_node("/root/World/" + str(id) + "/Hud/HorizontalMain/VerticalMain/NavControls/Joystick/Bottom")
#				var top = get_node("/root/World/" + str(id) + "/Hud/HorizontalMain/VerticalMain/NavControls/Joystick/Top")
#
#				bottom.connect("button_down", self, "_joystick_pressed", [true])
#				bottom.connect("button_up", self, "_joystick_pressed", [false])
#
#				components.hud.horizontal_main.vertical_main.nav_controls.joystick.input_system = true
#				Entity.edit(id, components)
#	
#	
#	if Input.is_action_pressed("ui_cancel"):
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#		#InterfaceSystem.pause_menu()
#		#get_tree().quit()
#	if Input.is_action_just_pressed("restart"):
#		get_tree().reload_current_scene()

func _joystick_pressed(down, id):
	Core.emit_signal("msg", "Joystick pressed!", "Debug")
#	Entity.set_component(id, "joystick.pressed", down)
	
	pressed = true

################################### signals ###################################

#func ready(): ################################################################
	#ClientSystem.total_players += 1
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#camera_width_center = OS.get_window_size().x / 2
	#camera_height_center = OS.get_window_size().y / 2

func _physics_process(delta): #################################################
#	for node in Manager.get_entities_with("Input"):
		#var components = node.components
		#if components.has("player"):
			#connect("submit", components.text_input.object, components.text_input.method, [id])
	var node = get_node("/root/World/Inputs/JosephTheEngineer")
	
	if node:
		var player_path = "/root/World/Inputs/JosephTheEngineer/Player/"
		if move_mode == "walk":
			Player.walk(delta, node)
			get_node(player_path + "Capsule").disabled = false
		else:
			Player.fly(delta, node)
			get_node(player_path + "Capsule").disabled = true
		
		#if event is InputEventKey and event.pressed:
			#if event.scancode == KEY_ENTER:
				#emit_signal("submit")
			#components.text_input.text += event.as_text()

signal submit

func _input(event): ###########################################################
#	var entities = Manager.get_entities_with("Inputs")
#	if entities:
#		for id in entities:
#			var player = entities[id]
#			if player.rendered == true:
	var player = get_node("/root/World/Inputs/JosephTheEngineer")
	
	if player:
		if event is InputEventMouseMotion:
			player_move_head(event, player)
		
		elif event.is_action_pressed("action"):
			player_action(event, player)
	
	if event.is_action_pressed("fly"):
		if move_mode == "walk":
			Core.emit_signal("msg", "Changing move_mode to fly...", "Info")
			move_mode = "fly"
		else:
			Core.emit_signal("msg", "Changing move_mode to walk...", "Info")
			move_mode = "walk"
	
	if event.is_action_pressed("break"):
		#action(OS.get_window_size() / 2)
		Core.emit_signal("msg", "Break pressed!", "Debug")
	
	if event is InputEventScreenTouch:
		pass
		#action(event.position)
	
	if event.is_action_pressed("burn"):
		Core.emit_signal("msg", "Changing action_mode to burn...", "Info")
		Core.Client.action_mode = "burn"
		#Debug.switch_mode("burn")
	
	if event.is_action_pressed("mine"):
		Core.emit_signal("msg", "Changing action_mode to mine...", "Info")
		Core.Client.action_mode = "mine"
		#Debug.switch_mode("mine")
	
	if event.is_action_pressed("build"):
		Core.emit_signal("msg", "Changing action_mode to build...", "Info")
		Core.Client.action_mode = "build"
		#Debug.switch_mode("build")
	
	if event.is_action_pressed("paint"):
		Core.emit_signal("msg", "Changing action_mode to paint...", "Info")
		Core.Client.action_mode = "paint"
		#Debug.switch_mode("paint")

var camera_angle = 0

func player_move_head(event, player):
	var head = player.get_node("Player/Head")
	
	head.rotation_degrees.y += -event.relative.x * Player.mouse_sensitivity
	
	var change = -event.relative.y * Player.mouse_sensitivity
	#if change + camera_angle < 90 and change + camera_angle > -90:
	head.rotation_degrees.x += change
	camera_angle += change
	#Core.emit_signal("msg", "Camera Angle: " + str(camera_angle), "Trace")
	#Core.emit_signal("msg", "Angle: " + str(head.rotation_degrees), "Trace")
	
	# Fix z value #BUG#
	#head.rotation_degrees.z = 0
	
	#var camera_rot = head.rotation_degrees
	#camera_rot.x = clamp(camera_rot.x, -70, 70)
	#head.rotation_degrees = camera_rot

func player_move(event, player):
	var entities = Manager.get_entities_with("player")
	for id in entities:
		var components = entities[id]
		if components.player.rendered == true:
			var head = get_node("/root/World/" + str(id) + "/Player/Head")
			var camera = get_node("/root/World/" + str(id) + "/Player/Head/Camera")
			
#			if event is InputEventMouseMotion:
#				#if Hud.analog_is_pressed == false:
#				head.rotate_y(deg2rad(-event.relative.x * Player.mouse_sensitivity))
#
#				var change = -event.relative.y * Player.mouse_sensitivity
#				if change + Player.camera_angle < 90 and change + Player.camera_angle > -90:
#					camera.rotate_x(deg2rad(change))
#					Player.camera_angle += change
#
#			elif event.is_action_pressed("action"):
#				Core.emit_signal("msg", "Action pressed!", "Debug")
#
#				for id in Entity.get_entities_with("joystick"):
#					Core.emit_signal("msg", "Mouse Position: " + str(event.position), "Debug")
#					if event.position.x > 31 and event.position.x < 385 and event.position.y > 505 and event.position.y < 864:
#						Core.emit_signal("msg", "Joystick pressed!", "Debug")
#						pass
#						#_joystick_pressed(true, 0)
#
#				Player.action(id, OS.get_window_size() / 2)
#				if pressed:
#					Core.emit_signal("msg", "Woah", "Info")
#			#player.translation = components.player.position
#			#components.player.rendered = true
#			#Entity.edit(id, components)

func player_action(event, player):
	Core.emit_signal("msg", "Action pressed!", "Debug")
	
#	for id in Entity.get_entities_with("joystick"):
#		Core.emit_signal("msg", "Mouse Position: " + str(event.position), "Debug")
#		if event.position.x > 31 and event.position.x < 385 and event.position.y > 505 and event.position.y < 864:
#			Core.emit_signal("msg", "Joystick pressed!", "Debug")
#			pass
#			#_joystick_pressed(true, 0)
#
#	Player.action(id, OS.get_window_size() / 2)
#	if pressed:
#		Core.emit_signal("msg", "Woah", "Info")
#player.translation = components.player.position
#components.player.rendered = true
#Entity.edit(id, components)

################################## functions ##################################

func _stop_player(player):
	player.stop()
	player.queue_free()