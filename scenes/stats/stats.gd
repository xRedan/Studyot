extends Control

@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var date_button: Button = $VBoxContainer/HBoxContainer/DateButton
@onready var date_label: Label = $VBoxContainer/HBoxContainer/DateLabel
@onready var stats_label: Label = $VBoxContainer/StatsLabel

var popup_panel: PopupPanel
var default_date: Dictionary
var calendar: Calendar

func _ready() -> void:
	popup_panel = PopupPanel.new()
	default_date = Time.get_datetime_dict_from_system()
	calendar = Calendar.new(default_date.day, default_date.month, default_date.year)
	date_button.pressed.connect(_on_date_button_pressed)
	calendar.date_confirmed.connect(_on_date_confirmed)


func update_stats_label(_date: Dictionary) -> void:
	stats_label.text = ""
	var array_of_data := RdnDataManager.get_data_from_dict(_date)
	
	for data in array_of_data:
		stats_label.text += RdnDataManager.get_data_stats(data)

func _on_date_confirmed() -> void:
	var date: Dictionary = calendar.selected_date
	date_label.text = str(date["day"]) + "/" + str(date["month"]) + "/" + str(date["year"])
	date_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_FILL
	popup_panel.hide()
	update_stats_label(date)


func set_popup_position() -> void:
	var button_pos = date_button.global_position
	var button_size = date_button.size
	
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
	
	popup_panel.popup()
