extends Control


@export var player_speed:UpgradeableStat
@export var projectile_damage:UpgradeableStat
@export var weapon_rate_of_fire:UpgradeableStat


func _ready() -> void:
	visible = false


func show_upgrades() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	visible = true


func upgrade_selected() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	visible = false


func _on_speed_pressed() -> void:
	player_speed.current_value += 1
	upgrade_selected()


func _on_damage_pressed() -> void:
	projectile_damage.current_value += 5
	upgrade_selected()


func _on_rof_pressed() -> void:
	weapon_rate_of_fire.current_value += 1
	upgrade_selected()
