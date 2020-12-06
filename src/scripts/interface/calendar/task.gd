#warning-ignore:unused_class_variable
const meta := {
	script_name = "interface.calendar.task",
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

# interface.calendar.task.list #################################################
const list_meta := {
	script = meta,
	func_name = "interface.calendar.task.list",
	description = """
		List all tasks
	""",
		}
static func list(args := list_meta) -> void: ########################
	Core.emit_signal("msg", "Tasks: ", Core.INFO, args)
	
	var tasks = []
	
	var f = Core.scripts.interface.calendar.task.list_files_in_directory(
		Core.scripts.interface.calendar.task.TASKS_FOLDER )
	
	for task in f:
		var task_data = Core.scripts.interface.calendar.task.read_task(
			int(task.name) )
		if task_data:
			tasks.append(task_data)
	
	var text = ""
	var header := 0
	for i in range(tasks.size()):
		if "###" in tasks[i].name:
			text +=  '\n' + tasks[i].name + '\n'
			header += 1
		else:
			text += (str(i-header) + ". "
			+ tasks[i].due_date + ": " + tasks[i].name + '\n' )
	
	Core.emit_signal("msg", text, Core.INFO, args)
# ^ interface.calendar.task.list ###############################################



# interface.calendar.task.create_task ##########################################
const create_task_meta := {
	func_name = "interface.calendar.task.create_task",
	description = """
		Creates a new task
	""",
		task = task_template }
static func create_task(args := create_task_meta) -> void: #####################
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
	
	for key in args.task.keys():
		var file = File.new()
		if args.task[key] is Array:
			dir.make_dir(TASKS_FOLDER + str(id) + "/" + key)
			var index = 0
			for value in args.task[key]:
				file.open(
					TASKS_FOLDER + str(id) + "/" + key +
					"/" + str(index), File.WRITE )
				file.store_string(value + "\n")
				file.close()
				index += 1
		else:
			file.open(
				TASKS_FOLDER + str(id) + "/" + key, File.WRITE )
			file.store_string(str(args.task[key]) + "\n")
			file.close()
# ^ interface.calendar.task.create_task ########################################



# interface.calendar.task.sort_ascending_time ##################################
const sort_ascending_time_meta := {
	func_name = "interface.calendar.task.sort_ascending_time",
	description = """
		Sorts a and b ascending
	""",
		a = 0,
		b = 0,
		highest_number = "" }
static func sort_ascending_time(args := create_task_meta) -> void: #############
	if args.a[0] < args.b[0]:
		args.highest_number = "b"
		return
	args.highest_number = "a"
	return
# ^ interface.calendar.task.sort_ascending_time ################################


# interface.calendar.task.read #################################################
const read_meta := {
	func_name = "iinterface.calendar.task.read",
	description = """
		Reads a task folder into a dictionary
	""",
		id = 0,
		task = {} }
static func read(args := create_task_meta) -> void: ############################
	var task = task_template.duplicate(true)
	#var dir = Directory.new()
	#if !dir.file_exists(TASKS_FOLDER):
	#	breakpoint
	#	return false
	
	#if !dir.file_exists(TASKS_FOLDER + str(id)):
	#	breakpoint
	#	return false
	
	for file in list_files_in_directory(TASKS_FOLDER + str(args.id)):
		if file.is_dir:
			for sub_file in list_files_in_directory(
				TASKS_FOLDER + str(args.id) + "/" + file.name ):
				
				var f = File.new()
				var path = (TASKS_FOLDER + str(args.id) + "/"
					+ file.name + "/" + sub_file.name)
				
				var err = f.open(path, File.READ)
				if err:
					Core.emit_signal(
						"msg", 
						"Error when opening task "
						+ path + ": " + str(err),
						Core.WARN, meta )
				else:
					task[file.name][int(sub_file.name)] = f.get_as_text().replace("\n", "")
					f.close()
		else:
			var f = File.new()
			f.open( TASKS_FOLDER + str(args.id) + "/" 
				+ file.name, File.READ )
			
			task[file.name] = f.get_as_text().replace("\n", "")
			f.close()
	args.task = task
	return
# ^ interface.calendar.task.read ###############################################



static func list_files_in_directory(path):
	var files = []
	var dir := Directory.new()
	var err = dir.open(path)
	if err:
		Core.emit_signal("msg", "Error when opening folder " + path + ": " + str(err), Core.WARN, meta)
		return false
	
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
	var err = dir.remove(TASKS_FOLDER + str(id))
	if err:
		Core.emit_signal("msg", "Error when deleting task folder " + TASKS_FOLDER + str(id) + ": " + str(err), Core.ERROR, meta)
