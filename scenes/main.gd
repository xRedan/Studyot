extends Control

signal stopwatch_started
signal stopwatch_paused
signal stopwatch_stopped

## Stopwatch things
@onready var stopwatch_text: NumberClock = $VBoxContainer/NumberClock
@onready var stopwatch: Timer = %Stopwatch

## Buttons
@onready var play_button: TextureButton = $VBoxContainer/Buttons/PlayButton
@onready var pause_button: TextureButton = $VBoxContainer/Buttons/PauseButton
@onready var reset_button: TextureButton = $VBoxContainer/Buttons/ResetButton

var first_press_only: bool

func _ready() -> void:
	## DEBUG ##
	RdnDataManager.load_data()
	RdnDataManager.print_data()
	## Variables
	first_press_only = true
	## Stopwatch
	stopwatch.timeout.connect(_on_stopwatch_timeout)
	## Internal Signals
	stopwatch_started.connect(_on_stopwatch_started)
	stopwatch_paused.connect(_on_stopwatch_pause)
	stopwatch_stopped.connect(_on_stopwatch_stopped)
	## Buttons
	play_button.pressed.connect(_on_play_button_pressed)
	pause_button.pressed.connect(_on_pause_button_pressed)
	reset_button.pressed.connect(_on_reset_button_pressed)


func _process(_delta: float) -> void:
	match Globals.stopwatch_status:
		Globals.StopwatchState.IDLE:
			play_button.disabled = false
			pause_button.disabled = true
			reset_button.disabled = true
		
		Globals.StopwatchState.ACTIVE:
			play_button.disabled = true
			pause_button.disabled = false
			reset_button.disabled = false
		
		Globals.StopwatchState.PAUSED:
			play_button.disabled = false
			pause_button.disabled = true
			reset_button.disabled = false


func _on_stopwatch_timeout() -> void:
	stopwatch_text.add_time_sec(int(stopwatch.wait_time))
	SignalBus.stopwatch_value_changed.emit(stopwatch_text.clock_values.get_clock_to_str())


func _on_stopwatch_started() -> void:
	stopwatch.paused = false
	stopwatch.start()


func _on_stopwatch_pause() -> void:
	stopwatch.paused = true


func _on_stopwatch_stopped() -> void:
	stopwatch.stop()
	stopwatch_text.update_time_sec(0)


#region BUTTONS SIGNALS

## PLAY BUTTON PRESSED ##
func _on_play_button_pressed() -> void:
	print("PLAY BUTTON PRESSED")
	if first_press_only:
		SignalBus.data_init.emit($VBoxContainer/TextEdit.text)
		first_press_only = false
	stopwatch_started.emit()
	Globals.stopwatch_status = Globals.StopwatchState.ACTIVE


## PAUSE BUTTON PRESSED ##
func _on_pause_button_pressed() -> void:
	print("PAUSE BUTTON PRESSED")
	stopwatch_paused.emit()
	Globals.stopwatch_status = Globals.StopwatchState.PAUSED


## RESET BUTTON PRESSED ##
func _on_reset_button_pressed() -> void:
	print("RESET BUTTON PRESSED")
	first_press_only = true
	SignalBus.data_end.emit(stopwatch_text.clock_values.get_clock_to_str())
	stopwatch_stopped.emit()
	Globals.stopwatch_status = Globals.StopwatchState.IDLE
#endregion
