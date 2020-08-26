# manages and stores entity data
class_name Entity
extends Node
#warning-ignore:unused_class_variable
const script_name := "entity"
var DictonaryFunc := preload("res://src/scripts/dictionary/func.gd").new()

export var components := Dictionary()

func destory(): ################################################################
	Core.emit_signal("object_unloaded", self)
	queue_free()
	Core.emit_signal("object_unloaded", self)

func set_component(path: String, value): #######################################
	DictonaryFunc.setInDict(components, path.split(".", false), value)
	components = components
