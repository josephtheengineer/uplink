extends Spatial

#################################### nodes ####################################

onready var World

onready var Home = get_node("/root/Main Menu/UI/Home")
onready var Leaderboard = get_node("/root/Main Menu/UI/Leaderboard")
onready var WorldSharing = get_node("/root/Main Menu/UI/WorldSharing")
onready var Credits = get_node("/root/Main Menu/UI/Credits")
onready var AccountPage = get_node("/root/Main Menu/UI/AccountPage")
onready var Options = get_node("/root/Main Menu/UI/Options")

onready var TitleScreenPlayer = get_node("TitleScreen/AnimationPlayer")




############################## public variables ###############################

onready var world_template = preload("res://scenes/world.tscn")
onready var dot_template = preload("res://scenes/dot.tscn")

const info = [ "changelog.md", "featured-worlds.md", "game-stats.md", "info.md", "news.md", "new-worlds.md", "top-users.md", "top-worlds.md" ]

var workspace = "home"
var positions = Dictionary()
var ui_snaped = true
var snaped_position = Vector2(0, 0)
var ui_just_moved = false
var ui_snaping = false
var distance_to_move = Vector2(0, 0)
var distance_moved = Vector2(0, 0)

var fetch_data_request = HTTPRequest.new()
var file_progress = 0

var loader
var wait_frames
var time_max = 100 # msec
var current_scene
var process = false
var main_menu = true
var background_pressed = false
var search_is_focused = false

var downloading = false
var downloading_wait = 0
var download_world_client
var downloaded_world_path
var last_downloaded_bytes
var search_client
var past_frames = 0

var downloading_direct_city = false
var direct_city_downloader

var music_player = AudioStreamPlayer3D.new()
var playlist_progress = 0
var playlist = "Eden"

var map_seed = 0
var map_path = "res://worlds/direct_city.eden2"
var map_name = "direct_city.eden2"

const EDEN2_SEARCH = "http://app.edengame.net/list2.php?search="
const EDEN2_DOWNLOAD = "http://files.edengame.net/"



################################### signals ###################################

func _ready(): ################################################################
	
	if get_node("TitleScreen").visible == false:
		get_node("TitleScreen").visible = true
		get_node("UI").visible = false
	
	music_player.translation = Vector3(8, 8, 0)
	_music_player_finished()
	
	
	TitleScreenPlayer.play("TitleScreen")
	
	# get current scene for the scene loader
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	
	# initialize the background scene
	World = world_template.instance()
	World.map_seed = -1
	add_child(World)
	draw_dots()
	msg("Starting logs...", Debug.INFO, self)
	
	# fetch data from the website for the main menu
	fetch_data()
	
	var world_data = Dictionary()
	world_data[1] = "New World"
	world_data[2] = "Test World"
	world_data[3] = "Direct City"
	
	var parent = get_node("UI/Home/VBoxContainer/TopContainer/Planets/Foreground")
	show_world_list(parent, world_data, true)


