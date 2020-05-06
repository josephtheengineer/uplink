extends Node

#warning-ignore:unused_class_variable
var script_name = "core"
onready var Debug = preload("res://scripts/features/debug.gd").new()

#warning-ignore:unused_class_variable
onready var Client = get_node("/root/World/Systems/Client")
#warning-ignore:unused_class_variable
onready var Server = get_node("/root/World/Systems/Server")

#warning-ignore:unused_signal
signal system_ready(system, obj)
#warning-ignore:unused_signal
signal entity_loaded(entity)
#warning-ignore:unused_signal
signal request_entity_unload(entity)
#warning-ignore:unused_signal
signal app_ready()
#warning-ignore:unused_signal
signal request_scene_load(scene)
#warning-ignore:unused_signal
signal scene_loaded(scene)
#warning-ignore:unused_signal
signal entity_moved(entity, dir)
#warning-ignore:unused_signal
signal entity_used(entity, amount)
#warning-ignore:unused_signal
signal msg(message, level, obj)
#warning-ignore:unused_signal
signal damage_dealt(target, shooter, weapon_data)
#warning-ignore:unused_signal
signal damage_taken(target, shooter)
#warning-ignore:unused_signal
signal entity_picked_up(picker, entity)
#warning-ignore:unused_signal
signal break_block(block)
#warning-ignore:unused_signal
signal place_block(block)

#warning-ignore:unused_signal
signal gui_loaded(name, entity)
#warning-ignore:unused_signal
signal gui_pushed(name, init_param)

var error
func _ready():
	error = connect("system_ready", self, "_on_system_ready")
	if error:
		emit_signal("msg", "Error on binding to system_ready: " + str(error), Debug.WARN, self)
	
	
	error = connect("entity_loaded", self, "_on_entity_loaded")
	if error:
		emit_signal("msg", "Error on binding to entity_loaded: " + str(error), Debug.WARN, self)
	
	
	error = connect("request_entity_unload", self, "_on_request_entity_unload")
	if error:
		emit_signal("msg", "Error on binding to request_entity_unload: " + str(error), Debug.WARN, self)
	
	
	error = connect("app_ready", self, "_on_app_ready")
	if error:
		emit_signal("msg", "Error on binding to app_ready: " + str(error), Debug.WARN, self)
	
	
	error = connect("request_scene_load", self, "_on_request_scene_load")
	if error:
		emit_signal("msg", "Error on binding to request_scene_load: " + str(error), Debug.WARN, self)
	
	
	error = connect("scene_loaded", self, "_on_scene_loaded")
	if error:
		emit_signal("msg", "Error on binding to scene_loaded: " + str(error), Debug.WARN, self)
	
	
	error = connect("entity_moved", self, "_on_entity_moved")
	if error:
		emit_signal("msg", "Error on binding to entity_moved: " + str(error), Debug.WARN, self)
	
	
	error = connect("entity_used", self, "_on_entity_used")
	if error:
		emit_signal("msg", "Error on binding to entity_used: " + str(error), Debug.WARN, self)
	
	
	error = connect("damage_dealt", self, "_on_damage_dealt")
	if error:
		emit_signal("msg", "Error on binding to damage_dealt: " + str(error), Debug.WARN, self)
	
	
	error = connect("entity_picked_up", self, "_on_entity_picked_up")
	if error:
		emit_signal("msg", "Error on binding to entity_picked_up: " + str(error), Debug.WARN, self)
	
	
	error = connect("break_block", self, "_on_break_block")
	if error:
		emit_signal("msg", "Error on binding to break_block: " + str(error), Debug.WARN, self)
	
	
	error = connect("place_block", self, "_on_place_block")
	if error:
		emit_signal("msg", "Error on binding to place_block: " + str(error), Debug.WARN, self)
	
	
	error = connect("gui_loaded", self, "_on_gui_loaded")
	if error:
		emit_signal("msg", "Error on binding to gui_loaded: " + str(error), Debug.WARN, self)
	
	
	error = connect("gui_pushed", self, "_on_gui_pushed")
	if error:
		emit_signal("msg", "Error on binding to gui_pushed: " + str(error), Debug.WARN, self)


func _on_system_ready(system, obj):
	pass
	emit_signal("msg", "Event system_ready called. system: " + str(system) + ", obj: " + str(obj), Debug.TRACE, self)

func _on_entity_loaded(entity):
	emit_signal("msg", "Event entity_loaded called. entity: " + str(entity), Debug.TRACE, self)

func _on_request_entity_unload(entity):
	emit_signal("msg", "Event request_entity_unload called. entity: " + str(entity), Debug.TRACE, self)

func _on_app_ready():
	emit_signal("msg", "Event app_ready called", Debug.TRACE, self)

func _on_request_scene_load(scene):
	emit_signal("msg", "Event request_scene_load called. scene: " + str(scene), Debug.TRACE, self)

func _on_scene_loaded(scene):
	emit_signal("msg", "Event scene_loaded called. scene: " + str(scene), Debug.TRACE, self)

func _on_entity_moved(entity, dir):
	emit_signal("msg", "Event entity_moved called. entity: " + str(entity) + ", dir: " + str(dir), Debug.TRACE, self)

func _on_entity_used(entity, amount):
	emit_signal("msg", "Event entity_used called. entity: " + str(entity) + ", amount: " + str(amount), Debug.TRACE, self)

func _on_damage_dealt(target, shooter, weapon_data):
	emit_signal("msg", "Event damage_dealt called. target: " + str(target) + ", shooter: " + str(shooter) + ", weapon_data: " + str(weapon_data), Debug.TRACE, self)

func _on_damage_taken(target, shooter):
	emit_signal("msg", "Event damage_taken called. target: " + str(target) + ", shooter: " + str(shooter), Debug.TRACE, self)

func _on_entity_picked_up(picker, entity):
	emit_signal("msg", "Event entity_picked_up called. picker: " + str(picker) + ", entity: " + str(entity), Debug.TRACE, self)

func _on_break_block(block):
		emit_signal("msg", "Event break_block called. block: " + str(block), Debug.TRACE, self)

func _on_place_block(block):
	emit_signal("msg", "Event place_block called. block: " + str(block), Debug.TRACE, self)

func _on_gui_loaded(name, entity):
	emit_signal("msg", "Event gui_loaded called. name: " + str(name) + ", entity: " + str(entity), Debug.TRACE, self)

func _on_gui_pushed(name, init_param):
	emit_signal("msg", "Event gui_pushed called. name: " + str(name) + ", init_param: " + str(init_param), Debug.TRACE, self)
