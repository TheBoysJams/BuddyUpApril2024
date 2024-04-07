extends Control


func _ready() -> void:
	visible = false


func show_upgrades() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	visible = true


func upgrade_selected() -> void:
	#TODO pass in the selected upgrade and tell the play/some system about the upgrade 
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	visible = false
