extends Control

@onready var v_box_container: VBoxContainer = %VBoxContainer

@onready var stats_label: RichTextLabel = %StatsLabel

@onready var day_button: Button = %DayButton
@onready var date_from: Button = %DateFrom
@onready var to_button: Button = %ToButton

@onready var day_line: LineEdit = %DayLine
@onready var date_from_line: LineEdit = %DateFromLine
@onready var date_to_line: LineEdit = %DateToLine

@onready var tab_bar: TabBar = %TabBar

@onready var day_selection: HBoxContainer = %DaySelection
@onready var manual_selection: HBoxContainer = %ManualSelection


var popup_panel: PopupPanel
var default_date: Dictionary
var calendar: Calendar

func _ready() -> void:
	popup_panel = PopupPanel.new()
	default_date = Time.get_datetime_dict_from_system()
	calendar = Calendar.new(default_date.day, default_date.month, default_date.year)
	day_button.pressed.connect(_on_date_button_pressed)
	calendar.date_confirmed.connect(_on_date_confirmed)
	calendar.date_cancelled.connect(_on_date_cancelled)
	
	tab_bar.tab_changed.connect(set_tab_bar)
	
	set_tab_bar()


func set_tab_bar(tab: int = 0) -> void:
	if tab == 0:
		day_selection.visible = true
		manual_selection.visible = false
	elif tab == 1:
		day_selection.visible = false
		manual_selection.visible = true


func update_stats_label(_date: Dictionary) -> void:
	stats_label.text = ""
	var array_of_data := RdnDataManager.get_data_from_dict(_date)
	var tot_sum: int = 0
	stats_label.text += "[ol]"
	for data in array_of_data:
		tot_sum += data["duration"]
		stats_label.text += "Activity: " + data["activity"] + ", duration: " + str(Globals.sec_to_string(data["duration"]))
		stats_label.text += '\n'
		#stats_label.text += data["duration"]
	print(tot_sum)
	stats_label.text += "[/ol]"
	stats_label.text += "[center]"
	stats_label.text += "TOTAL:" + Globals.sec_to_string(tot_sum)
	stats_label.text += "[/center]"


func _on_date_confirmed() -> void:
	var date: Dictionary = calendar.selected_date
	day_line.text = str(date["day"]) + "/" + str(date["month"]) + "/" + str(date["year"])
	popup_panel.hide()
	update_stats_label(date)


func _on_date_cancelled() -> void:
	popup_panel.hide()


func set_popup_position() -> void:
	var button_pos = day_button.global_position
	var button_size = day_button.size
	
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
		set_popup_position()
	
	set_popup_position()
	popup_panel.popup()
