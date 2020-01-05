extends Control

############################## public variables ###############################

var analog_is_pressed = false
var frames_passed = 0
var workspace = "game"
var chat_items = Dictionary()




################################### signals ###################################

func _ready(): ################################################################
	load_debug_screen()


func _process(delta): #########################################################
	for node in chat_items.keys():
		var time = chat_items[node]
		if OS.get_unix_time() - time > 5:
			node.queue_free()
			chat_items.erase(node)
	
	if has_node("/root/World/Player"):
		var Player = get_node("/root/World/Player")
		var World = get_node("/root/World")
		var XYZ = find_node("Player XYZ")
		XYZ.set_text("XYZ: " + str(Player.translation))
		#msg(str(round_vector3(Player.translation, 2.0)), "Trace")
		
		var chunk_address = find_node("Chunk Address")
		chunk_address.set_text(" == " + str(World.get_chunk(Player.translation)) + " == ")
		
		var chunk_position = find_node("Chunk XYZ")
		#chunk_position.set_text("XYZ: " + str(World.ChunkAddresses[Vector2(World.get_chunk(Player.translation).x, World.get_chunk(Player.translation).z)]))
		
		var looking_position = find_node("Looking XYZ")
		looking_position.set_text("Looking at: XYZ: " + str(Player.get_looking_at(OS.get_window_size() / 2)))
		
		var looking_chunk = find_node("Looking at Chunk")
		looking_chunk.set_text("Looking at chunk: XYZ: " + str(World.get_chunk(Player.get_looking_at(OS.get_window_size() / 2))))
		
		var orentation = find_node("Orentation")
		orentation.set_text("Orentation: " + Player.get_orientation())
		
		var mode = find_node("Mode")
		mode.set_text("Mode: " + Player.action_mode)
		
		var entities = find_node("Entities")
		entities.set_text("Entities: " + str(World.total_entities) + " | Players: " + str(World.total_players))
		
		var fps = find_node("FPS")
		fps.set_text("FPS: " + str(Engine.get_frames_per_second()))
	
	frames_passed+=1
	if frames_passed > 100:
		load_debug_screen()
		frames_passed = 0

func _on_AnalogTop_button_down():
	analog_is_pressed = true


func _on_AnalogTop_button_up():
	analog_is_pressed = false
	var Player = get_node("/root/World/Player")
	get_node("HorizontalMain/VerticalMain/Navbox/TextureRect/AnalogTop").rect_position = Vector2(50, 0)


func _input(event): ###########################################################
	if event is InputEventScreenDrag:
		if analog_is_pressed:
			msg("Touching the Analog stick", "Debug")
			msg(str(event.position), "Debug")
			var analog_center = Vector2(200, 870)
			var analog_bounds = Vector2(100, 100)
			
			var distance_from_center =  Vector2(abs(abs(analog_center.x) - abs(event.position.x)), abs(abs(analog_center.y) - abs(event.position.y)))
			
			msg("Distance from center: " + str(abs(abs(analog_center.x) - abs(event.position.x))), "Debug")
			if distance_from_center.x < analog_bounds.x:
				if distance_from_center.y < analog_bounds.y:
					msg("In bounds!", "Debug")
					get_node("HorizontalMain/VerticalMain/Navbox/TextureRect/AnalogTop").rect_position = Vector2(event.position.x - 150, event.position.y - 870)
					var Player = get_node("/root/World/Player")
					Player.move(distance_from_center)
	#if event is InputEventScreenTouch:
		#msg("Touched the screen at: " + str(event.position), "Debug")

func _on_BurnButton_toggled(button_pressed): ##################################
	msg("Current workspace: " + workspace, "Info")
	if button_pressed:
		msg("Changing action_mode to burn...", "Info")
		get_node("/root/World/Player").action_mode = "burn"
		switch_mode("burn")
	else:
		msg("Changing action_mode to nothing...", "Info")
		get_node("/root/World/Player").action_mode = "nothing"
		switch_mode("nothing")
	
	switch_workspace("game")


