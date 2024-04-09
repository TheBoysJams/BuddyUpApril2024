extends Node3D


@export var enemies: Array[EnemyInfo]

var wave:= 1
var enemies_in_wave: Array[PackedScene]

@onready var wave_generator: Timer = $WaveGenerator
@onready var spawn_point_container: Node = $SpawnPointContainer
var spawn_points


func _ready() -> void:
	generate_wave()
	spawn_points = spawn_point_container.get_children()
	print(spawn_points)


func generate_wave() -> void:
	var wave_value = wave * 10
	while wave_value > 0:
		#TODO get list of enemies we can afford (right now we only have 1 and it costs 1, but we will have more in the future)
		var enemy = enemies[randi_range(0,enemies.size() -1)]
		wave_value -= enemy.cost
		enemies_in_wave.append(enemy.enemy_scene)
	wave += 1


func _on_timer_timeout() -> void:
	if enemies_in_wave.size() > 0:
		var enemy = enemies_in_wave[0].instantiate()
		
		enemies_in_wave.remove_at(0)
		add_child(enemy)
		enemy.global_position = get_spawn_location()
		if randi_range(0,9) == 0:
			enemy.aberate()


func get_spawn_location() -> Vector3:
	return spawn_points[randi_range(0,spawn_points.size() -1)].global_position
