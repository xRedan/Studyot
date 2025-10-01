## MODE: 0 -> Day pressed
## MODE: 1 -> From day pressed
## MODE: 2 -> To day pressed
## TODO: Refactoring del codice, e rifare il sistema di stampa dei dati.
extends Control

@onready var v_box_container: VBoxContainer = %VBoxContainer

@onready var stats_label: RichTextLabel = %StatsLabel

@onready var day_button: Button = %DayButton
@onready var date_from: Button = %DateFrom
@onready var to_button: Button = %ToButton
@onready var confirm_button: Button = %ConfirmButton

@onready var day_line: LineEdit = %DayLine
@onready var date_from_line: LineEdit = %DateFromLine
@onready var date_to_line: LineEdit = %DateToLine

@onready var tab_bar: TabBar = %TabBar

@onready var day_selection: HBoxContainer = %DaySelection
@onready var manual_selection: HBoxContainer = %ManualSelection

var day_selected: Dictionary
var day_from_selected: Dictionary
var day_to_selected: Dictionary
var default_date: Dictionary

var popup_panel: PopupPanel
var calendar: Calendar

func _ready() -> void:
	popup_panel = PopupPanel.new()
	default_date = Time.get_datetime_dict_from_system()
	day_from_selected = Time.get_datetime_dict_from_system()
	day_to_selected = Time.get_datetime_dict_from_system()
	calendar = Calendar.new(default_date.day, default_date.month, default_date.year)
	
	date_from.pressed.connect(_on_date_from_pressed)
	to_button.pressed.connect(_on_to_button_pressed)
	day_button.pressed.connect(_on_date_button_pressed)
	confirm_button.pressed.connect(_on_confirm_button_pressed)
	
	calendar.date_confirmed.connect(_on_date_confirmed)
	calendar.date_cancelled.connect(_on_date_cancelled)
	
	tab_bar.tab_changed.connect(set_tab_bar)
	
	set_tab_bar()


func _on_confirm_button_pressed() -> void:
	update_day_stats_label(RdnDataManager.get_range_data_from_dict(day_from_selected, day_to_selected))


func _on_date_from_pressed() -> void:
	if not popup_panel.is_inside_tree():
		print("INSIDE")
		v_box_container.add_child(popup_panel)
		popup_panel.add_child(calendar)
	
	calendar.set_meta("mode", 1)
	set_popup_position(date_from)
	popup_panel.popup()


func _on_to_button_pressed() -> void:
	if not popup_panel.is_inside_tree():
		print("INSIDE")
		v_box_container.add_child(popup_panel)
		popup_panel.add_child(calendar)
	
	calendar.set_meta("mode", 2)
	set_popup_position(to_button)
	popup_panel.popup()


func set_tab_bar(tab: int = 0) -> void:
	if tab == 0:
		day_selection.visible = true
		manual_selection.visible = false
	elif tab == 1:
		day_selection.visible = false
		manual_selection.visible = true


func update_day_stats_label(array_of_data: Array[RDN_Data]) -> void:
	if array_of_data.is_empty():
		return
	var _date: Dictionary
	var tot_day: int = 0
	var tot_sum: int = 0
	_date = array_of_data[0].datetime
	stats_label.text = "[center][b]DATE: " + str(_date["day"]) + "/" + str(_date["month"]) + "/" + str(_date["year"]) + "[/b][/center]" + '\n'
	stats_label.text += "[ul]"
	for data in array_of_data:
		if not RdnDataManager.is_date_equal(data.datetime, _date):
			_date = data.datetime
			stats_label.text += "[/ul]"
			stats_label.text += "[center][i]TOTAL OF THE DAY: " + Globals.sec_to_string(tot_day) + "[/i][/center]" 
			stats_label.text += "[center][b]DATE: " + str(_date["day"]) + "/" + str(_date["month"]) + "/" + str(_date["year"]) + "[/b][/center][ul]" + '\n'
			tot_day = 0
		tot_sum += data["duration"]
		tot_day += data["duration"]
		stats_label.text += "Activity: " + data["activity"] + ", duration: " + str(Globals.sec_to_string(data["duration"]))
		stats_label.text += '\n'
		#stats_label.text += data["duration"]
	print(tot_sum)
	stats_label.text += "[/ul]"
	stats_label.text += "[center][i]TOTAL OF THE DAY: " + Globals.sec_to_string(tot_day) + "[/i][/center]" 
	stats_label.text += "[center][b]"
	stats_label.text += "TOTAL: " + Globals.sec_to_string(tot_sum)
	stats_label.text += "[/b][/center]"


func _on_date_confirmed() -> void:
	var date: Dictionary = calendar.selected_date
	
	update_text_line(str(date["day"]) + "/" + str(date["month"]) + "/" + str(date["year"]))
		
	popup_panel.hide()
	
	update_stats_label(date)


func update_stats_label(_date: Dictionary) -> void:
	match calendar.get_meta("mode"):
		0:
			update_day_stats_label(RdnDataManager.get_data_from_dict(_date))
		1:
			day_from_selected = _date.duplicate()
		2:
			day_to_selected = _date.duplicate()


func update_text_line(_text: String) -> void:
	match calendar.get_meta("mode"):
		0:
			day_line.text = _text
		1:
			date_from_line.text = _text	
		2:
			date_to_line.text = _text


func _on_date_cancelled() -> void:
	popup_panel.hide()


func set_popup_position(_button: Button) -> void:
	var button_pos = _button.global_position
	var button_size = _button.size
	
	var popup_pos = Vector2(
		button_pos.x,
		button_pos.y + button_size.y + 5
	)
	popup_panel.position = popup_pos


func _on_date_button_pressed() -> void:
	if not popup_panel.is_inside_tree():
		print("INSIDE")
		v_box_container.add_child(popup_panel)
		popup_panel.add_child(calendar)
	
	calendar.set_meta("mode", 0)
	set_popup_position(day_button)
	popup_panel.popup()
