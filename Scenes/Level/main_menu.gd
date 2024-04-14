extends Control


@export var levelToLoad: PackedScene


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(levelToLoad)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
