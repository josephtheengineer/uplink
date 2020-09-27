extends Node
class_name DownloadSystem
#warning-ignore:unused_class_variable
const meta := {
	script_name = "sys.download",
	description = """
		might be called sys.file in the future (more generic)
		when you realise that after making the engine,
		you still have to make the game
	"""
}
#warning-ignore:unused_class_variable
const DEFAULT_DATA := {
	downloading = false,
	downloading_wait = 0,
	download_world_client = null,
	downloaded_world_path = null,
	search_client = null,
	downloading_direct_city = false,
	direct_city_downloader = null,
	map = {
		seed = 0,
		path = "res://world/direct_city.eden2",
		name = "direct_city.eden2"
	},
	required = [
		{
			type = "world",
			name = "direct_city",
			format = "eden",
			format_version = 2,
			timestamp = "1600458467",
			title = "direct city and dc empire 4'1",
			url = "http://files.edengame.net/1600458467.eden"
		}
	]
}
#warning-ignore:unused_class_variable
var data := DEFAULT_DATA.duplicate(true)

const EDEN2_SEARCH = "http://app.edengame.net/list2.php?search="
const EDEN2_DOWNLOAD = "http://files.edengame.net/"

func _ready(): #################################################################
	Core.connect("reset", self, "_reset")
	Core.emit_signal("system_ready", Core.scripts.core.system.DOWNLOAD, self)          ##### READY #####


func _reset():
	Core.emit_signal("msg", "Reseting download system database...", Core.DEBUG, meta)
	data = DEFAULT_DATA.duplicate(true)


func _on_fetch_data_request_completed(_result, _response_code, _headers, _body): ###
	#msg("Result: " + str(result), Core.DEBUG, meta)
	var filename = null #fetch_data_request.get_download_file()
	var file = File.new()
	
	if file.open(filename, File.READ) != 0:
		Core.emit_signal("msg", "Error opening file", Core.ERROR, meta)
	
	if filename == "user://info/changelog.md":
		var text_box: RichTextLabel = get_node("UI/Home/VBoxContainer/TopContainer/News/VBoxContainer/Content2")
		text_box.text = file.get_as_text()
	
	elif filename == "user://info/featured-worlds.md":
		var text_box: RichTextLabel = get_node("UI/Leaderboard/TopContainer/Featured/VBoxContainer/Content")
		text_box.text = file.get_as_text()
	
	elif filename == "user://info/game-stats.md":
		var text_box: RichTextLabel = get_node("UI/Leaderboard/TopContainer/Stats/VBoxContainer/Content2")
		text_box.text = file.get_as_text()
	
	elif filename == "user://info/info.md":
		var text_box: RichTextLabel = get_node("UI/Credits/TopContainer3/Info/Content/Text")
		text_box.text = file.get_as_text()
	
	elif filename == "user://info/news.md":
		var text_box: RichTextLabel = get_node("UI/Home/VBoxContainer/TopContainer/News/VBoxContainer/Content")
		text_box.text = file.get_as_text()
	
	elif filename == "user://info/new-worlds.md":
		var text_box: RichTextLabel = get_node("UI/Leaderboard/TopContainer/Featured/VBoxContainer/Content2")
		text_box.text = file.get_as_text()
	
	elif filename == "user://info/top-users.md":
		var text_box: RichTextLabel = get_node("UI/Leaderboard/TopContainer/Users/VBoxContainer/Content")
		text_box.text = file.get_as_text()
	
	elif filename == "user://info/top-worlds.md":
		var text_box: RichTextLabel = get_node("UI/Leaderboard/TopContainer/Users/VBoxContainer/Content2")
		text_box.text = file.get_as_text()
	
	#if file.get_as_text() != null:
		#msg("Data fetch " + str(file_progress) + " of " + str(info.size()) + " successful", Core.DEBUG, meta)
	
	#if file_progress < info.size():
		#fetch_data_request.set_download_file("user://info/" + info[file_progress])
		#str(fetch_data_request.request("http://josephtheengineer.ddns.net/eden/info/" + info[file_progress], Array(), false))
		#file_progress += 1


