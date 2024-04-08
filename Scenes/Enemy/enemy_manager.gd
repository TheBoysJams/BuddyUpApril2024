extends Node3D


@export var enemies: Array[EnemyInfo]

var wave:= 1
var enemies_in_wave: Array[PackedScene]


@onready var wave_generator: Timer = $WaveGenerator


func _ready() -> void:
	generate_wave()


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
		if randi_range(0,9) == 0:
			enemy.aberate()
