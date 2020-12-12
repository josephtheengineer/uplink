#warning-ignore:unused_class_variable
const meta := {
	script_name = "client.video",
	description = """
		
	"""
}

# client.video.take_screenshot #################################################
const take_screenshot_meta := {
	func_name = "client.video.take_screenshot",
	description = """
		
	""",
		name = "screenshot.png"}
static func take_screenshot(args := take_screenshot_meta) -> void: #############
	Core.emit_signal("msg", "Saving screenshot to " + args.name, Core.INFO, args)
	var data = Core.get_viewport().get_texture().get_data()
	data.flip_y()
	data.save_png(args.name)
# ^ client.video.take_screenshot ###############################################


# client.video.start_capture ###################################################
const start_capture_meta := {
	func_name = "client.video.start_capture",
	description = """
		
	""",
		name = "screenshot.png"}
static func start_capture(args := start_capture_meta) -> void: #################
	Core.emit_signal("msg", "Saving video to " + args.name, Core.INFO, args)
	var data = Core.get_viewport().get_texture().get_data()
	data.flip_y()
	data.save_png('screenshot.png')
# ^ client.video.start_capture #################################################