func fetch_data(): #############################################################
	var dir = Directory.new()
	#if dir.dir_exists("user://info"):
	dir.make_dir("user://info")
	
	#if file_progress < info.size():
		#fetch_data_request.set_download_file("user://info/" + info[file_progress])
		#fetch_data_request.connect("request_completed", self, "_on_fetch_data_request_completed")
		#add_child(fetch_data_request)
		#fetch_data_request.request("http://josephtheengineer.ddns.net/eden/info/" + info[file_progress], Array(), false)
		#file_progress += 1


#func _on_search_request_completed(result, response_code, headers, body): #######
#	var file = File.new()
#	if file.open("user://tmp/search.list", File.READ) != 0:
#		Core.emit_signal("msg", "Error opening file", Core.ERROR, meta)
#
#	var text = file.get_as_text().rsplit("\n")
#
#	var world_data = Dictionary()
#
#	var name
#	for i in range(text.size() / 2):
#		if i % 2:
#			# odd
#			world_data[name] = text[i]
#		else:
#			# even
#			name = text[i]
#
#	Core.emit_signal("msg", "World list: " + str(world_data), Core.DEBUG, meta)
#	#var parent = get_node("UI/WorldSharing/TopContainer2/Search/Search/SearchResults/Content/VBoxContainer")
#	#show_world_list(parent, world_data, false)
#
#	Core.emit_signal("msg", "Search complete!", Core.INFO, meta)
#	#search_client.queue_free()


#func _on_world_download_completed(path: String): #######################################
	#downloading = false
	#Core.emit_signal("msg", "Loading downloaded world...", Core.INFO, meta)
	#map_path = path
	#map_name = "WIP"
	#map_seed = 0
	#download_world_client.queue_free()
	#load_world()

func _process(delta):
	#if downloading_direct_city and OS.get_unix_time() - downloading_wait > 5:
	#	Core.emit_signal("msg", "KB downloaded: " + str(direct_city_downloader.get_downloaded_bytes() * 0.001), Core.INFO, meta)
	#	downloading_wait = OS.get_unix_time()
		
	if data.downloading:
		if OS.get_unix_time() - data.downloading_wait > 5:
			Core.emit_signal("msg", "KB downloaded: " + str(data.download_world_client.get_downloaded_bytes() * 0.001), Core.INFO, meta)
			data.downloading_wait = OS.get_unix_time()
			
			#if last_downloaded_bytes == download_world_client.get_downloaded_bytes() and last_downloaded_bytes != 0:
				#_on_world_download_completed(downloaded_world_path)
			
			#last_downloaded_bytes = download_world_client.get_downloaded_bytes()


func search(): #################################################################
	Core.emit_signal("msg", "Searching eden2 world database...", Core.INFO, meta)
	#get_node("UI/WorldSharing/TopContainer2/Search/Search/SearchResults/Content").text = "Searching..."
	var err := Directory.new().make_dir("user://tmp")
	if err:
		Core.emit_signal("msg", "Could not create user://tmp"
			+ ": " + str(err), Core.WARN, meta)
	
	var text_node: TextEdit = get_node("UI/WorldSharing/TopContainer2/Search/Search/SearchResults/Input")
	var text = text_node.text
	
	var http = HTTPRequest.new()
	http.set_download_file("user://tmp/search.list")
	http.connect("request_completed", self, "_on_search_request_completed")
	add_child(http)
	Core.emit_signal("msg", "Search string is: " + str(EDEN2_SEARCH + text), Core.DEBUG, meta)
	http.request(EDEN2_SEARCH + text, Array(), false)
	data.search_client = http


