class_name NumberClock
extends Control

const MAX_HOURS = 99
const MAX_SECONDS = 60

enum TimeType {SECONDS, MINUTE, HOURS}

@export var selected_type: TimeType = TimeType.SECONDS

var clock_value: int = 0:
	get:
		return clock_value
	set(value):
		clock_value = _roundover(value)
		_set_number_label()

@onready var number_1: Label = $HBoxContainer/Number1
@onready var number_2: Label = $HBoxContainer/Number2


func _ready() -> void:
	number_1.text = str(clock_value)
	number_2.text = str(clock_value)

func set_clock_value(value: int) -> void:
	match selected_type:
		TimeType.SECONDS, TimeType.MINUTE:
			clock_value = _roundover(value)
		TimeType.HOURS:
			clock_value = _roundover(value)

func add(value: int) -> void:
	match selected_type:
		TimeType.SECONDS, TimeType.MINUTE:
			clock_value += value
		TimeType.HOURS:
			clock_value += value


func sub(value: int) -> void:
	match selected_type:
		TimeType.SECONDS, TimeType.MINUTE:
			clock_value -= value
		TimeType.HOURS:
			clock_value -= value



func _roundover(value: int) -> int:
	var roundover = 0;
	match selected_type:
		TimeType.SECONDS, TimeType.MINUTE:
			if value < 0:
				roundover = MAX_SECONDS
			elif value > 0 and value < MAX_SECONDS:
				roundover = value
		TimeType.HOURS:
			if value < 0:
				roundover = MAX_HOURS
			elif value > 0 and value < MAX_HOURS:
				roundover = value
	return roundover


func _set_number_label() -> void:
	var tmp: String = str(clock_value)
	print(tmp.length())
	if tmp.length() > 1:
		number_1.text = tmp[1]
		number_2.text = tmp[0]
	else:
		number_1.text = tmp[0]
		
