#warning-ignore:unused_class_variable
const meta := {
	script_name = "input.other",
	description = """
		
	"""
}

################################################################################

#static func _process(delta): #########################################################
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

#static func _joystick_pressed(down, id): ##############################################
#	Core.emit_signal("msg", "Joystick pressed!", Core.DEBUG, self)
#	Entity.set_component(id, "joystick.pressed", down)
	
#	pressed = true

################################### signals ####################################

#static func ready(): #################################################################
	#ClientSystem.total_players += 1
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#camera_width_center = OS.get_window_size().x / 2
	#camera_height_center = OS.get_window_size().y / 2

#static func _physics_process(delta): ##################################################
#	for node in Manager.get_entities_with("Input"):
		#var components = node.components
		#if components.has("player"):
			#connect("submit", components.text_input.object, components.text_input.method, [id])
#
#	if Core.get_parent().has_node("World/Inputs/JosephTheEngineer"):
#		var player_path = "/root/World/Inputs/JosephTheEngineer/"
#		var node = get_node(player_path)
#		var capsule: CollisionShape = get_node(player_path + "Player/Capsule")
#		if move_mode == "walk":
#			Player.walk(delta, node)
#			capsule.disabled = false
#		else:
#			Player.fly(delta, node)
#			capsule.disabled = true
		
		#if event is InputEventKey and event.pressed:
			#if event.scancode == KEY_ENTER:
				#emit_signal("submit")
			#components.text_input.text += event.as_text()

#signal submit

#var camera_angle = 0

#static func player_move(event, player): ###############################################
#	var entities = Manager.get_entities_with("player")
#	for id in entities:
#		var components = entities[id]
#		
#		if !components.player.rendered:
#			return false
#		
#		var head = get_node("/root/World/" + str(id) + "/Player/Head")
#		var camera = get_node("/root/World/" + str(id) 
#			+ "/Player/Head/Camera")
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
#				Core.emit_signal("msg", "Action pressed!", Core.DEBUG, self)
#
#				for id in Entity.get_entities_with("joystick"):
#					Core.emit_signal("msg", "Mouse Position: " + str(event.position), Core.DEBUG, self)
#					if event.position.x > 31 and event.position.x < 385 and event.position.y > 505 and event.position.y < 864:
#						Core.emit_signal("msg", "Joystick pressed!", Core.DEBUG, self)
#						pass
#						#_joystick_pressed(true, 0)
#
#				Player.action(id, OS.get_window_size() / 2)
#				if pressed:
#					Core.emit_signal("msg", "Woah", Core.INFO, self)
#			#player.translation = components.player.position
#			#components.player.rendered = true
#			#Entity.edit(id, components)

#static func player_action(event, player): #############################################
#	Core.emit_signal("msg", "Action pressed!", Core.DEBUG, self)
#
#	#for id in Entity.get_entities_with("joystick"):
#	#	Core.emit_signal("msg", "Mouse Position: " + str(event.position), Core.DEBUG, self)
#	#	if event.position.x > 31 and event.position.x < 385 and event.position.y > 505 and event.position.y < 864:
#	#		Core.emit_signal("msg", "Joystick pressed!", Core.DEBUG, self)
#	#		pass
#			#_joystick_pressed(true, 0)
#
#	Player.action(player, OS.get_window_size() / 2)
#
################################### static functions ###################################
#
#static func _stop_player(player): #####################################################
#	player.stop()
#	player.queue_free()

#static func world_button(world):
#	pass
	#if world == 1:
		#Core.emit_signal("msg", "Opening world creation menu...", Core.INFO, self)
		#create_new_world()
		#Core.emit_signal("msg", "Loading a new flat terrain world...", Core.INFO, self)
		#map_path = ""
		#map_name = "New Flat Terrain World"
		#map_seed = 0
		#load_world()
	#elif world == 3:
		#pass
	#else:
		#Core.emit_signal("msg", "Loading a new natural terrain world...", Core.INFO, self)
		#map_path = ""
		#map_name = "New Natural Terrain World"
		#map_seed = floor(rand_range(0, 9999999))
		#load_world()
