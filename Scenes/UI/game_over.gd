extends Control


@onready var game_over_label: Label = $VBoxContainer/GameOverLabel


func _ready() -> void:
	visible = false


func show_game_over(win:bool) -> void:
	get_tree().paused = true
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED


func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(load("res://Scenes/Level/level.tscn"))


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(load("res://Scenes/Level/main_menu.tscn"))


func _on_exit_game_button_pressed() -> void:
	get_tree().quit()