func _process(delta): #########################################################
	update_positions()
	if Input.is_action_just_pressed("action"):
		background_pressed = true
	if Input.is_action_just_released("action"):
		background_pressed = false
		if ui_just_moved:
			ui_snaped = false
	
	
	if downloading_direct_city and OS.get_unix_time() - downloading_wait > 5:
		msg("KB downloaded: " + str(direct_city_downloader.get_downloaded_bytes() * 0.001), Debug.INFO, self)
		downloading_wait = OS.get_unix_time()
	
	if ui_snaped == false:
		var closest_position = Vector2(0, 0)
		for position in positions.values():
			if abs(position.x - get_node("UI").rect_position.x) <= abs(closest_position.x - get_node("UI").rect_position.x):
				if abs(position.y - get_node("UI").rect_position.y) <= abs(closest_position.y - get_node("UI").rect_position.y):
					closest_position = position
		snaped_position = closest_position
		ui_snaped = true
	
	if get_node("UI").rect_position != snaped_position and ui_snaped and background_pressed == false:
		distance_to_move.x = abs(get_node("UI").rect_position.x - snaped_position.x)
		distance_to_move.y = abs(get_node("UI").rect_position.y - snaped_position.y)
		#msg("Position is now " + str(get_node("UI").rect_position), Debug.DEBUG, self)
		distance_moved = Vector2(0, 0)
	
	if distance_moved < distance_to_move:
		var distance_to_move_sub = Vector2(0, 0)
		distance_to_move_sub.x = round(distance_to_move.x / 4)
		distance_to_move_sub.y = round(distance_to_move.y / 4)
		if distance_to_move_sub < Vector2(1, 1):
			distance_to_move_sub = Vector2(1, 1)
		
		#msg("Music player position is " + str(music_player.translation), Debug.DEBUG, self)
		
		if get_node("UI").rect_position.x < snaped_position.x:
			get_node("UI").rect_position.x += distance_to_move_sub.x
			music_player.translation.x += distance_to_move_sub.x / 100
			distance_moved.x += distance_to_move_sub.x
		else:
			get_node("UI").rect_position.x -= distance_to_move_sub.x
			music_player.translation.x -= distance_to_move_sub.x / 100
			distance_moved.x -= distance_to_move_sub.x
		
		if get_node("UI").rect_position.y < snaped_position.y:
			get_node("UI").rect_position.y += distance_to_move_sub.y
			music_player.translation.y += distance_to_move_sub.y / 100
			distance_moved.y += distance_to_move_sub.y
		else:
			get_node("UI").rect_position.y -= distance_to_move_sub.y
			music_player.translation.y -= distance_to_move_sub.y / 100
			distance_moved.y -= distance_to_move_sub.y
	
	if downloading:
		if OS.get_unix_time() - downloading_wait > 5:
			msg("KB downloaded: " + str(download_world_client.get_downloaded_bytes() * 0.001), Debug.INFO, self)
			downloading_wait = OS.get_unix_time()
			
			if last_downloaded_bytes == download_world_client.get_downloaded_bytes() and last_downloaded_bytes != 0:
				_on_world_download_completed(downloaded_world_path)
			
			last_downloaded_bytes = download_world_client.get_downloaded_bytes()
	
	if process:
		if loader == null:
			msg("Loader was null!", Debug.DEBUG, self)
			# no need to process anymore
			process = false
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
				msg("Removing old scene...", Debug.DEBUG, self)
				get_node("UI/LoadingContainer").visible = false
				current_scene.queue_free() # get rid of the old scene
				msg("Setting new scene...", Debug.DEBUG, self)
				set_new_scene(resource)
				break
			elif err == OK:
				update_progress()
			else: # error during loading
				msg("Error during loading", Debug.ERROR, self)
				loader = null
			break


func _music_player_finished():
	if playlist == "Eden":
		if playlist_progress > 7:
			playlist_progress = 0
		
		var audio = load("res://sounds/music/eden" + str(playlist_progress) + ".ogg")
		audio.loop = false
		music_player.stream = audio
		
		if playlist_progress != 7:
			get_node("UI/Home/VBoxContainer/BottomContainer/VBoxContainer/Button/Song").text = "Eden " + str(playlist_progress) + " by Adam Gubman"
		else:
				get_node("UI/Home/VBoxContainer/BottomContainer/VBoxContainer/Button/Song").text = "Eden " + str(playlist_progress) + " by Vodlos"
		
	elif playlist == "Engineer":
		pass
	
	add_child(music_player)
	music_player.play()
	playlist_progress += 1


func _skip_song():
	_music_player_finished()


func _on_AnimationPlayer_animation_finished(anim_name): #######################
	if anim_name == "TitleScreen":
		get_node("TitleScreen/AnimationPlayer").play("TitleScreenFlashingText")
	if anim_name == "TitleScreenFlashingText":
		get_node("TitleScreen/AnimationPlayer").play("TitleScreenFlashingText")


func _on_CreateServerButton_pressed(): ########################################
	World.create_server("server")


func _on_JoinServerButton_pressed(): ##########################################
	var address = get_node("UI/Home/VBoxContainer/TopContainer/Chat/VBoxContainer/Row1/Column1/Input").text
	World.join_server("player", address)


