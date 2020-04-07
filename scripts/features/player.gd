extends Node #KinematicBody
onready var ChunkSystem = get_node("/root/World/Systems/Chunk")
var Debug = load("res://scripts/features/debug.gd")

############################## public variables ###############################

var camera_angle = 0
var mouse_sensitivity = 0.3


var velocity = Vector3()
var direction = Vector3()
var move_direction


var build_range = 1000
#var building = 0
var highlighted_block = Vector3(0, 0, 0)
var highlighted_block_id = 8
var move_mode = "walk"
var action_mode = "nothing"


# fly variables
const FLY_SPEED = 40
const FLY_ACCEL = 4


# walk variables
var gravity = -9.8 * 3
const MAX_SPEED = 20
const MAX_RUNNING_SPEED = 30
const ACCEL = 2
const DEACCEL = 6


# jumping
var jump_height = 15




################################### signals ###################################


func _input(event): ###########################################################
	pass
#
#	if event.is_action_pressed("detach"):
#		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
#
#	if event.is_action_pressed("fly"):
#		if move_mode == "walk":
#			Debug.msg("Changing move_mode to fly...", "Info")
#			move_mode = "fly"
#			get_node("Capsule").disabled = true
#		else:
#			Debug.msg("Changing move_mode to walk...", "Info")
#			move_mode = "walk"
#			get_node("Capsule").disabled = false
#
#	if event.is_action_pressed("action"):
#		action(OS.get_window_size() / 2)
#
#	if event is InputEventScreenTouch:
#		action(event.position)
#
#	if event.is_action_pressed("burn"):
#		Debug.msg("Changing action_mode to burn...", "Info")
#		action_mode = "burn"
#		#Hud.switch_mode("burn")
#
#	if event.is_action_pressed("mine"):
#		Debug.msg("Changing action_mode to mine...", "Info")
#		action_mode = "mine"
#		#Hud.switch_mode("mine")
#
#	if event.is_action_pressed("build"):
#		Debug.msg("Changing action_mode to build...", "Info")
#		action_mode = "build"
#		#Hud.switch_mode("build")
#
#	if event.is_action_pressed("paint"):
#		Debug.msg("Changing action_mode to paint...", "Info")
#		action_mode = "paint"
#		#Hud.switch_mode("paint")




################################## functions ##################################


func move(position):
	move_direction = position

func action(id, position): ########################################################
	#Hud.msg("Modifing block in position: " + position, "Debug")
	
	action_mode = "build"
	
	if action_mode == "burn":
		pass
	elif action_mode == "mine":
		var normal = get_looking_at_normal(id, position)
		var block_location = get_looking_at(id, position)# - normal
		var location = ChunkSystem.get_chunk(block_location)
		
		if normal == Vector3(0, 0, -1):
			block_location += Vector3(0, 1, 0)
		elif normal == Vector3(0, 0, 1):
			block_location += Vector3(0, 1, -1)
		elif normal == Vector3(-1, 0, 0):
			block_location += Vector3(0, 1, 0)
		elif normal == Vector3(1, 0, 0):
			block_location += Vector3(-1, 1, 0)
		elif normal == Vector3(0, -1, 0):
			block_location += Vector3(0, 1, 0)
		
		var chunk_id = ChunkSystem.get_chunk_id(location)
		
		if chunk_id:
			Debug.msg("Breaking block: " + str(Vector3(floor(block_location.x), floor(block_location.y), floor(block_location.z))), "Info")
			
			var music_player = AudioStreamPlayer3D.new()
			var audio = load("res://sounds/game/block_break_generic_1_v2.ogg")
			audio.loop = false
			music_player.stream = audio
			music_player.connect("finished", self, "_stop_player", [music_player])
			add_child(music_player)
			music_player.play()
			
			ChunkSystem.break_block(id, Vector3(floor(block_location.x), floor(block_location.y), floor(block_location.z)))
			#ChunkSystem.compile()
		else:
			Debug.msg("Invalid chunk!", "Error")
	elif action_mode == "build":
		var normal = get_looking_at_normal(id, position)
		var block_location = get_looking_at(id, position) + normal
		Debug.msg("Normal is " + str(get_looking_at_normal(id, position)), "Debug")
		var location = ChunkSystem.get_chunk(block_location)
		
		if normal == Vector3(0, 0, -1):
			block_location += Vector3(0, 1, 0)
		elif normal == Vector3(0, 0, 1):
			block_location += Vector3(0, 1, -1)
		elif normal == Vector3(-1, 0, 0):
			block_location += Vector3(0, 1, 0)
		elif normal == Vector3(1, 0, 0):
			block_location += Vector3(-1, 1, 0)
		elif normal == Vector3(0, -1, 0):
			block_location += Vector3(0, 1, 0)
		
		var chunk_id = ChunkSystem.get_chunk_id(location)
		
		if chunk_id:
			Debug.msg("Placing block: " + str(Vector3(floor(block_location.x), floor(block_location.y), floor(block_location.z))), "Info")
			
			var music_player = AudioStreamPlayer3D.new()
			var audio = load("res://sounds/game/block_build_generic_1.ogg")
			audio.loop = false
			music_player.stream = audio
			music_player.connect("finished", self, "_stop_player", [music_player])
			add_child(music_player)
			music_player.play()
			
			ChunkSystem.place_block(chunk_id, 6, Vector3(floor(block_location.x), floor(block_location.y), floor(block_location.z)))
			#Chunk.compile()
		else:
			Debug.msg("Invalid chunk!", "Error")
	elif action_mode == "paint":
		pass


