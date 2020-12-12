extends Node
#warning-ignore:unused_class_variable
const meta := {
	script_name = "interface.system",
	description = """
		
	"""
}
#warning-ignore:unused_class_variable
const DEFAULT_DATA := {
	
}
#warning-ignore:unused_class_variable
var data := DEFAULT_DATA.duplicate(true)

func _ready(): #################################################################
	Core.connect("reset", self, "_reset")
	Core.emit_signal("system_ready", Core.scripts.core.system_manager.INTERFACE, self)         ##### READY #####
	var error: int = Core.connect("msg", self, "_on_msg")
	if error:
		emit_signal("msg", "Error on binding to msg: " 
			+ str(error), Core.WARN, meta)


func _process(_delta): #########################################################
	for entity in get_children():
		if entity.components.meta.type == 'hud':
			Core.scripts.interface.hud.process_hud(entity)


func _reset():
	Core.emit_signal("msg", "Reseting interface system database...", Core.DEBUG, meta)
	data = DEFAULT_DATA.duplicate(true)


func create(entity: Dictionary):
	if entity.meta.system != "interface":
		Core.emit_signal("msg", "Interface entity create called with incorrect system set", Core.WARN, meta)
		return false
	
	if entity.meta.type == "tty":
		var node = Entity.new()
		node.set_name("0")
		add_child(node)
		var tty: Entity = get_node("0")
		tty.components = entity
		tty.add_child(Core.scenes.interface.terminal.tty.instance())
	
	if entity.meta.type == "hud":
		var node = Entity.new()
		node.set_name(entity.meta.id)
		add_child(node)
		var hud: Entity = get_node(str(entity.meta.id))
		hud.components = entity
		hud.add_child(Core.scenes.interface.hud.hud.instance())


func _on_msg(message, level, script_meta): #####################################
	var level_string = "All"
	match level:
		Core.FATAL:
			level_string = "[color=red]Fatal"
		Core.ERROR:
			level_string = "[color=red]Error"
		Core.WARN:
			level_string = " [color=yellow]Warn"
		Core.INFO:
			level_string = " [color=white]Info"
		Core.DEBUG:
			level_string = "[color=teal]Debug"
		Core.TRACE:
			level_string = "[color=grey]Trace"
		Core.ALL:
			level_string = "  [color=blue]All"
	
	var func_path = ""
	if script_meta.has("func_name"):
		func_path = script_meta.func_name
	elif script_meta.has("script_name"):
		func_path = script_meta.script_name + ".n/a"
	else:
		func_path = "n/a"
	
	#Core.emit_signal("msg", "Rec message", Core.DEBUG, meta)
	var label_path := "Interface/0/TTY/RichTextLabel"
	if Core.world.has_node(label_path):
		var label: RichTextLabel = Core.world.get_node(label_path)
		if label.text == "":
			var file = File.new()
			file.open(Core.client.data.log_path + "latest.txt", File.READ)
			label.add_text(file.get_as_text())
			file.close()
		label.append_bbcode(level_string + " [ " + func_path + " ] " + message + "\n")
	
	var hud_path := "Interface/Hud/Hud/"
	var chat_path := hud_path + "HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer/Chat/Content/TabContainer/"
	var display_path := chat_path + "msg/RichTextLabel"
	if Core.world.has_node(display_path) and level < Core.TRACE:
		var label: RichTextLabel = Core.world.get_node(display_path)
		if label.text == "loading...":
			label.text = ""
			var file = File.new()
			file.open(Core.client.data.log_path + "latest.txt", File.READ)
			var file_text = file.get_as_text().split("\n")
			for i in range(file_text.size()-2):
				var split = file_text[i]
				split = split.split(" ", false)
				if split.size() > 0:
					if split[3] == "Info" || split[3] == "Warn" || split[3] == "Error" || split[3] == "Fatal":
						var sub_level_string = Core.scripts.core.debug.msg.level_string(Core.ALL)
						var sub_script_name = split[5]
						var sub_message = ""
						for index in range(7, split.size()):
							sub_message += split[index] + " "
						label.add_text(sub_level_string + " [ " + sub_script_name + " ] " + sub_message + "\n")
			file.close()
		#if level <= Core.INFO:
		
		label.append_bbcode(level_string + " [ " + func_path + " ] " + message + "[/color]\n")


