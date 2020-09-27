#warning-ignore:unused_class_variable
const meta := {
	script_name = "client.player.main",
	description = """
		player utils
	"""
}

static func attach(player: Entity): ##########################################################
	Core.emit_signal("msg", "Attaching mouse to player..." + str(player), Core.TRACE, meta)
	player.components.position.mode = "fly"
	Core.client.data.subsystem.input.Link.attach_mouse(player)
	player.components.position.mouse_attached = true
