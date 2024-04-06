extends Area3D


@export var speed : float = 50.0

var direction:Vector3
var damage:float


func _physics_process(delta: float) -> void:
	#todo tween this if we feel we can see it moving in "steps"
	position += direction  * speed * delta


func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node3D) -> void:
	#TODO particles/hitmarkers
	if body is Enemy:
		body.take_damage(damage)
	queue_free() #TODO Maybe not queue free if we let this be upgradeable to be piercing