func update_world_map(): #######################################################
	Core.emit_signal("msg", "Updating world map", Core.INFO, meta)
	var grid := Dictionary()
	
	for region in Core.Server.data.map.regions:
		grid[region] = Core.scripts.interface.tile_map.KNOWN
	
	Core.emit_signal("msg", "World map data: " + str(grid), Core.TRACE, meta)
	
	var hud_path := "World/Interfaces/Hud/Hud/"
	var world_map_path := hud_path + "HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer/WorldMap/"
	if Core.get_parent().has_node(world_map_path + "VBoxContainer/TileMap"):
		var tile_map = Core.get_parent().get_node(world_map_path + "VBoxContainer/TileMap")
		tile_map.display_grid(grid, Vector2(0, 1))


func update_region_map(): ######################################################
	Core.emit_signal("msg", "Updating region map", Core.INFO, meta)
	var grid = Dictionary()
	
	#var region_chunks = Core.Server.regions[Core.Server.regions.keys()[0]] # Grid = array of Vector3's
	
	#for chunk in region_chunks:
	#	grid[chunk] = RegionTileMap.KNOWN
	
	var hud_path := "World/Interfaces/Hud/Hud/"
	var region_map_path := hud_path + "HorizontalMain/VerticalMain/VerticalCenterContent/LeftPanel/TabContainer/RegionMap/"
	if Core.get_parent().has_node(region_map_path + "VBoxContainer/TileMap"):
		var tile_map = Core.get_parent().get_node(region_map_path + "VBoxContainer/TileMap")
		tile_map.display_grid(grid, Vector2(0, 1))


#func process_horizontal_container(id: int): ####################################
#	pass


#func create_toolbox(id: int): ##################################################
#	var toolbox := preload("res://src/scenes/hud/toolbox.tscn").instance()
#
#	Entity.add_node(id, "toolbox", toolbox)


#func process_toolbox(id: int):
#	pass


#func create_terminal(entity: Entity): #################################################
#	var terminal_resource := preload("res://src/scenes/terminal/terminal.tscn")
#	var terminal = terminal_resource.instance()
#	entity.add_node(terminal)
#
#	if !get_tree().get_root().has_node(path + str(id)):
#		return false
#
#	if Entity.get_component(id, "terminal.min_size"):
#		terminal.rect_min_size = Entity.get_component(id, 
#			"terminal.min_size")
#
#	var terminal_node: Control = get_node(path + str(id) + "/Terminal")
#	if Entity.get_component(id, "terminal.position"):
#		terminal_node.rect_position = Entity.get_component(id, 
#			"terminal.position")
#
#	if Entity.get_component(id, "terminal.text"):
#		var text: RichTextLabel = terminal_node.get_node("Text")
#		text.text = Entity.get_component(id, 
#			"terminal.text")


#################################### Main Menu stuff ###########################

#onready var Leaderboard = get_node("/root/Main Menu/UI/Leaderboard")
#onready var WorldSharing = get_node("/root/Main Menu/UI/WorldSharing")
#onready var Credits = get_node("/root/Main Menu/UI/Credits")
#onready var AccountPage = get_node("/root/Main Menu/UI/AccountPage")

#onready var TitleScreenPlayer = get_node("TitleScreen/AnimationPlayer")




############################## public variables ################################

const info = [ "changelog.md", "featured-worlds.md", "game-stats.md", 
	"info.md", "news.md", "new-worlds.md", "top-users.md", "top-worlds.md" ]

var workspace = "home"
var positions = Dictionary()
var ui_snaped = true
var snaped_position = Vector2(0, 0)
var ui_just_moved = false
#var ui_snaping = false
var distance_to_move = Vector2(0, 0)
var distance_moved = Vector2(0, 0)

#var fetch_data_request = HTTPRequest.new()
#var file_progress = 0

var loader
var wait_frames
var time_max = 100 # msec
var current_scene
var process_ui = false
#var main_menu = true
var background_pressed = false
var search_is_focused = false

const TITLE_SCREEN = 0
const HOME = 1
const LEADERBOARD = 2
const WORLD_SHARING = 3
const CREDITS = 4
const ACCOUNT = 5
const PAUSE = 10
const BUILD = 11
const PAINT = 12
const CHAT = 13
const NAVBAR = 14
const TOOLBOX = 15

#var current_interface = [ TITLE_SCREEN ]


func change_interface(interfaces): #############################################
	for interface in interfaces:
		pass
		#load_scene interface/main_menui


func process_interface(): ######################################################
	var title_screen: Control = get_node("/root/MainMenu/TitleScreen")
	var ui: Control = get_node("/root/MainMenu/UI")
	if title_screen.visible == false:
		title_screen.visible = true
		ui.visible = false
	
	
	#TitleScreenPlayer.play("TitleScreen")
	
	# get current scene for the scene loader
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	
	# initialize the background scene
	#World = world_template.instance()
	#World.map_seed = -1
	#add_child(World)
	#draw_dots()
	Core.emit_signal("msg", "Starting logs...", Core.INFO, meta)
	
	# fetch data from the website for the main menu
	#fetch_data()
	
	var world_data = Dictionary()
	world_data[1] = "New World"
	world_data[2] = "Test World"
	world_data[3] = "Direct City"
	
	#var parent = get_node("UI/Home/VBoxContainer/TopContainer/Planets/Foreground")
	show_world_list(world_data, true)


