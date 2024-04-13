extends Area3D


@export var speed : float = 50.0
@export var hit_effect : PackedScene

var direction:Vector3
var damage:float


func _physics_process(delta: float) -> void:
	#todo tween this if we feel we can see it moving in "steps"
	position += direction  * speed * delta


func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node3D) -> void:
	var hitparticle = hit_effect.instantiate()
	get_parent().add_child(hitparticle) #add to the parent since the projectile will queue free itself
	hitparticle.global_position = global_position
	#TODO change the color of the hitparticle depending if it hits an enemy or the ground/props (blood vs sparks)
	if body is Enemy:
		body.take_damage(damage)
	queue_free() #TODO Maybe not queue free if we let this be upgradeable to be piercing
