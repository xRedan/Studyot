class_name Calendar
extends Control

signal date_confirmed
signal date_cancelled

const DAYS: Array[int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

var selected_date: Dictionary = {}

var calendar_grid: GridContainer
var title_label: Label
var confirm_button: Button
var day_buttons: Array[Button] = []

var current_year: int
var current_month: int
var current_day: int


func _init(_day: int = 20, _month: int = 10, _year: int = 2000) -> void:
	current_day = _day
	current_month = _month
	current_year = _year


func _ready() -> void:
	setup_calendar()


func setup_calendar() -> void:
	var main_container := VBoxContainer.new()
	main_container.name = "test"
	
	self.custom_minimum_size = Vector2(300, 300)
	
	add_child(main_container)
	
	create_header(main_container)
	
	create_calendar_grid(main_container)
	
	create_action_button(main_container)
	
	create_calendar()
	
	print_days(get_days_in_moth(current_month, current_year), get_first_weekday(current_month, current_year))
	
	print("cms" + str(main_container.get_minimum_size()))


func create_header(parent: VBoxContainer) -> void:
	var header = HBoxContainer.new()
	parent.add_child(header)
	
	var prev_but: Button = Button.new()
	prev_but.text = "<-"
	var next_but: Button = Button.new()
	next_but.text = "->"
	title_label = Label.new()
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	prev_but.pressed.connect(_on_prev_but_pressed)
	next_but.pressed.connect(_on_next_but_pressed)
	
	header.add_child(prev_but)
	header.add_child(title_label)
	header.add_child(next_but)


func create_calendar_grid(parent: VBoxContainer) -> void:
	calendar_grid = GridContainer.new()
	calendar_grid.columns = 7
	parent.add_child(calendar_grid)


func create_action_button(parent: VBoxContainer) -> void:
	var action_container: HBoxContainer = HBoxContainer.new()
	action_container.alignment = BoxContainer.ALIGNMENT_CENTER
	parent.add_child(action_container)
	
	confirm_button = Button.new()
	confirm_button.text = "Confirm"
	confirm_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	confirm_button.pressed.connect(_on_confirm_button_pressed)
	
	var spacer: HSeparator = HSeparator.new()
	
	var cancel_button: Button = Button.new()
	cancel_button.text = "Cancel"
	cancel_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	cancel_button.pressed.connect(func(): date_cancelled.emit())
	
	action_container.add_child(confirm_button)
	action_container.add_child(spacer)
	action_container.add_child(cancel_button)


func _on_confirm_button_pressed() -> void:
	selected_date = get_date_dict()
	date_confirmed.emit()
	print(selected_date)


func get_date_dict() -> Dictionary:
	var day_dict: Dictionary = {"year": current_year, "month": current_month, "day": current_day}
	return day_dict


func get_days_in_moth(_month: int, _year: int) -> int:
	if _month == 2 and _year % 4 == 0 and current_year % 100 != 0:
		return 29
	return DAYS[_month - 1]


func get_first_weekday(_month: int, _year: int) -> int:
	var date := {"year": _year, "month": _month, "day": 1, "hour": 12, "minute" : 0, "second": 0}
	
	var unix_time := Time.get_unix_time_from_datetime_dict(date)
	var datetime := Time.get_datetime_dict_from_unix_time(unix_time)
	
	print(datetime)
	return datetime.weekday


func print_days(days_in_month: int, first_weekday: int) -> void:
	var text_days: String = ""
	
	print("first_weekday: " + str(first_weekday))
	print("MONTH: " + str(current_month))
	print("SA-MO-TU-WE-TH-FR-SA")
	for i in range(0, first_weekday):
		text_days += "   "
	
	for day in range(1, days_in_month+1):
		if(first_weekday == Time.WEEKDAY_SATURDAY or day == days_in_month):
			text_days += str(day)
			print(text_days)
			first_weekday = Time.WEEKDAY_SUNDAY
			text_days = ""
		else:
			if day < 10:
				text_days += " " + str(day) + " "
			else:
				text_days += str(day) + " "
			first_weekday += 1


func fill_calendar_grid(days_in_month: int, first_weekday: int) -> void:
	var day_names: Array[String] = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"]
	
	for day_name in day_names:
		var label: Label = Label.new()
		label.text = day_name
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		calendar_grid.add_child(label)
	
	for i in range(0, first_weekday):
		var empty = Control.new()
		empty.custom_minimum_size = Vector2(40, 30)
		calendar_grid.add_child(empty)
	
	for day in range(1, days_in_month + 1):
		var button = create_day_button(day)
		calendar_grid.add_child(button)
		day_buttons.append(button)


func create_day_button(day: int) -> Button:
	var button := Button.new()
	button.custom_minimum_size = Vector2(40, 30)
	button.text = str(day)
	
	button.pressed.connect(_on_day_selected.bind(day))
	
	return button


func create_calendar() -> void:
	update_title()
	
	clear_grid()
	
	fill_calendar_grid(get_days_in_moth(current_month, current_year), get_first_weekday(current_month, current_year))


func update_title() -> void:
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.text = str(current_day) + "/" + str(current_month) + "/" + str(current_year)


func clear_grid() -> void:
	for child in calendar_grid.get_children():
		child.queue_free()
	day_buttons.clear()


func _on_next_but_pressed() -> void:
	current_month += 1
	if current_month == 13:
		current_month = 1
		current_year += 1
	
	current_day = 1
	
	create_calendar()


func _on_day_selected(day: int) -> void:
	current_day = day
	update_title()


func _on_prev_but_pressed() -> void:
	current_month -= 1
	if current_month == 0:
		current_month = 12
		current_year -= 1
	
	current_day = 1
	
	create_calendar()