func _on_MineButton_toggled(button_pressed): ##################################
	msg("Current workspace: " + workspace, "Info")
	if button_pressed:
		msg("Changing action_mode to mine...", "Info")
		get_node("/root/World/Player").action_mode = "mine"
		switch_mode("mine")
	else:
		msg("Changing action_mode to nothing...", "Info")
		get_node("/root/World/Player").action_mode = "nothing"
		switch_mode("nothing")
	
	switch_workspace("game")


func _on_BuildButton_toggled(button_pressed): #################################
	msg("Current workspace: " + workspace, "Info")
	if button_pressed:
		msg("Changing action_mode to build...", "Info")
		get_node("/root/World/Player").action_mode = "build"
		switch_mode("build")
		switch_workspace("build")
	else:
		switch_workspace("game")


func _on_PaintButton_toggled(button_pressed): #################################
	msg("Current workspace: " + workspace, "Info")
	if button_pressed:
		msg("Changing action_mode to paint...", "Info")
		get_node("/root/World/Player").action_mode = "paint"
		switch_mode("paint")
		switch_workspace("paint")
	else:
		switch_workspace("game")


func _on_OptionsButton_toggled(button_pressed): ###############################
	msg("Current workspace: " + workspace, "Info")
	msg("Opening pause workspace...", "Info")
	if button_pressed:
		switch_workspace("pause")
	else:
		switch_workspace("game")

func _on_ExitButton_pressed():
	msg("Loading main menu...", "Info")
	get_tree().change_scene("res://scene/main_menu.tscn")


func _on_JumpButton_pressed():
	Input.action_press("jump")




################################## functions ##################################

func switch_workspace(new_workspace):
	msg("Changing mode to " + new_workspace + " from " + workspace, "Debug")
	
	if new_workspace == "pause":
		msg("Opening the pause menu...", "Info")
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		get_node("HorizontalMain/VerticalMain/VerticalCenterContent/PauseWindow").visible = true
		get_node("HorizontalMain/VerticalMain/VerticalCenterContent/Chat").visible = true
		get_node("HorizontalMain/VerticalMain/Navbox").visible = false
	if new_workspace == "build":
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		msg("Opening the build menu...", "Info")
		get_node("HorizontalMain/VerticalMain/VerticalCenterContent/BuildWindow").visible = true
		get_node("HorizontalMain/VerticalMain/VerticalCenterContent/Chat").visible = false
		get_node("HorizontalMain/VerticalMain/Navbox").visible = false
	if new_workspace == "paint":
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		msg("Opening the paint menu...", "Info")
		get_node("HorizontalMain/VerticalMain/VerticalCenterContent/PaintWindow").visible = true
		get_node("HorizontalMain/VerticalMain/VerticalCenterContent/Chat").visible = false
		get_node("HorizontalMain/VerticalMain/Navbox").visible = false
	if new_workspace == "game":
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		msg("Closing all windows...", "Info")
		get_node("HorizontalMain/VerticalMain/VerticalCenterContent/PauseWindow").visible = false
		get_node("HorizontalMain/VerticalMain/VerticalCenterContent/BuildWindow").visible = false
		get_node("HorizontalMain/VerticalMain/VerticalCenterContent/PaintWindow").visible = false
		get_node("HorizontalMain/VerticalMain/VerticalCenterContent/Chat").visible = true
		get_node("HorizontalMain/VerticalMain/Navbox").visible = true
	
	msg("HWIIUUIWUIWEYURYUWEY", "Info")
	workspace = new_workspace