func _on_SendButton_pressed(): ################################################
	msg("Sending message...", Debug.INFO, self)
	World.send_message("Hello!")


func _on_SharedWorlds_released(): #############################################
	msg("Shared worlds are not implemented yet!", Debug.WARN, self)
	


func _on_OptionsButton_pressed(): #############################################
	Home.visible = false
	Options.visible = true
	workspace = "options"


func _on_OptionsBackButton_pressed(): #########################################
	Options.visible = false
	Home.visible = true
	workspace = "home"


func _input(event): ###########################################################
	if event is InputEventScreenDrag:
		get_node("UI").rect_position += event.relative
		music_player.translation += Vector3(event.relative.x, event.relative.y, 0) / 100
		ui_just_moved = true
	if event is InputEventMouseMotion:
		if background_pressed:
			get_node("UI").rect_position += event.relative
			music_player.translation += Vector3(event.relative.x, event.relative.y, 0) / 100
			ui_just_moved = true
	if event is InputEventScreenTouch:
		if get_node("TitleScreen").visible:
			
			var music_player = AudioStreamPlayer3D.new()
			var audio = load("res://sounds/engineer/271945__rodincoil__stingers-001.ogg")
			audio.loop = false
			music_player.stream = audio
			music_player.unit_db = 1
			music_player.connect("finished", self, "_stop_player", [music_player])
			add_child(music_player)
			music_player.play()
			
			get_node("TitleScreen").visible = false
			get_node("UI").visible = true
			
	if event.is_action_pressed("action"):
		if get_node("TitleScreen").visible:
			
			var music_player = AudioStreamPlayer3D.new()
			var audio = load("res://sounds/engineer/271945__rodincoil__stingers-001.ogg")
			audio.loop = false
			music_player.stream = audio
			music_player.unit_db = 1
			music_player.connect("finished", self, "_stop_player", [music_player])
			add_child(music_player)
			music_player.play()
			
			get_node("TitleScreen").visible = false
			get_node("UI").visible = true
	if event.is_action_pressed("ui_accept"):
		if search_is_focused:
			msg("Searching eden2 world database...", Debug.INFO, self)
			#get_node("UI/WorldSharing/TopContainer2/Search/Search/SearchResults/Content").text = "Searching..."
			Directory.new().make_dir("user://tmp")
			
			var text = get_node("UI/WorldSharing/TopContainer2/Search/Search/SearchResults/Input").text
			
			var http = HTTPRequest.new()
			http.set_download_file("user://tmp/search.list")
			http.connect("request_completed", self, "_on_search_request_completed")
			add_child(http)
			msg("Search string is: " + str(EDEN2_SEARCH + text), Debug.DEBUG, self)
			http.request(EDEN2_SEARCH + text, Array(), false)
			search_client = http


func _stop_player(player):
	player.stop()
	player.queue_free()


func _on_fetch_data_request_completed(result, response_code, headers, body):
	#msg("Result: " + str(result), Debug.DEBUG, self)
	var filename = fetch_data_request.get_download_file()
	var file = File.new()
	
	if file.open(filename, File.READ) != 0:
		msg("Error opening file", Debug.ERROR, self)
	
	if filename == "user://info/changelog.md":
		get_node("UI/Home/VBoxContainer/TopContainer/News/VBoxContainer/Content2").text = file.get_as_text()
		
	elif filename == "user://info/featured-worlds.md":
		get_node("UI/Leaderboard/TopContainer/Featured/VBoxContainer/Content").text = file.get_as_text()
		
	elif filename == "user://info/game-stats.md":
		get_node("UI/Leaderboard/TopContainer/Stats/VBoxContainer/Content2").text = file.get_as_text()
		
	elif filename == "user://info/info.md":
		get_node("UI/Credits/TopContainer3/Info/Content/Text").text = file.get_as_text()
		
	elif filename == "user://info/news.md":
		get_node("UI/Home/VBoxContainer/TopContainer/News/VBoxContainer/Content").text = file.get_as_text()
		
	elif filename == "user://info/new-worlds.md":
		get_node("UI/Leaderboard/TopContainer/Featured/VBoxContainer/Content2").text = file.get_as_text()
		
	elif filename == "user://info/top-users.md":
		get_node("UI/Leaderboard/TopContainer/Users/VBoxContainer/Content").text = file.get_as_text()
		
	elif filename == "user://info/top-worlds.md":
		get_node("UI/Leaderboard/TopContainer/Users/VBoxContainer/Content2").text = file.get_as_text()
	
	if file.get_as_text() != null:
		msg("Data fetch " + str(file_progress) + " of " + str(info.size()) + " successful", Debug.DEBUG, self)
	
	if file_progress < info.size():
		fetch_data_request.set_download_file("user://info/" + info[file_progress])
		str(fetch_data_request.request("http://josephtheengineer.ddns.net/eden/info/" + info[file_progress], Array(), false))
		file_progress += 1



