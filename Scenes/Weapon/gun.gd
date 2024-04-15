extends Node3D


@export var projectile_scene: PackedScene
@export var projectile_damage:UpgradeableStat
@export var weapon_rate_of_fire:UpgradeableStat


@onready var rof_timer: Timer = $ROFTimer
@onready var muzzle: Marker3D = $Muzzle


func _ready() -> void:
	projectile_damage.current_value = projectile_damage.starting_value
	weapon_rate_of_fire.current_value = weapon_rate_of_fire.starting_value

func _process(_delta: float) -> void:
	if Input.is_action_pressed("Shoot") && rof_timer.is_stopped():
		shoot()


func shoot() -> void:
	var shot = projectile_scene.instantiate()
	add_child(shot)
	shot.global_position = muzzle.global_position
	shot.direction = muzzle.global_transform.basis.z
	shot.damage = projectile_damage.current_value
	rof_timer.start(1.0/weapon_rate_of_fire.current_value)