func download_direct_city(): ###################################################
	if File.new().file_exists("user://world/direct_city.eden2") == false:
		var error = Directory.new().make_dir("user://world/")
		if error:
			emit_signal("msg", "Failed to create worlds folder: " 
				+ str(error), Core.WARN, meta)
		
		Core.emit_signal("msg", "Please wait, downloading Direct City...", Core.INFO, meta)
		
		var http = HTTPRequest.new()
		http.set_download_file("user://world/direct_city.eden2")
		http.connect("request_completed", self, "_on_direct_city_request_completed")
		add_child(http)
		Core.emit_signal("msg", "Connecting to http://josephtheengineer.ddns.net/eden/worlds/direct-city.eden2...", Core.DEBUG, meta)
		http.request("http://josephtheengineer.ddns.net/eden/worlds/direct-city.eden2", Array(), false)
		data.downloading_direct_city = true
		data.direct_city_downloader = http
	else:
		pass
		#_on_direct_city_request_completed()


func download_world_button(path: String): ##############################################
	Core.emit_signal("msg", "Searching eden2 world database...", Core.INFO, meta)
	#get_node("UI/WorldSharing/TopContainer2/Search/Search/SearchResults/Content").text = "Downloading..."
	var error = Directory.new().make_dir("user://world/")
	if error:
		emit_signal("msg", "Failed to create worlds folder: " 
			+ str(error), Core.WARN, meta)
	
	var http = HTTPRequest.new()
	http.set_download_file("user://world/" + path)
	http.connect("request_completed", self, "_on_world_download_completed", ["user://world/" + path])
	add_child(http)
	Core.emit_signal("msg", "Downloading world " + EDEN2_DOWNLOAD + path, Core.DEBUG, meta)
	http.request(EDEN2_DOWNLOAD + path, Array(), false)
	data.download_world_client = http
	data.downloading = true
	
	data.downloaded_world_path = "user://world/" + path
	
	Core.emit_signal("msg", "Body size: " + str(http.get_body_size()), Core.DEBUG, meta)


func download_file(file: Dictionary): ##############################################
	#Core.emit_signal("msg", "Searching eden2 world database...", Core.INFO, meta)
	#get_node("UI/WorldSharing/TopContainer2/Search/Search/SearchResults/Content").text = "Downloading..."
	#var error = Directory.new().make_dir("user://world/")
	#if error:
	#	emit_signal("msg", "Failed to create world folder: " 
	#		+ str(error), Core.WARN, meta)
	
	var http = HTTPRequest.new()
	http.set_download_file("user://" + file.type + "/" + file.name)
	http.connect("request_completed", self, "_on_file_download_completed", [file])
	add_child(http)
	Core.emit_signal("msg", "Downloading world " + file.url, Core.INFO, meta)
	http.request(file.url)
	data.download_world_client = http
	data.downloading = true
	
	data.downloaded_world_path = "user://" + file.type + "/" + file.name
	
	Core.emit_signal("msg", "Body size: " + str(http.get_body_size()), Core.DEBUG, meta)

var http_error = [
	"Request successful",
	"Body size mismatch",
	"Request failed while connecting",
	"Request failed while resolving",
	"Request failed due to connection (read/write) error",
	"Request failed on SSL handshake",
	"Request does not have a response (yet)",
	"Request exceeded its maximum size limit, see body_size_limit",
	"Request failed (currently unused)",
	"HTTPRequest couldn't open the download file",
	"HTTPRequest couldn't write to the download file",
	"Request reached its maximum redirect limit, see max_redirects",
	"Request timed out"
]

func _on_file_download_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray, file: Dictionary):
	Core.emit_signal("msg", file.url + " finished downloading! code: " + http_error[result], Core.INFO, meta)
	data.downloading = false


func _on_direct_city_request_completed(): ######################################
	data.downloading_direct_city = false
	Core.emit_signal("msg", "Loading direct city...", Core.INFO, meta)
	data.map.path = "user://world/direct_city.eden2"
	data.map.name = "Direct City"
	data.map.seed = 0
	#load_world()
