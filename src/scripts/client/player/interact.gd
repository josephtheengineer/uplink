#warning-ignore:unused_class_variable
const meta := {
	script_name = "client.player.interact",
	description = """
		player interaction functions
		action(player, action_position)
		get_orientation()  get_looking_at()
	"""
}

static func update_looking_at_block(Player: Entity): ###########################
#	var normal = Core.scripts.client.player.interact.get_looking_at_normal(player, OS.get_window_size() / 2)
#	var block_location = Core.scripts.client.player.interact.get_looking_at(player, OS.get_window_size() / 2)# - normal
#
#	if normal == Vector3(0, 0, -1):
#		block_location += Vector3(0, 1, 0)
#	elif normal == Vector3(0, 0, 1):
#		block_location += Vector3(0, 1, -1)
#	elif normal == Vector3(-1, 0, 0):
#		block_location += Vector3(0, 1, 0)
#	elif normal == Vector3(1, 0, 0):
#		block_location += Vector3(-1, 1, 0)
#	elif normal == Vector3(0, -1, 0):
#		block_location += Vector3(0, 1, 0)
#
#	Core.get_parent().get_node(stats + "LookingXYZ").text = "Looking at: XYZ: " + str(block_location.round())
#
#	var location = Core.scripts.chunk.tools.get_chunk(block_location)
	
	Player.components.cursor_pos = OS.get_window_size() / 2
	Player.components.looking_at_block = get_looking_at(Player, Player.components.cursor_pos)
	Player.components.looking_at_chunk = Core.scripts.chunk.tools.get_chunk(Player.components.looking_at_block)

static func action(player: Entity, position: Vector2): ##########################
	Core.emit_signal("msg", "Modifing block in position: " + str(position), Core.DEBUG, meta)
	
	if player.components.action_mode == "burn":
		pass
	elif player.components.action_mode == "mine":
		Core.emit_signal("system_process_start", "client.break_block")
	elif player.components.action_mode == "build":
		Core.emit_signal("system_process_start", "client.place_block")
	elif player.components.action_mode == "paint":
		pass

static func get_orientation(player: Entity): ###################################
	var camera = player.get_node("Player/Head/Camera")
	var looking_at = camera.project_ray_normal(OS.get_window_size() / 2)
	
	if looking_at.x > 0.5:
		return "north"
	elif looking_at.x < -0.5:
		return "south"
	elif looking_at.y > 0.5:
		return "up"
	elif looking_at.y < -0.5:
		return "down"
	elif looking_at.z > 0.5:
		return "east"
	elif looking_at.z < -0.5:
		return "west"
	else:
		return "invaild"


static func get_looking_at_normal(player: Entity, position: Vector2): ##########
	var camera = player.get_node("Player/Head/Camera")
	var space_state = camera.get_world().direct_space_state
	var build_origin = camera.project_ray_origin(position)
	var build_normal = build_origin + camera.project_ray_normal(position) * 10000
	
	var result = space_state.intersect_ray(build_origin, build_normal, [], 1)
	if result:
		return result.normal
	else:
		return Vector3(0, 0, 0)


static func get_looking_at(player: Entity, position: Vector2): #################
	var camera = player.get_node("Player/Head/Camera")
	var space_state = camera.get_world().direct_space_state
	var build_origin = camera.project_ray_origin(position)
	var build_normal = build_origin + camera.project_ray_normal(position) * 10000
	
	var result = space_state.intersect_ray(build_origin, build_normal, [], 1)
	
	if result:
		var line = ImmediateGeometry.new()
		if Core.has_node("DebugLookingAtLine"):
			Core.get_node("DebugLookingAtLine").free()
		line.begin(Mesh.PRIMITIVE_LINES)
		line.set_color(Color(1, 0, 0))
		line.add_vertex(player.get_node("Player").translation)
		line.add_vertex(result.position)
		line.end()
		line.name = "DebugLookingAtLine"
		Core.add_child(line)
		
		var block_location = result.position
		var normal = result.normal
		
		if player.components.action_mode == "build":
			block_location += apply_normal_positive(normal)
		else:
			block_location += apply_normal_negitive(normal)
		block_location = Vector3(floor(block_location.x), floor(block_location.y), floor(block_location.z))
		
		line = ImmediateGeometry.new()
		if Core.has_node("BlockHighlight"):
			Core.get_node("BlockHighlight").free()
		line.begin(Mesh.PRIMITIVE_LINES)
		line.set_color(Color(1, 0, 0))
		for point in Core.scripts.chunk.geometry.BOX_HIGHLIGHT:
			line.add_vertex(point + block_location + Vector3(0, -1, 0))
		line.end()
		line.name = "BlockHighlight"
		Core.add_child(line)
		
		return block_location
	else:
		return Vector3(0, 0, 0)

static func apply_normal_negitive_broken(normal: Vector3):
	var location = Vector3()
	if normal == Vector3(0, 0, -1): # West side of block
		location += Vector3(0, 0, 0)
		
	elif normal == Vector3(0, 0, 1): # East side of block
		location += Vector3(0, 0, -1)
		
	elif normal == Vector3(-1, 0, 0): 
		location += Vector3(0, 0, 0)
		
	elif normal == Vector3(1, 0, 0): 
		location += Vector3(-1, 0, 0)
		
	elif normal == Vector3(0, -1, 0): # Bottom side of block
		location += Vector3(0, 0, 0)
		
	elif normal == Vector3(0, 1, 0): # Top side of block
		location += Vector3(0, -1, 0)
		
	return location

static func apply_normal_negitive(normal: Vector3):
	var location = Vector3()
	if normal == Vector3(0, 0, -1):
		location += Vector3(0, 1, 0)
		
	elif normal == Vector3(0, 0, 1):
		location += Vector3(0, 1, -1)
		
	elif normal == Vector3(-1, 0, 0):
		location += Vector3(0, 1, 0)
		
	elif normal == Vector3(1, 0, 0):
		location += Vector3(-1, 1, 0)
		
	elif normal == Vector3(0, -1, 0):
		location += Vector3(0, 1, 0)
		
	return location

static func apply_normal_positive(normal: Vector3):
	var location = Vector3()
	if normal == Vector3(0, 0, -1):
		location += Vector3(0, 1, 0) + Vector3(0, 0, -1)
		
	elif normal == Vector3(0, 0, 1):
		location += Vector3(0, 1, -1) + Vector3(0, 0, 1)
		
	elif normal == Vector3(-1, 0, 0):
		location += Vector3(0, 1, 0) + Vector3(-1, 0, 0)
		
	elif normal == Vector3(1, 0, 0):
		location += Vector3(-1, 1, 0) + Vector3(1, 0, 0)
		
	elif normal == Vector3(0, -1, 0):
		location += Vector3(0, 1, 0) + Vector3(0, 1, 0)
	
	elif normal == Vector3(0, 1, 0): # Top side of block
		location += Vector3(0, 1, 0)
		
	return location
