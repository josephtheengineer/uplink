#warning-ignore:unused_class_variable
const meta := {
	script_name = "chunk.tools",
	description = """
		
	"""
}


# chunk.tools.get_chunk_sub ####################################################
const get_chunk_sub_meta := {
	func_name = "chunk.tools.get_chunk_sub",
	description = """
		
	""",
		}
static func get_chunk_sub(location: int, args := get_chunk_sub_meta) -> int: ###
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
# ^ chunk.tools.get_chunk_sub ##################################################


# chunk.tools.get_chunk ########################################################
const get_chunk_meta := {
	func_name = "chunk.tools.get_chunk",
	description = """
		
	""",
		}
static func get_chunk(location: Vector3, args := get_chunk_meta) -> Vector3: ###
	var x = get_chunk_sub(int(round(location.x))+8)
	var y = get_chunk_sub(int(round(location.y))+8)
	var z = get_chunk_sub(int(round(location.z))+8)
	
	return Vector3(x, y, z)
# ^ chunk.tools.get_chunk ######################################################


# chunk.tools.get_local_chunk_pos ##############################################
const get_local_chunk_pos_meta := {
	func_name = "chunk.tools.get_local_chunk_pos",
	description = """
		
	""",
		}
static func get_local_chunk_pos(location: Vector3, chunk_location: Vector3, args := get_local_chunk_pos_meta) -> Vector3:
	return location - chunk_location*16
# ^ chunk.tools.get_local_chunk_pos ##############################################
