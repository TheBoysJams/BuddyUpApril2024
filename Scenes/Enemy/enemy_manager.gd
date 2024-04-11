extends Node3D


@export var enemies: Array[EnemyInfo]

var wave:= 1
var enemies_in_wave: Array[PackedScene]
var spawn_points

@onready var wave_generator: Timer = $WaveGenerator
@onready var spawn_point_container: Node = $SpawnPointContainer
@onready var player = get_tree().get_first_node_in_group("Player");


func _ready() -> void:
	generate_wave()
	spawn_points = spawn_point_container.get_children()


func generate_wave() -> void:
	print("Wave %d generation" % wave)
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
		enemy.player = player
		enemies_in_wave.remove_at(0)
		add_child(enemy)
		enemy.global_position = get_spawn_location()
		if randi_range(0,9) == 0:
			enemy.aberate()
	else:
		var AllEnemiesDead = get_tree().get_first_node_in_group("Enemy") == null
		if AllEnemiesDead:
			wave_generator.start()
			generate_wave()


func get_spawn_location() -> Vector3:
	return spawn_points[randi_range(0,spawn_points.size() -1)].global_position
