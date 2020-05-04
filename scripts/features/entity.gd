# manages and stores entity data
extends Node
var script_name = "entity"
var DictonaryFunc = load("res://scripts/features/dictonary_func.gd")

export var components = Dictionary()

func destory():
	Core.emit_signal("object_unloaded", self)
	queue_free()
	Core.emit_signal("object_unloaded", self)

func set_component(path, value):
	DictonaryFunc.setInDict(components, path.split(".", false), value)
	components = components

#func get_node_path():
#	var parent = get_parent()
#	var parents = Array()
#	var root = false
#	while root == false:
#		#Debug.msg("Parent = " + str(parent.id) + parent.component, Debug.DEBUG, self)
#		parents.append(parent)
#		var woah = get_component(parent.id, parent.component + ".parent" )
#
#		if woah:
#			parent = woah
#		else:
#			root = true
#
#	var path = "/root/World/"
#	parents.invert()
#	for entity in parents:
#		var comp = entity.component.capitalize().split(" ").join("")
#
#		path += str(entity.id) + "/" + comp + "/"
#
#	return path
