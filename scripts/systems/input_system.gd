# just routes input signals to other systems
extends Node
onready var ClientSystem = get_node("/root/World/Systems/Client")
onready var Events = get_node("/root/Events")
onready var Debug = preload("res://scripts/features/debug.gd").new()
onready var Entity = preload("res://scripts/features/entity.gd").new()
onready var Player = preload("res://scripts/features/player.gd").new()
onready var Manager = preload("res://scripts/features/manager.gd").new()
onready var Comp = preload("res://scripts/features/comp.gd").new()
onready var SystemManager = preload("res://scripts/features/system_manager.gd").new()

var pressed = false
var move_mode = "walk"

func _ready():
	Events.emit_signal("system_ready", SystemManager.INPUT)                ##### READY #####

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
	Debug.msg("Joystick pressed!", "Debug")
	Entity.set_component(id, "joystick.pressed", down)
	
	pressed = true

################################### signals ###################################

#func ready(): ################################################################
	#ClientSystem.total_players += 1
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#camera_width_center = OS.get_window_size().x / 2
	#camera_height_center = OS.get_window_size().y / 2

#func _physics_process(delta): #################################################
#	for id in Manager.get_entities_with(Comp.PLAYER):
#		if Entity.objects.has(id):
#			var components = Entity.objects[id].components
#			if components.has("player"):
#				#connect("submit", components.text_input.object, components.text_input.method, [id])
#				var player_path = Entity.get_node_path({"id":id, "component":"player"})
#				if get_tree().get_root().has_node(player_path + "Capsule"):
#					if move_mode == "walk":
#						Player.walk(delta, id)
#						get_node(player_path + "Capsule").disabled = false
#					else:
#						Player.fly(delta, id)
#						get_node(player_path + "Capsule").disabled = true
				
				#if event is InputEventKey and event.pressed:
					#if event.scancode == KEY_ENTER:
						#emit_signal("submit")
					#components.text_input.text += event.as_text()

signal submit

#func _input(event): ###########################################################
#	for id in Entity.get_entities_with("text_input"):
#		if Entity.objects.has(id):
#			var components = Entity.objects[id].components
#			if components.has("text_input"):
#				if components.text_input.rendered == false:
#					var node = get_node("/root/World/" + str(id))
#					
#					var text_input = Control.new()
#					text_input.name = "TextInput"
#					node.add_child(text_input)
#					
#					components.text_input.rendered = true
#					
#					if components.text_input.has("terminal") == false or components.text_input.terminal == false:
#						connect("submit", components.text_input.object, components.text_input.method, [id])
#					#Entity.edit(id, components)
#				if event is InputEventKey and event.pressed:
#					if event.scancode == KEY_ENTER:
#						emit_signal("submit")
#					components.text_input.text += event.as_text()
#					
#					if components.text_input.has("terminal") and components.text_input.terminal:
#						components.terminal.text += event.as_text()
	#					components.terminal.text_rendered = false
	#				Entity.edit(id, components)
	
	#for id in Entity.get_entities_with("joystick"):
		#if Entity.get_component(id, "joystick.rendered"):
			#var path = Entity.get_node_path(Entity.get_component(id, "joystick.parent") + str(id) + "/Joystick/")
			#get_node(path + bottom)
	
#	var entities = Entity.get_entities_with("player")
#	for id in entities:
#		var components = entities[id].components
#		if components.player.rendered == true:
#			var head = get_node("/root/World/" + str(id) + "/Player/Head")
#			var camera = get_node("/root/World/" + str(id) + "/Player/Head/Camera")
#
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
#				Debug.msg("Action pressed!", "Debug")
#
#				for id in Entity.get_entities_with("joystick"):
#					Debug.msg("Mouse Position: " + str(event.position), "Debug")
#					if event.position.x > 31 and event.position.x < 385 and event.position.y > 505 and event.position.y < 864:
#						Debug.msg("Joystick pressed!", "Debug")
#						pass
#						#_joystick_pressed(true, 0)
#
#				Player.action(id, OS.get_window_size() / 2)
#				if pressed:
#					Debug.msg("Woah", "Info")
#			#player.translation = components.player.position
#			#components.player.rendered = true
##			#Entity.edit(id, components)
#
#	if event.is_action_pressed("fly"):
#		if move_mode == "walk":
#			Debug.msg("Changing move_mode to fly...", "Info")
#			move_mode = "fly"
#		else:
#			Debug.msg("Changing move_mode to walk...", "Info")
#			move_mode = "walk"
#
#	if event.is_action_pressed("break"):
#		#action(OS.get_window_size() / 2)
#		Debug.msg("Break pressed!", "Debug")
#
#	if event is InputEventScreenTouch:
#		pass
#		#action(event.position)
#
#	if event.is_action_pressed("burn"):
#		Debug.msg("Changing action_mode to burn...", "Info")
#		ClientSystem.action_mode = "burn"
#		#Debug.switch_mode("burn")
#
#	if event.is_action_pressed("mine"):
#		Debug.msg("Changing action_mode to mine...", "Info")
#		ClientSystem.action_mode = "mine"
#		#Debug.switch_mode("mine")
#
#	if event.is_action_pressed("build"):
#		Debug.msg("Changing action_mode to build...", "Info")
#		ClientSystem.action_mode = "build"
#		#Debug.switch_mode("build")
#
#	if event.is_action_pressed("paint"):
#		Debug.msg("Changing action_mode to paint...", "Info")
#		ClientSystem.action_mode = "paint"
#		#Debug.switch_mode("paint")

################################## functions ##################################

func _stop_player(player):
	player.stop()
	player.queue_free()