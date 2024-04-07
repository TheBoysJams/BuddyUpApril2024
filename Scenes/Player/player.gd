class_name Player extends CharacterBody3D


var speed = 5.0 #TODO Can upgrade
const JUMP_VELOCITY = 4.5 #TODO Can upgrade (maybe?)
var total_experience:= 0:
	set(exp_in):
		total_experience = exp_in
		if total_experience >= experiance_needed_next_level:
			experiance_needed_next_level *= 1.5 #TODO Replace this with a curve or a table 50,75,112,168,253,379,569
			upgrade_menu.show_upgrades()
var experiance_needed_next_level:= 50
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera_3d: Camera3D = $Camera3D
@onready var upgrade_menu: Control = $UpgradeMenu


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
		camera_3d.rotate_x(-event.relative.y * 0.005)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, -PI/2, PI/2)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("MoveLeft", "MoveRight", "MoveFoward", "MoveBackward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()


func experience_gained(exp:int) -> void:
	total_experience += exp
