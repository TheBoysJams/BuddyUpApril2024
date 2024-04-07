extends Node3D


@export var enemy_scene: PackedScene


func _on_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	

