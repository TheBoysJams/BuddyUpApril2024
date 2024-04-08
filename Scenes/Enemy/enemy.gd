class_name Enemy extends CharacterBody3D
#TODO Make a better hitbox then $CollisionShape3D and have it move with the animation (so we can do headshots ect)

signal enemy_death(exp:int)
signal damged_player(dmg:float)

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var health: float = 10.0:
	set(hp_in):
		health = hp_in
		if health <= 0:
			enemy_death.emit(exp_value)
			queue_free() #this would be done at the end of the death animation
var exp_value: int = 10
var damage: float = 10.0
var speed: float = 4.5
var attack_range: float = 1.5

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var player = get_tree().get_first_node_in_group("Player");


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
	#if distance is less then the attack range (TODO) then we want to travel to the attack animation, said animation will have a attack function call at the correct spot
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


func look_at_target(direction: Vector3) -> void:
	var adjusted_direction = direction
	adjusted_direction.y = 0
	look_at(global_position + adjusted_direction, Vector3.UP,true)


func take_damage(damage_received : float) -> void:
	#do things like play hit sounds/display some hit particles
	health -= damage_received
	
	
func aberate() -> void:
	scale = Vector3(2,2,2)
	#we should also make this one have more hp/damage/exp
