extends Control

@onready var number_clock: NumberClock = %NumberClock

@onready var h_up: Button = $VBoxContainer/Panel/ButtonUp/ButtonsUp/H_up
@onready var m_up: Button = $VBoxContainer/Panel/ButtonUp/ButtonsUp/M_up
@onready var s_up: Button = $VBoxContainer/Panel/ButtonUp/ButtonsUp/S_up
@onready var h_down: Button = $VBoxContainer/Panel/ButtonDown/ButtonsUp/H_down
@onready var m_down: Button = $VBoxContainer/Panel/ButtonDown/ButtonsUp/M_down
@onready var s_down: Button = $VBoxContainer/Panel/ButtonDown/ButtonsUp/S_down

@onready var play_button: Button = $VBoxContainer/Buttons/PlayButton
@onready var stop_button: Button = $VBoxContainer/Buttons/StopButton
@onready var timer: Timer = $Timer

func _ready() -> void: 
	h_up.pressed.connect(_on_h_up_pressed)
	m_up.pressed.connect(_on_m_up_pressed)
	s_up.pressed.connect(_on_s_up_pressed)
	h_down.pressed.connect(_h_down_pressed)
	m_down.pressed.connect(_m_down_pressed)
	s_down.pressed.connect(_s_down_pressed)
	play_button.pressed.connect(_play_button_pressed)
	stop_button.pressed.connect(_stop_button_pressed)

func _process(delta: float) -> void:
	pass

func _play_button_pressed() -> void:
	timer.start(number_clock.clock_values.get_clock_to_sec())

func _stop_button_pressed() -> void:
	timer.stop()

func _on_h_up_pressed() -> void:
	number_clock.update_time("hour", number_clock.clock_values.hour + 1)

func _on_m_up_pressed() -> void:
	number_clock.update_time("minute", number_clock.clock_values.minute + 1)

func _on_s_up_pressed() -> void:
	number_clock.update_time("second", number_clock.clock_values.second + 1)

func _h_down_pressed() -> void:
	number_clock.update_time("hour", number_clock.clock_values.hour - 1)

func _m_down_pressed() -> void:
	number_clock.update_time("minute", number_clock.clock_values.minute - 1)

func _s_down_pressed() -> void:
	number_clock.update_time("second", number_clock.clock_values.second - 1)
