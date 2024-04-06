extends Node3D


@export var projectileScene: PackedScene

var rate_of_fire:= 4.0 #TODO Can upgrade

@onready var rof_timer: Timer = $ROFTimer
@onready var muzzle: Marker3D = $Muzzle


func _process(delta: float) -> void:
	if Input.is_action_pressed("Shoot") && rof_timer.is_stopped():
		shoot()


func shoot() -> void:
	var shot = projectileScene.instantiate()
	add_child(shot)
	shot.global_position = muzzle.global_position
	shot.direction = muzzle.global_transform.basis.z
	shot.damage = 2.0 #TODO make damage a value on the gun so we can upgrade it (or store it in a resouce so it can just be read from the projectiles
	rof_timer.start(1.0/rate_of_fire)
