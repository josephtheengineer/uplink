#warning-ignore:unused_class_variable
const meta := {
	script_name = "client.player.move",
	description = """
		player utils
		move body, move head
		walk(player, delta)  fly(player, delta)  look(player, delta)
	"""
}

#var camera_angle := 0
const MOUSE_SENSITIVITY := 0.3

const FLY_SPEED := 80
const FLY_ACCEL := 4

const GRAVITY := -9.8 * 3
const MAX_SPEED := 10
const MAX_RUNNING_SPEED := 20
const ACCEL := 2
const DEACCEL := 6

const JUMP_HEIGHT := 15



static func walk(player: Entity, delta: float): ################################
	var camera = player.get_node("Player/Head/Camera")
	
	# get the rotation of the camera
	var aim = camera.get_global_transform().basis
	var direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
	
	direction = direction.normalized()
	
	player.components.position.velocity.y += GRAVITY * delta
	
	var temp_velocity = player.components.position.velocity
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
	
	player.components.position.velocity.x = temp_velocity.x
	player.components.position.velocity.z = temp_velocity.z
	
	# move
	var body: KinematicBody = player.get_node("Player")
	player.components.velocity = body.move_and_slide(player.components.position.velocity, Vector3(0, 1, 0))
	
	if Input.is_action_just_pressed("jump"):
		player.components.position.velocity.y = JUMP_HEIGHT



static func fly(player: Entity, delta: float): #########################################################
	var camera = player.get_node("Player/Head/Camera")
	
	# get the rotation of the camera
	var aim = camera.get_global_transform().basis
	var direction = Vector3()
	var velocity = Vector3()
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
	
	# where would the player go at max speed
	var target = direction * FLY_SPEED
	
	# calcuate a portion of the distance to go
	velocity = velocity.linear_interpolate(target, FLY_ACCEL * delta)
	
	# move
	var body: KinematicBody = player.get_node("Player")
	var _linear_velocity = body.move_and_slide(velocity)



static func look(player: Entity, event): #######################################
	var head = player.get_node("Player/Head")
	
	head.rotation_degrees.y += -event.relative.x * player.components.position.mouse_sensitivity
	
	var change = -event.relative.y * player.components.position.mouse_sensitivity
	#if change + camera_angle < 90 and change + camera_angle > -90:
	#	camera_angle += change
	head.rotation_degrees.x += change
