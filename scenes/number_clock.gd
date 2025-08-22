class_name NumberClock
extends Control

class Clock:
	signal time_changed
	
	const MAX_HOURS = 100
	const MAX_MINUTES = 60
	const MAX_SECONDS = 60
	
	var hour: int : 	set = _set_hour
	var minute: int : set = _set_minute
	var second: int : set = _set_second
	
	func _init(_hour: int = 0, _minute: int = 0, _second: int = 0) -> void:
		hour = _hour
		minute = _minute
		second = _second
	
	func get_hour_str() -> String:
		return "%02d" % hour
	
	func get_minute_str() -> String:
		return "%02d" % minute
	
	func get_second_str() -> String:
		return "%02d" % second

	func get_clock() -> String:
		return get_hour_str() + ":" + get_minute_str() + ":" + get_second_str()
	
	func _set_hour(value) -> void:
		hour = wrap(value, 0, MAX_HOURS)
		time_changed.emit()
	
	func _set_minute(value) -> void:
		minute = wrap(value, 0, MAX_MINUTES)
		time_changed.emit()
	
	func _set_second(value) -> void:
		second = wrap(value, 0, MAX_SECONDS)
		time_changed.emit()

var clock_values: Clock = Clock.new(60, 12, 30)

func update_time(type: String, value: int) -> void:
	match type:
		"hour":
			clock_values.hour = value
		"minute":
			clock_values.minute = value
		"second":
			clock_values.second = value

func _ready() -> void:
	clock_values.time_changed.connect(_on_time_changed)
	clock_values.time_changed.emit()
	
func _on_time_changed() -> void:
	%Hours.text = clock_values.get_hour_str()
	%Minutes.text = clock_values.get_minute_str()
	%Seconds.text = clock_values.get_second_str()
