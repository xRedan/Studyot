extends Control

const DAYS: Array[int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

var calendar_grid: GridContainer

var year: int
var month: int

var days_in_month: int

func _ready() -> void:
	calendar_grid = GridContainer.new()
	calendar_grid.columns = 7
	add_child(calendar_grid)
	year = 2028
	month = 02
	days_in_month = get_days_in_moth(month, year)
	print_days()
	fill_calendar_grid()

## TODO: Sistemare FEBBRAIO
func get_days_in_moth(_month: int, _year: int) -> int:
	if _month == 2 and _year % 4 == 0 and year % 100 != 0:
		return 29
	return DAYS[_month - 1]


func get_first_weekday(_month: int, _year: int) -> int:
	var date := {"year": _year, "month": _month, "day": 1, "hour": 12, "minute" : 0, "second": 0}
	
	var unix_time := Time.get_unix_time_from_datetime_dict(date)
	var datetime := Time.get_datetime_dict_from_unix_time(unix_time)
	
	print(datetime)
	return datetime.weekday


func print_days() -> void:
	var text_days: String
	var first_weekday = get_first_weekday(month, year)
	
	print("first_weekday: " + str(first_weekday))
	print("MONTH: " + str(month))
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

func fill_calendar_grid() -> void:
	var day_names: Array[String] = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"]
	var first_weekday = get_first_weekday(month, year)
	for day_name in day_names:
		var label: Label = Label.new()
		label.text = day_name
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		calendar_grid.add_child(label)
	
	for i in range(0, first_weekday):
		var button = Button.new()
		button.text = "null"
		calendar_grid.add_child(button)
	
	for day in range(1, days_in_month + 1):
		var button = Button.new()
		button.text = str(day)
		calendar_grid.add_child(button)

func generate_calendar_footer() -> void:
	var hboxcont: HBoxContainer = HBoxContainer.new()
	add_child(hboxcont)
	var button_prev: Button = Button.new()
	button_prev.text = "<-"
	hboxcont.add_child(button_prev)
