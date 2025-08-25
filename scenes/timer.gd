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
	play_button.pressed.connect(_play_button_pressed)
	stop_button.pressed.connect(_stop_button_pressed)

func _process(delta: float) -> void:
	print(timer.time_left)

func _play_button_pressed() -> void:
	timer.start(number_clock.clock_values.get_clock_to_sec())

func _stop_button_pressed() -> void:
	timer.stop()
