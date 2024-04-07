class_name UpgradeableStat extends Resource


@export var starting_value: float
@export var min_value:float #might be used for debufs?
@export var max_value:float

var current_value:float:
	set(value_in):
		current_value = clampf(value_in,min_value,max_value)