func _stop_player(player):
	player.stop()
	player.queue_free()


func get_orientation(id): #######################################################
	var camera = get_node("/root/World/" + str(id) + "/Player/Head/Camera")
	var looking_at = camera.project_ray_normal(OS.get_window_size() / 2)
	#Hud.msg(str(looking_at), "Trace")
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


func get_looking_at_normal(id, position): #########################################
	#var camera = $Head/Camera
	#var from = camera.project_ray_origin(event.position)
	#var to = from + camera.project_ray_normal(event.position) * 1000
	
	var camera = get_node("/root/World/" + str(id) + "/Player/Head/Camera")
	var space_state = camera.get_world().direct_space_state
	var build_origin = camera.project_ray_origin(position)
	var build_normal = camera.project_ray_normal(position) * 10000
	
	var result = space_state.intersect_ray(build_origin, build_normal, [self], 1)
	if result:
		#Debug.msg(str(result.position), "Debug")
		return result.normal
	else:
		return Vector3(0, 0, 0)


func get_looking_at(id, position): ################################################
	#var camera = $Head/Camera
	#var from = camera.project_ray_origin(event.position)
	#var to = from + camera.project_ray_normal(event.position) * 1000
	
	var camera = get_node("/root/World/" + str(id) + "/Player/Head/Camera")
	var space_state = camera.get_world().direct_space_state
	var build_origin = camera.project_ray_origin(position)
	var build_normal = camera.project_ray_normal(position) * 10000
	
	var result = space_state.intersect_ray(build_origin, build_normal, [self], 1)
	if result:
		#Hud.msg(str(result.position), "Debug")
		return result.position
	else:
		return Vector3(0, 0, 0)

func can_see_chunk(id, chunk): ################################################
	#var camera = $Head/Camera
	#var from = camera.project_ray_origin(event.position)
	#var to = from + camera.project_ray_normal(event.position) * 1000
	
	var camera = get_node("/root/World/" + str(id) + "/Player/Head/Camera")
	var space_state = camera.get_world().direct_space_state
	
	for x in range(OS.get_window_size().x):
		for y in range(OS.get_window_size().y):
			var build_origin = camera.project_ray_origin(Vector2(x, y))
			var build_normal = camera.project_ray_normal(Vector2(x, y)) * 10000
			
			var result = space_state.intersect_ray(build_origin, build_normal, [self], 1)
			#if result:
				#Hud.msg(str(result.position), "Debug")
				#return result.position
			#else:
				#return Vector3(0, 0, 0)


func walk(delta, id): #############################################################
	if !get_tree().get_root().has_node("/root/World/" + str(id) + "/Player/Head/Camera"):
		return false
	# reset the direction of the player
	direction = Vector3()
	
	#if Hud.analog_is_pressed:
		# Half the speed
	#	direction += Vector3(move_direction.x / 2, 0,  move_direction.y / 2)
	#else:
	# get the rotation of the camera
	var aim = get_node("/root/World/" + str(id) + "/Player/Head/Camera").get_global_transform().basis
	if Input.is_action_pressed("move_forward"): # or World.player_move_forward:
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
		
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
	
	direction = direction.normalized()
	
	velocity.y += gravity * delta
	
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	var speed
	if Input.is_action_pressed("move_sprint"):
		speed = MAX_RUNNING_SPEED
	else :
		speed = MAX_SPEED
	
	# where would the player go at max speed
	var target = direction * speed
	
	var acceleration
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCEL
	else:
		acceleration = DEACCEL
	
	# calcuate a portion of the distance to go
	temp_velocity = temp_velocity.linear_interpolate(target, acceleration * delta)
	
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	
	# move
	get_node("/root/World/" + str(id) + "/Player").move_and_slide(velocity, Vector3(0, 1, 0))
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_height


func fly(delta, id): ##############################################################
	# reset the direction of  the player
	direction = Vector3()
	
	# get the rotation of the camera
	var aim = get_node("/root/World/" + str(id) + "/Player/Head/Camera").get_global_transform().basis
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
		
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
		
	direction = direction.normalized()
	
	# where would the player go at max speed
	var target = direction * FLY_SPEED
	
	# calcuate a portion of the distance to go
	velocity = velocity.linear_interpolate(target, FLY_ACCEL * delta)
	
	# move
	get_node("/root/World/" + str(id) + "/Player").move_and_slide(velocity)