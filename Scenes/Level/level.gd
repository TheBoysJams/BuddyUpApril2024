extends Node3D


func _unhandled_input(_event: InputEvent) -> void:
	#TODO change this to opening up a menu
	if Input.is_action_just_pressed("Escape"):
		get_tree().quit()
