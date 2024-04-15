extends Control


var time: float = 0.0:
	set(time_in):
		time = time_in
		var minutes = time / 60
		var seconds = fmod(time, 60)
		var milliseconds = fmod(time, 1) * 100
		time_label.text = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
var kills:= 0:
	set(kills_in):
		kills = kills_in
		kills_label.text = "Kills: %d" %kills

@onready var kills_label: Label = $VBoxContainer/HBoxContainer/KillsLabel
@onready var health_bar: ProgressBar = $VBoxContainer/HealthBar
@onready var exp_bar: ProgressBar = $VBoxContainer/ExpBar
@onready var time_label: Label = $VBoxContainer/HBoxContainer/TimeLabel


func _process(delta: float) -> void:
	time += delta
