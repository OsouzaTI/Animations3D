extends CharacterBody3D

@onready var animation_tree = $AnimationTree
@onready var visuals = $RootNode

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed('ATTACK'):
		animation_tree.set("parameters/Transition/transition_request", "attack");

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("LEFT", "RIGHT", "FORWARD", "BACKWARD")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		visuals.look_at(position - direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	animation_tree.set("parameters/Movement/MoveBlend2D/blend_position", Vector2(velocity.x, velocity.z))
	move_and_slide()
