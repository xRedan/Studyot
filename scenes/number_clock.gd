class_name NumberClock
extends Control

enum TimeType {HOUR, MINUTE, SECOND}

@export var font_color: Color

var stopwatch: Clock


func _ready() -> void:
	stopwatch = Clock.new()
	%Hours.add_theme_color_override("font_color", font_color)
	%Minutes.add_theme_color_override("font_color", font_color)
	%Seconds.add_theme_color_override("font_color", font_color)
	%Points.add_theme_color_override("font_color", font_color)
	%Points2.add_theme_color_override("font_color", font_color)
	stopwatch.time_changed.connect(_on_time_changed)
	stopwatch.time_changed.emit()


func _on_time_changed() -> void:
	%Hours.text = stopwatch.get_hour_str()
	%Minutes.text = stopwatch.get_minute_str()
	%Seconds.text = stopwatch.get_second_str()


func add_second(_sec: int) -> void:
	update_time(TimeType.SECOND, stopwatch.second + _sec)


func update_time(type: TimeType, value: int) -> void:
	match type:
		TimeType.HOUR:
			stopwatch.hour = value
		TimeType.MINUTE:
			stopwatch.minute = value
		TimeType.SECOND:
			stopwatch.second = value


func update_time_from_sec(tot_sec: int) -> void:
	var _sec = tot_sec % 60
	var _min = floori(tot_sec / 60.0) % 60
	var _ore = floori(tot_sec / 3600.0)
	update_time(TimeType.HOUR, _ore)
	update_time(TimeType.MINUTE, _min)
	update_time(TimeType.SECOND, _sec)
