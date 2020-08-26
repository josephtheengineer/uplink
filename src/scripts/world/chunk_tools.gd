#warning-ignore:unused_class_variable
const script_name := "chunk_tools"
onready var Debug := preload("res://src/scripts/debug/debug.gd").new()

func get_chunk_sub(location: int): #############################################
	var x = 0
	if location == 0:
		return 0
	elif location > 0:
		while !(location >= x and location < x*16):
			x += 1
	else:
		while !(location <= x and location > x*16):
			x -= 1
	return x - 1


func get_chunk(location: Vector3): #############################################
	var x = get_chunk_sub(int(round(location.x)))
	var y = get_chunk_sub(int(round(location.y)))
	var z = get_chunk_sub(int(round(location.z)))
	
	return Vector3(x, y, z)

func get_chunk_id(location: Vector3): ##########################################
	Core.emit_signal("msg", "get_chunk_id is not implemented yet! arg: " + str(location), Debug.WARN, self)
#	var entities = Entity.get_entities_with("chunk")
#	for id in entities:
#		if Entity.get_component(id, "chunk.position") == location:
#			return id
#	return false
