extends Node
var Debug = load("res://scripts/features/debug.gd")

const EDEN2_SEARCH = "http://app.edengame.net/list2.php?search="
const EDEN2_DOWNLOAD = "http://files.edengame.net/"

var downloading = false
var downloading_wait = 0
var download_world_client
var downloaded_world_path
var last_downloaded_bytes
var search_client
var past_frames = 0

var downloading_direct_city = false
var direct_city_downloader

var map_seed = 0
var map_path = "res://worlds/direct_city.eden2"
var map_name = "direct_city.eden2"

func _ready():
	Debug.msg("Download System ready.", "Info")


func _on_fetch_data_request_completed(result, response_code, headers, body):
	#msg("Result: " + str(result), "Debug")
	var filename = null #fetch_data_request.get_download_file()
	var file = File.new()
	
	if file.open(filename, File.READ) != 0:
		Debug.msg("Error opening file", "Error")
	
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
	
	#if file.get_as_text() != null:
		#msg("Data fetch " + str(file_progress) + " of " + str(info.size()) + " successful", "Debug")
	
	#if file_progress < info.size():
		#fetch_data_request.set_download_file("user://info/" + info[file_progress])
		#str(fetch_data_request.request("http://josephtheengineer.ddns.net/eden/info/" + info[file_progress], Array(), false))
		#file_progress += 1


func fetch_data(): ############################################################
	var dir = Directory.new()
	#if dir.dir_exists("user://info"):
	dir.make_dir("user://info")
	
	#if file_progress < info.size():
		#fetch_data_request.set_download_file("user://info/" + info[file_progress])
		#fetch_data_request.connect("request_completed", self, "_on_fetch_data_request_completed")
		#add_child(fetch_data_request)
		#fetch_data_request.request("http://josephtheengineer.ddns.net/eden/info/" + info[file_progress], Array(), false)
		#file_progress += 1


func _on_search_request_completed(result, response_code, headers, body):
	var file = File.new()
	if file.open("user://tmp/search.list", File.READ) != 0:
		Debug.msg("Error opening file", "Error")
	
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
	
	Debug.msg("World list: " + str(world_data), "Debug")
	var parent = get_node("UI/WorldSharing/TopContainer2/Search/Search/SearchResults/Content/VBoxContainer")
	#show_world_list(parent, world_data, false)
	
	Debug.msg("Search complete!", "Info")
	#search_client.queue_free()

func _on_world_download_completed(path):
	#downloading = false
	Debug.msg("Loading downloaded world...", "Info")
	#map_path = path
	#map_name = "WIP"
	#map_seed = 0
	#download_world_client.queue_free()
	#load_world()

#func _process(delta):
	#if downloading_direct_city and OS.get_unix_time() - downloading_wait > 5:
	#	Debug.msg("KB downloaded: " + str(direct_city_downloader.get_downloaded_bytes() * 0.001), "Info")
	#	downloading_wait = OS.get_unix_time()
	#	
	#if downloading:
	#	if OS.get_unix_time() - downloading_wait > 5:
	#		Debug.msg("KB downloaded: " + str(download_world_client.get_downloaded_bytes() * 0.001), "Info")
	#		downloading_wait = OS.get_unix_time()
	#		
	#		#if last_downloaded_bytes == download_world_client.get_downloaded_bytes() and last_downloaded_bytes != 0:
	#			#_on_world_download_completed(downloaded_world_path)
	#		
	#		#last_downloaded_bytes = download_world_client.get_downloaded_bytes()

func search():
	Debug.msg("Searching eden2 world database...", "Info")
	#get_node("UI/WorldSharing/TopContainer2/Search/Search/SearchResults/Content").text = "Searching..."
	Directory.new().make_dir("user://tmp")
	
	var text = get_node("UI/WorldSharing/TopContainer2/Search/Search/SearchResults/Input").text
	
	var http = HTTPRequest.new()
	http.set_download_file("user://tmp/search.list")
	http.connect("request_completed", self, "_on_search_request_completed")
	add_child(http)
	Debug.msg("Search string is: " + str(EDEN2_SEARCH + text), "Debug")
	http.request(EDEN2_SEARCH + text, Array(), false)
	search_client = http

func download_direct_city():
	if File.new().file_exists("user://worlds/direct_city.eden2") == false:
		Directory.new().make_dir("user://worlds/")
		
		Debug.msg("Please wait, downloading Direct City...", "Info")
		
		var http = HTTPRequest.new()
		http.set_download_file("user://worlds/direct_city.eden2")
		http.connect("request_completed", self, "_on_direct_city_request_completed")
		add_child(http)
		Debug.msg("Connecting to http://josephtheengineer.ddns.net/eden/worlds/direct-city.eden2...", "Debug")
		http.request("http://josephtheengineer.ddns.net/eden/worlds/direct-city.eden2", Array(), false)
		downloading_direct_city = true
		direct_city_downloader = http
	else:
		pass
		#_on_direct_city_request_completed()

func download_world_button(path):
	Debug.msg("Searching eden2 world database...", "Info")
	#get_node("UI/WorldSharing/TopContainer2/Search/Search/SearchResults/Content").text = "Downloading..."
	Directory.new().make_dir("user://worlds/")
	
	var http = HTTPRequest.new()
	http.set_download_file("user://worlds/" + path)
	http.connect("request_completed", self, "_on_world_download_completed", ["user://worlds/" + path])
	add_child(http)
	Debug.msg("Downloading world " + EDEN2_DOWNLOAD + path, "Debug")
	http.request(EDEN2_DOWNLOAD + path, Array(), false)
	download_world_client = http
	downloading = true
	
	downloaded_world_path = "user://worlds/" + path
	
	Debug.msg("Body size: " + str(http.get_body_size()), "Debug")

func _on_direct_city_request_completed():
	downloading_direct_city = false
	Debug.msg("Loading direct city...", "Info")
	map_path = "user://worlds/direct_city.eden2"
	map_name = "Direct City"
	map_seed = 0
	#load_world()