extends Node
onready var Events = get_node("/root/Events")
onready var Debug = preload("res://scripts/features/debug.gd").new()

func get_entities_with(component: String):
	var object = get_node("/root/World/" + component)
	if object:
		return object.get_children()
	else:
		return false

func create(entity: Dictionary):
	Debug.msg("Creating new Entity, " + entity.type, "Debug")
	emit_signal("entity_loaded", entity)

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
#		Debug.msg("Parent node doesn't exist yet!", "Warn")
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

