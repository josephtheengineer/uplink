extends Node
# Main hub for infomation flow in Uplink
# This is the only signton in the game, it handles 
# public signals and Client and Server reference

#warning-ignore:unused_class_variable
const script_name := "core"

################################################################################

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

################################################################################

#warning-ignore:unused_class_variable
onready var Client: ClientSystem = get_node("/root/World/Systems/Client")
#warning-ignore:unused_class_variable
onready var Server: ServerSystem = get_node("/root/World/Systems/Server")

onready var Debug := preload("res://src/scripts/debug/debug.gd").new()

var signals = [ "system_ready", "entity_loaded", "request_entity_unload", 
		"app_ready", "request_scene_load", "scene_loaded", 
		"entity_moved", "entity_used", "damage_dealt", 
		"entity_picked_up", "break_block", "place_block", "gui_loaded", 
		"gui_pushed" ]

################################################################################

func _ready(): #################################################################
	for app_signal in signals:
		var error = connect(app_signal, self, "_on_" + app_signal)
		if error:
			emit_signal("msg", "Error on binding to " + app_signal 
				+ ": " + str(error), Debug.WARN, self)


func _on_system_ready(system, obj): ############################################
	emit_signal("msg", "Event system_ready called. system: " + str(system) 
		+ ", obj: " + str(obj), Debug.TRACE, self)


func _on_entity_loaded(entity): ################################################
	emit_signal("msg", "Event entity_loaded called. entity: " 
		+ str(entity), Debug.TRACE, self)


func _on_request_entity_unload(entity): ########################################
	emit_signal("msg", "Event request_entity_unload called. entity: " 
		+ str(entity), Debug.TRACE, self)


func _on_app_ready(): ##########################################################
	emit_signal("msg", "Event app_ready called", Debug.TRACE, self)


func _on_request_scene_load(scene): ############################################
	emit_signal("msg", "Event request_scene_load called. scene: " 
		+ str(scene), Debug.TRACE, self)


func _on_scene_loaded(scene): ##################################################
	emit_signal("msg", "Event scene_loaded called. scene: " + str(scene), 
		Debug.TRACE, self)


func _on_entity_moved(entity, dir): ############################################
	emit_signal("msg", "Event entity_moved called. entity: " + str(entity) 
		+ ", dir: " + str(dir), Debug.TRACE, self)


func _on_entity_used(entity, amount): ##########################################
	emit_signal("msg", "Event entity_used called. entity: " + str(entity) 
		+ ", amount: " + str(amount), Debug.TRACE, self)


func _on_damage_dealt(target, shooter, weapon_data): ###########################
	emit_signal("msg", "Event damage_dealt called. target: " + str(target) 
		+ ", shooter: " + str(shooter) + ", weapon_data: " 
		+ str(weapon_data), Debug.TRACE, self)


func _on_damage_taken(target, shooter): ########################################
	emit_signal("msg", "Event damage_taken called. target: " + str(target) 
		+ ", shooter: " + str(shooter), Debug.TRACE, self)


func _on_entity_picked_up(picker, entity): #####################################
	emit_signal("msg", "Event entity_picked_up called. picker: " 
		+ str(picker) + ", entity: " + str(entity), Debug.TRACE, self)


func _on_break_block(block): ###################################################
	emit_signal("msg", "Event break_block called. block: " 
		+ str(block), Debug.TRACE, self)


func _on_place_block(block): ###################################################
	emit_signal("msg", "Event place_block called. block: " + str(block), 
		Debug.TRACE, self)


func _on_gui_loaded(name, entity): #############################################
	emit_signal("msg", "Event gui_loaded called. name: " + str(name) 
		+ ", entity: " + str(entity), Debug.TRACE, self)


func _on_gui_pushed(name, init_param): #########################################
	emit_signal("msg", "Event gui_pushed called. name: " + str(name) 
		+ ", init_param: " + str(init_param), Debug.TRACE, self)
