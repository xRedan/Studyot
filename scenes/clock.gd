class_name Clock
extends RefCounted

signal time_changed

signal _sec_changed(sec: int)
signal _min_changed(min: int)
signal _hour_changed(hour: int)

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
	_sec_changed.connect(_on_sec_changed)
	_min_changed.connect(_on_min_changed)
	_hour_changed.connect(_on_hour_changed)

func get_hour_str() -> String:
	return "%02d" % hour

func get_minute_str() -> String:
	return "%02d" % minute

func get_second_str() -> String:
	return "%02d" % second

func get_clock_to_str() -> String:
	return get_hour_str() + ":" + get_minute_str() + ":" + get_second_str()

func get_clock_to_sec() -> int:
	return (hour * 3600) + (minute * 60) + second

func _set_hour(value: int) -> void:
	_hour_changed.emit(value)
	hour = wrap(value, 0, MAX_HOURS)
	time_changed.emit()

func _set_minute(value: int) -> void:
	_min_changed.emit(value)
	minute = wrap(value, 0, MAX_MINUTES)
	time_changed.emit()

func _set_second(value: int) -> void:
	_sec_changed.emit(value)
	second = wrap(value, 0, MAX_SECONDS)
	time_changed.emit()

func _on_sec_changed(_sec: int) -> void:
	if _sec >= MAX_SECONDS:
		minute += 1

func _on_min_changed(_min: int) -> void:
	if _min >= MAX_MINUTES:
		hour += 1

func _on_hour_changed(_hour: int) -> void:
	if _hour >= MAX_HOURS:
		hour = 0