################################## functions ##################################

func fetch_data(): ############################################################
	var dir = Directory.new()
	#if dir.dir_exists("user://info"):
	dir.make_dir("user://info")
	
	if file_progress < info.size():
		fetch_data_request.set_download_file("user://info/" + info[file_progress])
		fetch_data_request.connect("request_completed", self, "_on_fetch_data_request_completed")
		add_child(fetch_data_request)
		fetch_data_request.request("http://josephtheengineer.ddns.net/eden/info/" + info[file_progress], Array(), false)
		file_progress += 1

func update_positions():
	var screen_size = get_node("UI").rect_size
	positions["home"] = Vector2(0, 0)
	positions["leaderboard"] = Vector2(0, screen_size.y)
	positions["world_sharing"] = Vector2(-screen_size.x, 0)
	positions["credits"] = Vector2(0, -screen_size.y)
	positions["account_page"] = Vector2(+screen_size.x, 0)

func show_world_list(parent, world_data, is_downloaded):
	for path in world_data.keys():
		var content = HBoxContainer.new()
		content.rect_min_size = Vector2(0, 125)
		parent.add_child(content)
		
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
			button.connect("pressed", self, "download_world_button", [path])
		
		var seperator = VSeparator.new()
		seperator.rect_min_size = Vector2(20, 0)
		content.add_child(seperator)
		
		var label = Label.new()
		label.size_flags_horizontal = Control.SIZE_FILL
		label.text = world_data[path]
		label.set("custom_fonts/font", load("res://fonts/header.tres"))
		content.add_child(label)

func world_button(world):
	if world == 1:
		msg("Opening world creation menu...", Debug.INFO, self)
		create_new_world()
		#msg("Loading a new flat terrain world...", Debug.INFO, self)
		#map_path = ""
		#map_name = "New Flat Terrain World"
		#map_seed = 0
		#load_world()
	elif world == 3:
		if File.new().file_exists("user://worlds/direct_city.eden2") == false:
			Directory.new().make_dir("user://worlds/")
			
			msg("Please wait, downloading Direct City...", Debug.INFO, self)
			
			var http = HTTPRequest.new()
			http.set_download_file("user://worlds/direct_city.eden2")
			http.connect("request_completed", self, "_on_direct_city_request_completed")
			add_child(http)
			msg("Connecting to http://josephtheengineer.ddns.net/eden/worlds/direct-city.eden2...", Debug.DEBUG, self)
			http.request("http://josephtheengineer.ddns.net/eden/worlds/direct-city.eden2", Array(), false)
			downloading_direct_city = true
			direct_city_downloader = http
		else:
			_on_direct_city_request_completed()
	else:
		msg("Loading a new natural terrain world...", Debug.INFO, self)
		map_path = ""
		map_name = "New Natural Terrain World"
		map_seed = floor(rand_range(0, 9999999))
		load_world()

func _on_direct_city_request_completed():
	downloading_direct_city = false
	msg("Loading direct city...", Debug.INFO, self)
	map_path = "user://worlds/direct_city.eden2"
	map_name = "Direct City"
	map_seed = 0
	load_world()

func create_new_world():
	msg("World creation menu", Debug.DEBUG, self)
	add_child(load("res://scenes/new_world_panel.tscn").instance())

func draw_dots(): #############################################################
	for x in range(OS.get_window_size().x / 10):
		for y in range(OS.get_window_size().y / 10):
			var dot = dot_template.instance()
			get_node("/root/Main Menu/UI/Background").add_child(dot)
			dot.rect_position = Vector2(x*40, y*40)


