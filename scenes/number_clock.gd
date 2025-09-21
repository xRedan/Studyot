## TODO:
## Da rivedere i nomi delle variabili
## e delle classi.

class_name NumberClock
extends Control

class Clock:
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


@export var font_color: Color

enum TimeType {HOUR, MINUTE, SECOND}
var clock_values: Clock = Clock.new(0, 0, 0)
var selected_timer: TimeType = TimeType.SECOND

func update_time(type: TimeType, value: int) -> void:
	match type:
		TimeType.HOUR:
			clock_values.hour = value
		TimeType.MINUTE:
			clock_values.minute = value
		TimeType.SECOND:
			clock_values.second = value

func update_time_sec(tot_sec: int) -> void:
	var _sec = tot_sec % 60
	var _min = floori(tot_sec / 60.0) % 60
	var _ore = floori(tot_sec / 3600.0)
	update_time(TimeType.HOUR, _ore)
	update_time(TimeType.MINUTE, _min)
	update_time(TimeType.SECOND, _sec)

func add_time_sec(_sec: int) -> void:
	update_time(TimeType.SECOND, clock_values.second + _sec)


func _ready() -> void:
	%Hours.add_theme_color_override("font_color", font_color)
	%Minutes.add_theme_color_override("font_color", font_color)
	%Seconds.add_theme_color_override("font_color", font_color)
	%Points.add_theme_color_override("font_color", font_color)
	%Points2.add_theme_color_override("font_color", font_color)
	%Hours.gui_input.connect(_on_hours_input_entered)
	%Minutes.gui_input.connect(_on_minutes_input_entered)
	%Seconds.gui_input.connect(_on_seconds_input_entered)
	clock_values.time_changed.connect(_on_time_changed)
	clock_values.time_changed.emit()

func _on_hours_input_entered(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			print("pressed")
			selected_timer = TimeType.HOUR

func _on_minutes_input_entered(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			print("pressed")
			selected_timer = TimeType.MINUTE

func _on_seconds_input_entered(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			print("pressed")
			selected_timer = TimeType.SECOND

func _on_time_changed() -> void:
	%Hours.text = clock_values.get_hour_str()
	%Minutes.text = clock_values.get_minute_str()
	%Seconds.text = clock_values.get_second_str()
