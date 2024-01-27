extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 4.5
const mouseSensitivity = -0.2
var scream
var isColliding = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	scream = get_tree().root.get_node("World/NavigationRegion3D/GridMap/Scream")
	

func _input(event):
	if not isColliding:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(event.relative.x*mouseSensitivity))
			$CameraPivot.rotate_x(deg_to_rad(event.relative.y*mouseSensitivity))
		if Input.get_joy_axis(0, JOY_AXIS_RIGHT_X) < -0.2 or Input.get_joy_axis(0, JOY_AXIS_RIGHT_X) > 0.2:
			rotate_y(deg_to_rad( Input.get_joy_axis(0, 2) * -4.3 ))
		if Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y) < -0.2 or Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y) > 0.2:
			$CameraPivot.rotate_x(deg_to_rad( Input.get_joy_axis(0, 3) * -4.3 ))
		$CameraPivot.rotation.x = clamp($CameraPivot.rotation.x,deg_to_rad(-80),deg_to_rad(80))

func _physics_process(delta):
	# Add the gravity.
	isColliding = scream.playerInArea

	if not is_on_floor() and not isColliding:
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not isColliding:
		velocity.y = JUMP_VELOCITY


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "fwd", "bwd")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var speed
	if not isColliding:
		if Input.is_action_pressed("sprint"):
			speed = SPEED + 3
		else:
			speed = SPEED

	if not isColliding:
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
	if isColliding:
		velocity.z = 0
		velocity.x = 0

	if not isColliding:
		move_and_slide()