func update_progress(): #######################################################
	msg("Updating progress...", Debug.DEBUG, self)
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	# Update your progress bar?
	#get_node("progress").set_progress(progress)
	
	# ... or update a progress animation?
	var length = get_node("AnimationPlayer").get_current_animation_length()
	
	# Call this on a paused animation. Use "true" as the second argument to force the animation to update.
	get_node("AnimationPlayer").seek(progress * length, true)


func set_new_scene(scene_resource): ###########################################
	current_scene = scene_resource.instance()
	current_scene.map_seed = map_seed
	current_scene.map_path = map_path
	current_scene.map_name = map_name
	get_node("/root").add_child(current_scene)


func load_world(): ############################################################
	msg("Changing scene to world.tscn...", Debug.INFO, self)
	var path = "res://scenes/world.tscn"
	
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		msg("Loader was null!", Debug.ERROR, self)
		return
	process = true
	
	get_node("UI/LoadingContainer").visible = true
	
	# start your "loading..." animation
	msg("Starting animation...", Debug.DEBUG, self)
	get_node("AnimationPlayer").play("Loading")
	
	wait_frames = 10


func show_msg(message, tag): ##################################################
	if get_tree().get_root().has_node("/root/Main Menu/UI/Home/VBoxContainer/TopContainer/Chat/VBoxContainer/Chat"):
		var Chat = get_tree().get_root().get_node("/root/Main Menu/UI/Home/VBoxContainer/TopContainer/Chat/VBoxContainer/Chat")
		Chat.add_text(tag + ": " + str(message) + '\n')
		
	elif get_tree().get_root().has_node("/root/World/HUD/Chat"):
		var Chat = get_tree().get_root().get_node("/root/World/HUD/Chat")
		Chat.add_text(tag + ": " + str(message) + '\n')


func msg(message, tag): #######################################################
	print(tag, ": ", message)
	show_msg(message, tag)


func _on_SwipeDetector_swiped(direction): #####################################
	msg("Swipe signal received!", Debug.INFO, self)


func _on_search_request_completed(result, response_code, headers, body):
	var file = File.new()
	if file.open("user://tmp/search.list", File.READ) != 0:
		msg("Error opening file", Debug.ERROR, self)
	
	var text = file.get_as_text().rsplit("\n")
	
	var world_data = Dictionary()
	
	var name
	for i in range(text.size() / 2):
		if i % 2:
			# odd
			world_data[name] = text[i]
		else:
			# even
			name = text[i]
	
	msg("World list: " + str(world_data), Debug.DEBUG, self)
	var parent = get_node("UI/WorldSharing/TopContainer2/Search/Search/SearchResults/Content/VBoxContainer")
	show_world_list(parent, world_data, false)
	
	msg("Search complete!", Debug.INFO, self)
	search_client.queue_free()

func _on_search_focus_entered():
	search_is_focused = true


func _on_search_focus_exited():
	search_is_focused = false

func download_world_button(path):
	msg("Searching eden2 world database...", Debug.INFO, self)
	#get_node("UI/WorldSharing/TopContainer2/Search/Search/SearchResults/Content").text = "Downloading..."
	Directory.new().make_dir("user://worlds/")
	
	var http = HTTPRequest.new()
	http.set_download_file("user://worlds/" + path)
	http.connect("request_completed", self, "_on_world_download_completed", ["user://worlds/" + path])
	add_child(http)
	msg("Downloading world " + EDEN2_DOWNLOAD + path, Debug.DEBUG, self)
	http.request(EDEN2_DOWNLOAD + path, Array(), false)
	download_world_client = http
	downloading = true
	
	downloaded_world_path = "user://worlds/" + path
	
	msg("Body size: " + str(http.get_body_size()), Debug.DEBUG, self)

func _on_world_download_completed(path):
	downloading = false
	msg("Loading downloaded world...", Debug.INFO, self)
	map_path = path
	map_name = "WIP"
	map_seed = 0
	download_world_client.queue_free()
	load_world()
