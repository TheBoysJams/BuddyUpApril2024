class_name Player extends CharacterBody3D


signal player_died(victory:bool)

@export var speed:UpgradeableStat

const JUMP_VELOCITY = 4.5 #TODO Can upgrade (maybe?)
var health:int= 100:
	set(hp_in):
		health = hp_in
		gui.health_bar.value = health #Works because we have 100 hp max
		if health <= 0:
			player_died.emit(false)
var total_experience:int= 0: #TODO rework all of the exp so each level can start at 0
	set(exp_in):
		total_experience = exp_in
		gui.exp_bar.value = (total_experience / float(experiance_needed_next_level)) * 100.0
		if total_experience >= experiance_needed_next_level:
			var expOverLevel = fmod(total_experience , experiance_needed_next_level)
			total_experience = int(expOverLevel)
			experiance_needed_next_level = int(experiance_needed_next_level * 1.5) #TODO Replace this with a curve or a table 50,75,112,168,253,379,569
			upgrade_menu.show_upgrades()
var experiance_needed_next_level:int= 50
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera_3d: Camera3D = $Camera3D
@onready var upgrade_menu: Control = $UpgradeMenu
@onready var gui: Control = $GUI


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	speed.current_value = speed.starting_value


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
	var input_dir := Input.get_vector("MoveLeft", "MoveRight", "MoveFoward", "MoveBackward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed.current_value
		velocity.z = direction.z * speed.current_value
	else:
		velocity.x = move_toward(velocity.x, 0, speed.current_value)
		velocity.z = move_toward(velocity.z, 0, speed.current_value)
	move_and_slide()


func experience_gained(exp_gained:int) -> void:
	total_experience += exp_gained
	gui.kills += 1


func take_damage(damage_in:int) -> void:
	#TODO add a screenflash or sometihng so the player knows they getting hit
	health -= damage_in
	print("Ouch - %d" %damage_in)


func _on_upgrade_menu_upgraded() -> void:
	gui.exp_bar.value = (total_experience / float(experiance_needed_next_level)) * 100.0
