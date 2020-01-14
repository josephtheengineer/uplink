extends Node

onready var Client = get_node("/root/World/Systems/Client")
onready var Server = get_node("/root/World/Systems/Server")

signal system_ready(system)
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

signal gui_loaded(name, entity)
signal gui_pushed(name, init_param)
