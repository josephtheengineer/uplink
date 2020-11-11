#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.files",
	description = """
		
	"""
}

static func check():
	# Check that folders are made
	var dir := Directory.new()
	if !dir.dir_exists("user://world"):
		dir.make_dir("user://world")
	
	for file in Core.client.data.subsystem.download.Link.data.required:
		if not dir.file_exists("user://" + file.type + "/" + file.name):
			Core.emit_signal("msg", file.type + " " + file.name + "does not exist", Core.WARN, meta)
			Core.Client.data.subsystem.download.Link.download_file(file)
	