#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.files",
	description = """
		
	"""
}

static func check():
	# Check that folders are made
	var dir := Directory.new()
	if !dir.dir_exists("user://worlds"):
		dir.make_dir("user://worlds")
	
	# Check if client.required_files are downloaded / created
	
