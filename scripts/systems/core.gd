extends Node

onready var Client = get_node("/root/World/Systems/Client")
onready var Server = get_node("/root/World/Systems/Server")

signal system_ready(system, obj)
signal entity_loaded(entity)
signal request_entity_unload(entity)
signal app_ready()
signal request_scene_load(scene)
signal scene_loaded(scene)
signal entity_moved(entity, dir)
signal entity_used(entity, amount)
signal msg(message, level)
signal damage_dealt(target, shooter, weapon_data)
signal damage_taken(target, shooter)
signal entity_picked_up(picker, entity)
signal break_block(block)
signal place_block(block)

signal gui_loaded(name, entity)
signal gui_pushed(name, init_param)

func _ready():
	connect("system_ready", self, "_on_system_ready")
	connect("entity_loaded", self, "_on_entity_loaded")
	connect("request_entity_unload", self, "_on_request_entity_unload")
	connect("app_ready", self, "_on_app_ready")
	connect("request_scene_load", self, "_on_request_scene_load")
	connect("scene_loaded", self, "_on_scene_loaded")
	connect("entity_moved", self, "_on_entity_moved")
	connect("entity_used", self, "_on_entity_used")
	connect("damage_dealt", self, "_on_damage_dealt")
	connect("entity_picked_up", self, "_on_entity_picked_up")
	connect("break_block", self, "_on_break_block")
	connect("place_block", self, "_on_place_block")
	connect("gui_loaded", self, "_on_gui_loaded")
	connect("gui_pushed", self, "_on_gui_pushed")

func _on_system_ready(system, obj):
	emit_signal("msg", "Event system_ready called", "Trace")

func _on_entity_loaded(entity):
	emit_signal("msg", "Event entity_loaded called", "Trace")

func _on_request_entity_unload(entity):
	emit_signal("msg", "Event request_entity_unload called", "Trace")

func _on_app_ready():
	emit_signal("msg", "Event app_ready called", "Trace")

func _on_request_scene_load(scene):
	emit_signal("msg", "Event request_scene_load called", "Trace")

func _on_scene_loaded(scene):
	emit_signal("msg", "Event scene_loaded called", "Trace")

func _on_entity_moved(entity, dir):
	emit_signal("msg", "Event entity_moved called", "Trace")

func _on_entity_used(entity, amount):
	emit_signal("msg", "Event entity_used called", "Trace")

func _on_damage_dealt(target, shooter, weapon_data):
	emit_signal("msg", "Event damage_dealt called", "Trace")

func _on_damage_taken(target, shooter):
	emit_signal("msg", "Event damage_taken called", "Trace")

func _on_entity_picked_up(picker, entity):
	emit_signal("msg", "Event entity_picked_up called", "Trace")

func _on_break_block(block):
		emit_signal("msg", "Event break_block called", "Trace")

func _on_place_block(block):
	emit_signal("msg", "Event place_block called", "Trace")

func _on_gui_loaded(name, entity):
	emit_signal("msg", "Event gui_loaded called", "Trace")

func _on_gui_pushed(name, init_param):
	emit_signal("msg", "Event gui_pushed called", "Trace")