func process(): ###########################################################
	#update_positions()
	if Input.is_action_just_pressed("action"):
		background_pressed = true
	if Input.is_action_just_released("action"):
		background_pressed = false
		if ui_just_moved:
			ui_snaped = false
	
	if ui_snaped == false:
		var closest_position = Vector2(0, 0)
		
		var ui: Control = get_node("UI")
		for position in positions.values():
			if abs(position.x - ui.rect_position.x) <= abs(closest_position.x - ui.rect_position.x):
				if abs(position.y - ui.rect_position.y) <= abs(closest_position.y - ui.rect_position.y):
					closest_position = position
		snaped_position = closest_position
		ui_snaped = true
	
	if distance_moved < distance_to_move:
		var distance_to_move_sub = Vector2(0, 0)
		distance_to_move_sub.x = round(distance_to_move.x / 4)
		distance_to_move_sub.y = round(distance_to_move.y / 4)
		if distance_to_move_sub < Vector2(1, 1):
			distance_to_move_sub = Vector2(1, 1)
	
	if !process_ui:
		return false
	
	if loader == null:
		Core.emit_signal("msg", "Loader was null!", Core.DEBUG, meta)
		# no need to process anymore
		process_ui = false
		return
	
	if wait_frames > 0: # wait for frames to let the "loading" animation show up
		wait_frames -= 1
		return
	
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control how much time we block this thread
		# poll your loader
		var err = loader.poll()
		
		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			Core.emit_signal("msg", "Removing old scene...", Core.DEBUG, meta)
			var container: VBoxContainer = get_node("UI/LoadingContainer")
			container.visible = false
			current_scene.queue_free() # get rid of the old scene
			Core.emit_signal("msg", "Setting new scene...", Core.DEBUG, meta)
			set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else: # error during loading
			Core.emit_signal("msg", "Error during loading", Core.ERROR, meta)
			loader = null
		break


#func _on_AnimationPlayer_animation_finished(anim_name): ########################
	#if anim_name == "TitleScreen":
		#get_node("TitleScreen/AnimationPlayer").play("TitleScreenFlashingText")
	#if anim_name == "TitleScreenFlashingText":
		#get_node("TitleScreen/AnimationPlayer").play("TitleScreenFlashingText")


#func _on_CreateServerButton_pressed(): #########################################
#	World.create_server("server")


func _on_JoinServerButton_pressed(): ###########################################
	pass
	#var address = get_node("UI/Home/VBoxContainer/TopContainer/Chat/VBoxContainer/Row1/Column1/Input").text
	#World.join_server("player", address)


#func _on_SendButton_pressed(): #################################################
	#Core.emit_signal("msg", "Sending message...", Core.INFO, meta)
	#World.send_message("Hello!")


func _on_SharedWorlds_released(): ##############################################
	Core.emit_signal("msg", "Shared worlds are not implemented yet!", 
		Core.WARN, meta)
	


func _on_OptionsButton_pressed(): ##############################################
	var home: MarginContainer = get_node("/root/Main Menu/UI/Home")
	home.visible = false
	var options: MarginContainer = get_node("/root/Main Menu/UI/Options")
	options.visible = true
	workspace = "options"


func _on_OptionsBackButton_pressed(): ##########################################
	var options: MarginContainer = get_node("/root/Main Menu/UI/Options")
	options.visible = false
	
	var home: MarginContainer = get_node("/root/Main Menu/UI/Home")
	home.visible = true
	workspace = "home"


