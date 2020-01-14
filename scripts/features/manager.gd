extends Node
var Entity = load("res://scenes/entity.tscn")

func get_entities_with(component: String):
	var object = get_node("/root/World/" + component)
	if object:
		return object.get_children()
	else:
		return false
	

func create(entity: Dictionary):
	Core.emit_signal("msg", "Creating new Entity, " + entity.type, "Debug")
	if entity.type == "interface":
		if !Core.get_parent().get_node("/root/World").has_node("Interfaces"):
			var interfaces = Control.new()
			interfaces.set_name("Interfaces")
			Core.get_parent().get_node("/root/World").add_child(interfaces)
		if entity.name_id == "tty":
			var node = Entity.instance()
			node.set_name("0")
			Core.get_parent().get_node("/root/World/Interfaces").add_child(node)
			Core.get_parent().get_node("/root/World/Interfaces/0").components = entity
			Core.get_parent().get_node("/root/World/Interfaces/0").add_child(load("res://scenes/tty.tscn").instance())
	elif entity.type == "chunk":
		if !Core.get_parent().get_node("/root/World").has_node("Chunks"):
			var chunks = Spatial.new()
			chunks.set_name("Chunks")
			Core.get_parent().get_node("/root/World").add_child(chunks)
		if entity.name_id == "chunk":
			var node = Entity.instance()
			node.set_name(str(entity.id))
			Core.get_parent().get_node("/root/World/Chunks").add_child(node)
			Core.get_parent().get_node("/root/World/Chunks/" + str(entity.id)).components = entity
	elif entity.type == "input":
		if !Core.get_parent().get_node("/root/World").has_node("Inputs"):
			var inputs = Node.new()
			inputs.set_name("Inputs")
			Core.get_parent().get_node("/root/World").add_child(inputs)
		if entity.name_id == "player":
			var node = Entity.instance()
			node.set_name(entity.id)
			Core.get_parent().get_node("/root/World/Inputs").add_child(node)
			Core.get_parent().get_node("/root/World/Inputs/" + entity.id).components = entity
			Core.get_parent().get_node("/root/World/Inputs/" + entity.id).add_child(load("res://scenes/player.tscn").instance())
	#entity.debug = true
	#entity.text = ""
	
	#emit_signal("entity_loaded", entity)

#func create(components):
#	var entity = Dictionary()
#
#	entity.id = unique
#	unique+=1
#	entity.components = components
#
#	var node = MarginContainer.new()
#	node.name = str(entity.id)
#	mouse_filter = MOUSE_FILTER_PASS
#	#node.anchor_right = 1
#	#node.anchor_bottom = 1
#	get_node("/root/World").add_child(node)
#
#	objects[entity.id] = entity
#
#	return entity.id

#func edit(id, components):
#	var entity = Dictionary()
#
#	entity.id = id
#	entity.components = components
#
#	objects.erase(id)
#	objects[entity.id] = entity
#
#	return entity.id
#
#func get_component(id, path):
#	var data = objects[id].components
#	for i in path.split(".", false):
#		if data.has(i):
#			data = data[i]
#		else:
#			return false
#	return data

#func add_node(id, component, node):
#	var path = get_node_path(get_component(id, component + ".parent"))
#
#	if get_tree().get_root().has_node(path):
#		if !get_node(path).has_node(path + str(id)):
#			var entity = MarginContainer.new()
#			entity.name = str(id)
#			entity.mouse_filter = Control.MOUSE_FILTER_PASS
#			get_node(path).add_child(entity)
#
#		get_node(path + str(id)).add_child(node)
#	else:
#		Core.emit_signal("msg", "Parent node doesn't exist yet!", "Warn")
#		return false
#
#	inherit_child_rect(id, component)
#	set_component(id, component + ".rendered", true)
#	return path
#
#func inherit_child_rect(id, component): # component string
#	var parent = get_node(get_node_path(get_component(id, component + ".parent")) + str(id))
#	var child = get_node(get_node_path(get_component(id, component + ".parent")) + str(id) + "/" + component.capitalize().split(" ").join(""))
#	parent.size_flags_horizontal = Control.SIZE_FILL
#	if component != "joystick":
#		parent.size_flags_vertical = Control.SIZE_FILL
#	parent.rect_min_size = child.rect_min_size
#	parent.rect_size = child.rect_size
#	parent.margin_bottom = 0
#	parent.margin_left = 0
#	parent.margin_right = 0 
#	parent.margin_top = 0

