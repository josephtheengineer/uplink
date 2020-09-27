#warning-ignore:unused_class_variable
const meta := {
	script_name = "calendar.task",
	description = """
		
	"""
}

const TASKS_FOLDER := "user://task/"

const task_template := {
	name = "Get a life",
	time_allocation = "1h",
	due_date = "5w",
	urgency = "M",
	difficulty = "M",
	enjoyability = "M",
	types = ["writing", "creative"],
	dependencies = -1,
	projects = ["catalyst", "calendar", "docs"],
	notes = "",
	recur = "no",
	timeslot = "2d 10->11"
}

static func sort_ascending_time(a, b):
	if a[0] < b[0]:
		return true
	return false

static func read_task(id: int):
	var task = task_template.duplicate(true)
	var dir = Directory.new()
	#if !dir.file_exists(TASKS_FOLDER):
	#	breakpoint
	#	return false
	
	#if !dir.file_exists(TASKS_FOLDER + str(id)):
	#	breakpoint
	#	return false
	
	for file in list_files_in_directory(TASKS_FOLDER + str(id)):
		if file.is_dir:
			for sub_file in list_files_in_directory(TASKS_FOLDER + str(id) + file.name):
				var f = File.new()
				var err = f.open(TASKS_FOLDER + str(id) + "/" + file.name + "/" + sub_file.name, File.READ)
				if err:
					Core.emit_signal("msg", "Error when opening task file: " + str(err), Core.WARN, meta)
				else:
					task[file.name][int(sub_file.name)] = f.get_as_text().replace("\n", "")
					f.close()
		else:
			var f = File.new()
			f.open(TASKS_FOLDER + str(id) + "/" + file.name, File.READ)
			task[file.name] = f.get_as_text().replace("\n", "")
			f.close()
	return task

static func list_files_in_directory(path):
	var files = []
	var dir := Directory.new()
	dir.open(path)
	dir.list_dir_begin(true)
	
	while true:
		var file = dir.get_next()
		var is_dir = dir.current_is_dir()
		if file == "":
			break
		var file_data = Dictionary()
		file_data.name = file
		file_data.is_dir = is_dir
		files.append(file_data)
	
	dir.list_dir_end()
	
	return files

static func delete_task(id: int):
	var dir := Directory.new()
	dir.remove(TASKS_FOLDER + str(id))

static func create_task(task: Dictionary):
	var files = list_files_in_directory(TASKS_FOLDER)
	var id := 0
	for file in files:
		if int(file) > id:
			id = int(file)
	id += 1
	
	var dir = Directory.new()
	if !dir.file_exists(TASKS_FOLDER):
		dir.make_dir(TASKS_FOLDER)
	
	if !dir.file_exists(TASKS_FOLDER + str(id)):
		dir.make_dir(TASKS_FOLDER + str(id))
	
	for key in task.keys():
		var file = File.new()
		if task[key] is Array:
			dir.make_dir(TASKS_FOLDER + str(id) + "/" + key)
			var index = 0
			for value in task[key]:
				file.open(TASKS_FOLDER + str(id) + "/" + key + "/" + str(index), File.WRITE)
				file.store_string(value + "\n")
				file.close()
				index += 1
		else:
			file.open(TASKS_FOLDER + str(id) + "/" + key, File.WRITE)
			file.store_string(str(task[key]) + "\n")
			file.close()
