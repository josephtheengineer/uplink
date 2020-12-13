#warning-ignore:unused_class_variable
const meta := {
	script_name = "world.chunk_tools",
	description = """
		
	"""
}

static func get_chunk_sub(location: int): #############################################
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


static func get_chunk(location: Vector3): #############################################
	var x = get_chunk_sub(int(round(location.x))+8)
	var y = get_chunk_sub(int(round(location.y))+8)
	var z = get_chunk_sub(int(round(location.z))+8)
	
	return Vector3(x, y, z)

static func get_local_chunk_pos(location: Vector3, chunk_location: Vector3):
	return location - chunk_location*16
