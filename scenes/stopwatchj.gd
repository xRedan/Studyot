extends Control

signal stopwatch_started
signal stopwatch_paused
signal stopwatch_stopped

## Stopwatch things
@onready var stopwatch_text: NumberClock = %NumberClock
@onready var stopwatch: Timer = %Stopwatch

## Buttons
@onready var play_button: TextureButton = %PlayButton
@onready var pause_button: TextureButton = %PauseButton
@onready var reset_button: TextureButton = %ResetButton


func _ready() -> void:
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


## Gestisce quali pulsanti sono attivi in base allo status corrente.
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


## Timer di 1 secondo che al suo termine aggiorna stopwatch_text
## ed emette un segnale che indica che il valore é stato cambiato.
func _on_stopwatch_timeout() -> void:
	stopwatch_text.add_second(int(stopwatch.wait_time))
	SignalBus.stopwatch_value_changed.emit(stopwatch_text.stopwatch.get_clock_to_str())


func _on_stopwatch_started() -> void:
	stopwatch.paused = false
	stopwatch.start()


func _on_stopwatch_pause() -> void:
	stopwatch.paused = true


func _on_stopwatch_stopped() -> void:
	stopwatch.stop()
	## Reset della label
	stopwatch_text.update_time_from_sec(0)


#region BUTTONS SIGNALS

## PLAY BUTTON PRESSED ##
func _on_play_button_pressed() -> void:
	print("PLAY BUTTON PRESSED")
	## Se viene startato un nuovo timer
	if Globals.stopwatch_status == Globals.StopwatchState.IDLE:
		SignalBus.data_init.emit(%TextEdit.text)
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
	SignalBus.data_end.emit(stopwatch_text.stopwatch.get_clock_to_str())
	stopwatch_stopped.emit()
	Globals.stopwatch_status = Globals.StopwatchState.IDLE

#endregion
