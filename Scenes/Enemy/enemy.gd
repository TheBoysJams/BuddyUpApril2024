class_name Enemy extends CharacterBody3D
#TODO Make a better hitbox then $CollisionShape3D and have it move with the animation (so we can do headshots ect)

signal enemy_death(exp:int)
signal damged_player(dmg:int)

@export var health: int = 10:
	set(hp_in):
		health = hp_in
		if health <= 0:
			set_collision_layer_value(2,false)
			set_physics_process(false)
			enemy_death.emit(exp_value)
			playback.travel("Death")
@export var speed: float = 4.5
@export var exp_value: int = 10
@export var damage: int = 10
@export var attack_range: float = 1.5

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var player

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]


func _ready() -> void:
	enemy_death.connect(player.experience_gained)
	set_physics_process(false)
	call_deferred("_wait_for_nav_agent")


#This is a hack/fix for a nav error that happens, so now we just wait for a frame or two so the nav server is ready
func _wait_for_nav_agent() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	navigation_agent_3d.target_position = player.global_position
	var next_position = navigation_agent_3d.get_next_path_position()
	if not is_on_floor(): 
		velocity.y -= gravity * delta
	var direction = global_position.direction_to(next_position)
	var distance = global_position.distance_to(player.global_position)
	if distance < attack_range:
		playback.travel("Punch")
	if direction:
		look_at_target(direction)
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()


func attack() -> void:
	#recheck distance incase player has moved away
	var distance = global_position.distance_to(player.global_position)
	if distance < attack_range:
		player.take_damage(damage)

#stops the enemy from rotating on the y axis
func look_at_target(direction: Vector3) -> void:
	var adjusted_direction = direction
	adjusted_direction.y = 0
	look_at(global_position + adjusted_direction, Vector3.UP,true)


func take_damage(damage_received : int) -> void:
	#TODO things like play hit sounds/display some hit particles
	health -= damage_received


func aberate() -> void:
	scale = Vector3(1.5,1.5,1.5)
	health *= 1.5
