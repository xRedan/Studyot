extends Control

@onready var number_clock: NumberClock = $VBoxContainer/NumberClock

@onready var play_button: TextureButton = $VBoxContainer/Buttons/PlayButton
@onready var pause_button: TextureButton = $VBoxContainer/Buttons/PauseButton
@onready var reset_button: TextureButton = $VBoxContainer/Buttons/ResetButton

@onready var stopwatch: Timer = %Stopwatch

var timer_started: bool:
	set = _set_timer_started


func _ready() -> void:
#region New Code Region
	## Buttons
	play_button.pressed.connect(_on_play_button_pressed)
	pause_button.pressed.connect(_on_pause_button_pressed)
	reset_button.pressed.connect(_on_reset_button_pressed)
	## Timers
	stopwatch.timeout.connect(_on_stopwatch_timeout)
#endregion
	timer_started = false


func _set_timer_started(value: bool) -> void:
	if value:
		play_button.disabled = true
		pause_button.disabled = false
	else:
		play_button.disabled = false
		pause_button.disabled = true
	timer_started = value


func _on_stopwatch_timeout() -> void:
	if timer_started:
		number_clock.update_time_sec(number_clock.clock_values.get_clock_to_sec() + 1)
		print(number_clock.clock_values.get_clock_to_str())
	else:
		stopwatch.stop()
		timer_started = false


## PLAY BUTTON PRESSED ##
func _on_play_button_pressed() -> void:
	print("PLAY BUTTON PRESSED")
	if not stopwatch.paused:
		print("TIMER STARTED")
		timer_started = true
		stopwatch.start()
	else:
		print("PAUSED RESUME")
		timer_started = true
		stopwatch.paused = false


## PAUSE BUTTON PRESSED ##
func _on_pause_button_pressed() -> void:
	print("PAUSE BUTTON PRESSED")
	timer_started = false
	stopwatch.paused = true


## RESET BUTTON PRESSED ##
func _on_reset_button_pressed() -> void:
	print("RESET BUTTON PRESSED")
	stopwatch.stop()
	stopwatch.paused = false
	timer_started = false
	number_clock.update_time_sec(0)