func input(event): #############################################################
	if event is InputEventScreenDrag:
		#get_node("UI").rect_position += event.relative
		#music_player.translation += Vector3(event.relative.x, event.relative.y, 0) / 100
		ui_just_moved = true
	if event is InputEventMouseMotion:
		if background_pressed:
			#get_node("UI").rect_position += event.relative
			#music_player.translation += Vector3(event.relative.x, event.relative.y, 0) / 100
			ui_just_moved = true
	if event is InputEventScreenTouch:
		var title_screen: Control = get_node("TitleScreen")
		if title_screen.visible:
			
			var music_player = AudioStreamPlayer3D.new()
			var audio = load("res://sounds/engineer/271945__rodincoil__stingers-001.ogg")
			audio.loop = false
			music_player.stream = audio
			music_player.unit_db = 1
			music_player.connect("finished", self, "_stop_player", 
				[music_player])
			add_child(music_player)
			music_player.play()
			
			var titlescreen: Control = get_node("TitleScreen")
			titlescreen.visible = false
			
			var ui: Control = get_node("UI")
			ui.visible = true
			
	if event.is_action_pressed("action"):
		pass
		#if get_node("TitleScreen").visible:
			
			#var music_player = AudioStreamPlayer3D.new()
			#var audio = load("res://sounds/engineer/271945__rodincoil__stingers-001.ogg")
			#audio.loop = false
			#music_player.stream = audio
			#music_player.unit_db = 1
			#music_player.connect("finished", self, "_stop_player", [music_player])
			#add_child(music_player)
			#music_player.play()
			
			#get_node("TitleScreen").visible = false
			#get_node("UI").visible = true
	if event.is_action_pressed("ui_accept"):
		if search_is_focused:
			pass


################################## functions ###################################

func update_positions():
	var ui: Control = get_node("UI")
	var screen_size = ui.rect_size
	positions["home"] = Vector2(0, 0)
	positions["leaderboard"] = Vector2(0, screen_size.y)
	positions["world_sharing"] = Vector2(-screen_size.x, 0)
	positions["credits"] = Vector2(0, -screen_size.y)
	positions["account_page"] = Vector2(+screen_size.x, 0)


func show_world_list(world_data, is_downloaded):
	for path in world_data.keys():
		var content = HBoxContainer.new()
		content.rect_min_size = Vector2(0, 125)
		
		var button = TextureButton.new()
		button.texture_normal = load("res://textures/tnt_side.png")
		button.texture_hover = load("res://textures/fireworks_side.png")
		button.texture_pressed = load("res://textures/steel.png")
		button.rect_min_size = Vector2(120, 0)
		button.expand = true
		button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		content.add_child(button)
		if is_downloaded:
			button.connect("pressed", self, "world_button", [path])
		else:
			button.connect("pressed", self, 
				"download_world_button", [path])
		
		var seperator = VSeparator.new()
		seperator.rect_min_size = Vector2(20, 0)
		content.add_child(seperator)
		
		var label = Label.new()
		label.size_flags_horizontal = Control.SIZE_FILL
		label.text = world_data[path]
		label.set("custom_fonts/font", load("res://fonts/header.tres"))
		content.add_child(label)


func create_new_world():
	Core.emit_signal("msg", "World creation menu", Core.DEBUG, meta)
	var world: PackedScene = load("res://scenes/new_world_panel.tscn")
	add_child(world.instance())


func draw_dots(): ##############################################################
	for x in range(OS.get_window_size().x / 10):
		for y in range(OS.get_window_size().y / 10):
			var dot = Core.scenes.interface.main_menu.dot.instance()
			get_node("/root/Main Menu/UI/Background").add_child(dot)
			dot.rect_position = Vector2(x*40, y*40)


func update_progress(): ########################################################
	Core.emit_signal("msg", "Updating progress...", Core.DEBUG, meta)
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	var animation_player: AnimationPlayer = get_node("AnimationPlayer")
	# Update your progress bar?
	#get_node("progress").set_progress(progress)
	
	# ... or update a progress animation?
	var length := animation_player.get_current_animation_length()
	
	# Call this on a paused animation. Use "true" as the second argument 
	# to force the animation to update.
	animation_player.seek(progress * length, true)


func set_new_scene(scene_resource): ############################################
	current_scene = scene_resource.instance()
	#current_scene.map_seed = map_seed
	#current_scene.map_path = map_path
	#current_scene.map_name = map_name
	get_node("/root").add_child(current_scene)


func load_world(): #############################################################
	Core.emit_signal("msg", "Changing scene to world.tscn...", Core.INFO, 
		self)
	var path = "res://scenes/world.tscn"
	
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		Core.emit_signal("msg", "Loader was null!", Core.ERROR, meta)
		return
	process_ui = true
	
	var loading_container: VBoxContainer = get_node("UI/LoadingContainer")
	loading_container.visible = true
	
	# start your "loading..." animation
	Core.emit_signal("msg", "Starting animation...", Core.DEBUG, meta)
	var animation_player: AnimationPlayer = get_node("AnimationPlayer")
	animation_player.play("Loading")
	
	wait_frames = 10


func _on_SwipeDetector_swiped(direction): ######################################
	Core.emit_signal("msg", "Swipe signal received! Direction: " + str(direction), Core.INFO, meta)


func _on_search_focus_entered(): ###############################################
	search_is_focused = true


func _on_search_focus_exited(): ################################################
	search_is_focused = false
