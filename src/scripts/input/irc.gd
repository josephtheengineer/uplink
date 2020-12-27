#warning-ignore:unused_class_variable
const meta := {
	script_name = "input.irc",
	description = """
		
	"""
}

# input.irc.join ###############################################################
const join_meta := {
	func_name = "input.irc.join",
	description = """
		
	""",
		ip = "weber.freenode.net",
		nick = "GodotIRCTest",
		channel = "#godotengine",
		password = "",
		client = null}
static func join(args := join_meta) -> void: 
	var client = StreamPeerTCP.new()
	client.connect_to_host(args.ip, 6667)
	#if args.password != "":
	#	client.put_data(("JOIN "+ args.password +"\n").to_utf8())
	yield(Core.get_tree().create_timer(1.0), "timeout")
	client.put_data(("USER "+ args.nick +" "+ args.nick +" "+ args.nick +" :TEST\n").to_utf8())
	yield(Core.get_tree().create_timer(1.0), "timeout")
	client.put_data(("NICK "+ args.nick +"\n").to_utf8())
	yield(Core.get_tree().create_timer(1.0), "timeout")
	client.put_data(("NICKSERV REGISTER test joseph@theengineer.life\n").to_utf8())
	yield(Core.get_tree().create_timer(1.0), "timeout")
	#client.put_data(("NICKSERV IDENTIFY test\n").to_utf8())
	client.put_data(("JOIN "+ args.channel +"\n").to_utf8())
	
	args.client = client
	Core.world.get_node("Interface").data.client = client
# ^ input.irc.join #############################################################


# input.irc.fetch ##############################################################
const fetch_meta := {
	func_name = "input.irc.fetch",
	description = """
		
	""",
		client = null,
		time = "0",
		channel = "#godotengine"}
static func fetch(args := fetch_meta) -> void: 
	if !args.client:
		Core.emit_signal("msg", "Error when sending text, StreamPeerClient object was not set", Core.WARN, args)
		return
	if args.client.is_connected_to_host() && args.client.get_available_bytes() >0:
		
		var a = str(args.client.get_utf8_string(args.client.get_available_bytes()))
		a = a.split('\n')
		for b in a:
			Core.emit_signal("msg", "[color=green]IRC:[/color] " + b, Core.DEBUG, args)
			b = b.split(' ')
			if b.size() > 1:
				if b[0] == "PING":
					args.client.put_data(("PONG "+ str(b[1]) +"\n").to_utf8())
				elif b[1] == "NOTICE":
					var text = ""
					for i in range (4, b.size()):
						text += b[i] + " "
					Core.emit_signal("msg", "[" + args.time + "][i] [color=green]SERVER:[/color] " + text + "[/i]", Core.INFO, args)
				elif b[1] == "JOIN":
					Core.emit_signal("msg", "[" + args.time + "][i] [color=red]==[/color] " + Core.call("input.irc.get_name_user", {value=b[0]}).user + " has joined " + str(args.channel) + "[/i]", Core.INFO, meta)
				elif b[1] == "QUIT":
					var text = ""
					for i in range (4, b.size()):
						text += b[i] + " "
					Core.emit_signal("msg", "[" + args.time + "][i] == " + get_name_user(b[0]) + " QUIT (" + str(text) + ")[/i]", Core.INFO, args)
				elif b[1] == "PART":
					Core.emit_signal("msg", "[" + args.time + "][i] == " + get_name_user(b[0]) + " has left " + str(args.channel) + "[/i]", Core.INFO, args)
				elif b[1] == "PRIVMSG":
					var text = ""
					for i in range (3, b.size()):
						text += b[i] + " "
					text = text.substr(1, text.length()-1)
					Core.emit_signal("msg", "[" + args.time + "] <" + get_name_user(b[0]) + "> " + str(text), Core.INFO, args)
				else:
					Core.emit_signal("msg", "[" + args.time + "] [UKNOWN TYPE] " + str(b), Core.INFO, args)
# ^ input.irc.fetch ############################################################


# input.irc.get_name_user ######################################################
const get_name_user_meta := {
	func_name = "input.irc.get_name_user",
	description = """
		
	""",
		value = null,
		user = null}
static func get_name_user(args := get_name_user_meta) -> void: #################
	var a = args.value.find("!")
	args.user = args.value.substr(1, a-1)
# ^ input.irc.get_name_user ####################################################


# input.irc.enter_text #########################################################
const enter_text_meta := {
	func_name = "input.irc.enter_text",
	description = """
		
	""",
		text = "",
		client = null,
		nick = "test",
		time = "0",
		channel = "#godotengine"}
static func enter_text(args := enter_text_meta) -> void: #######################
	Core.emit_signal("msg", "[" + args.time + "] <" + args.nick + "> " + str(args.text), Core.INFO, args)
	if !args.client:
		args.client = Core.world.get_node("Interface").data.client
	if !args.client:
		Core.emit_signal("msg", "Error when sending text, StreamPeerClient object was not set", Core.WARN, args)
		return
	#args.client.put_data(("PRIVMSG "+ args.channel + " :" + str(args.text) +"\n").to_utf8())
	args.client.put_data((str(args.text) +"\n").to_utf8())
# ^ input.irc.enter_text #######################################################