func switch_mode(mode):
	if mode == "burn":
		if get_node("HorizontalMain/Toolbox/BurnButton").pressed:
			get_node("HorizontalMain/Toolbox/BurnButton").pressed = true
			get_node("HorizontalMain/Toolbox/MineButton").pressed = false
			get_node("HorizontalMain/Toolbox/BuildButton").pressed = false
			get_node("HorizontalMain/Toolbox/PaintButton").pressed = false
		else:
			get_node("HorizontalMain/Toolbox/BurnButton").pressed = false
			get_node("HorizontalMain/Toolbox/MineButton").pressed = false
			get_node("HorizontalMain/Toolbox/BuildButton").pressed = false
			get_node("HorizontalMain/Toolbox/PaintButton").pressed = false
		
	elif mode == "mine":
		if get_node("HorizontalMain/Toolbox/MineButton").pressed:
			get_node("HorizontalMain/Toolbox/BurnButton").pressed = false
			get_node("HorizontalMain/Toolbox/MineButton").pressed = true
			get_node("HorizontalMain/Toolbox/BuildButton").pressed = false
			get_node("HorizontalMain/Toolbox/PaintButton").pressed = false
		else:
			get_node("HorizontalMain/Toolbox/MineButton").pressed = false
		
	elif mode == "build":
		if get_node("HorizontalMain/Toolbox/BuildButton").pressed:
			get_node("HorizontalMain/Toolbox/BurnButton").pressed = false
			get_node("HorizontalMain/Toolbox/MineButton").pressed = false
			get_node("HorizontalMain/Toolbox/BuildButton").pressed = true
			get_node("HorizontalMain/Toolbox/PaintButton").pressed = false
		else:
			get_node("HorizontalMain/Toolbox/BuildButton").pressed = false
	
	elif mode == "paint":
		if get_node("HorizontalMain/Toolbox/PaintButton").pressed:
			get_node("HorizontalMain/Toolbox/BurnButton").pressed = false
			get_node("HorizontalMain/Toolbox/MineButton").pressed = false
			get_node("HorizontalMain/Toolbox/BuildButton").pressed = false
			get_node("HorizontalMain/Toolbox/PaintButton").pressed = true
		else:
			get_node("HorizontalMain/Toolbox/PaintButton").pressed = false

func round_vector3(vector, places): ###########################################
	#var x = round(vector.x * pow(10.0, places)) / pow(10.0, places)
	#var y = round(vector.y * pow(10.0, places)) / pow(10.0, places)
	#var z = round(vector.z * pow(10.0, places)) / pow(10.0, places)
	var x = stepify(vector.x, places)
	var y = stepify(vector.y, places)
	var z = stepify(vector.z, places)
	
	return Vector3(x, y, z)


func load_debug_screen(): ####################################################
	if has_node("/root/World"):
		var World = get_node("/root/World")
		
		var version = find_node("Version")
		version.set_text(World.version)
		
		var world_name = find_node("World Name")
		world_name.set_text(" == " + World.map_name + " == ")
		
		var world_path = find_node("World Path")
		world_path.set_text(World.map_path)
		
		var total_chunks = find_node("Total Chunks")
		total_chunks.set_text("Total chunks: " + str(World.total_chunks))
		
		var chunks_cache = find_node("Chunks Cache")
		if World.chunks_cache_size == 0:
			chunks_cache.set_text("Chunks cache: " + "none")
		else:
			chunks_cache.set_text("Chunks cache: " + str(World.chunks_cache_size))
		
		var chunks_loaded = find_node("Chunks Loaded")
		chunks_loaded.set_text("Chunks loaded: " + str(World.loaded_chunks))
		
		var map_seed = find_node("Seed")
		map_seed.set_text("Seed: " + str(World.map_seed))


func fetch_client_version(): ##################################################
	#var file = File.new()
	#if file.open("res://version.txt", File.READ) != 0:
	#	msg("Error reading client version.", "Error")
	
	#return file.get_as_text()
	var World = get_node("/root/World")
	return World.version


func _block_button_pressed(button):
	pass


func show_msg(message, tag): ##################################################	
	if has_node("HorizontalMain/VerticalMain/VerticalCenterContent/Chat"):
		var Chat = get_node("HorizontalMain/VerticalMain/VerticalCenterContent/Chat/Content")
		var ChatItem = load("res://scenes/chat_item.tscn").instance()
		ChatItem.add_text(tag + ": " + str(message) + '\n')
		Chat.add_child(ChatItem)
		Chat.move_child(ChatItem, 0)
		chat_items[ChatItem] = OS.get_unix_time()
		
		var i = 0
		while chat_items.size() > 10:
			chat_items.keys()[i].queue_free()
			chat_items.erase(chat_items.keys()[i])
			i += 1


func msg(message, tag): #######################################################
	print(tag, ": ", message)
	show_msg(message, tag)



