extends Control

signal stopwatch_started
signal stopwatch_paused
signal stopwatch_stopped

## Stopwatch things
@onready var stopwatch_text: NumberClock = %NumberClock
@onready var stopwatch: Timer = %Stopwatch

## Buttons
@onready var play_button: TextureButton = %PlayButton
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
	reset_button.pressed.connect(_on_reset_button_pressed)


## DA TOGLIERE FACENDO UN SISTEMA CHE SI BASA SU I SEGNALI
func _process(_delta: float) -> void:
	pass


## Timer di 1 secondo che al suo termine aggiorna stopwatch_text
## ed emette un segnale che indica che il valore é stato cambiato.
func _on_stopwatch_timeout() -> void:
	stopwatch_text.add_second(int(stopwatch.wait_time))
	SignalBus.stopwatch_value_changed.emit(stopwatch_text.stopwatch.get_clock_to_sec())


func _on_stopwatch_started() -> void:
	if Globals.stopwatch_status == Globals.StopwatchState.ACTIVE:
		stopwatch.paused = false
		stopwatch.start()
	update_button_icon()


func update_button_icon() -> void:
	if Globals.stopwatch_status == Globals.StopwatchState.ACTIVE:
		_change_button_icon("res://resources/buttons/pause_button/pause_button_normal.png", "res://resources/buttons/pause_button/pause_button_hovered.png", "res://resources/buttons/pause_button/pause_button_pressed.png")
	else:
		_change_button_icon("res://resources/buttons/play_button/play_button_normal.png", "res://resources/buttons/play_button/play_button_hovered.png", "res://resources/buttons/play_button/play_button_pressed.png")


func _change_button_icon(img_normal_path: String, img_hovered_path: String, img_pressed_path: String) -> void:
	var normal_texture := load(img_normal_path)
	var hovered_texture := load(img_hovered_path)
	var pressed_texture := load(img_pressed_path)
	
	play_button.texture_normal = normal_texture
	play_button.texture_hover = hovered_texture
	play_button.texture_pressed = pressed_texture


func _on_stopwatch_pause() -> void:
	stopwatch.paused = true
	update_button_icon()


func _on_stopwatch_stopped() -> void:
	stopwatch.stop()
	## Reset della label
	stopwatch_text.update_time_from_sec(0)
	%TextEdit.text = ""
	reset_button.disabled = true
	update_button_icon()


#region BUTTONS SIGNALS

## PLAY BUTTON PRESSED ##
func _on_play_button_pressed() -> void:
	match Globals.stopwatch_status:
		Globals.StopwatchState.IDLE:
			SignalBus.data_init.emit(%TextEdit.text)
			Globals.stopwatch_status = Globals.StopwatchState.ACTIVE
			stopwatch_started.emit()
		Globals.StopwatchState.PAUSED:
			Globals.stopwatch_status = Globals.StopwatchState.ACTIVE
			stopwatch_started.emit()
		Globals.StopwatchState.ACTIVE:
			Globals.stopwatch_status = Globals.StopwatchState.PAUSED
			stopwatch_paused.emit()
	reset_button.disabled = false


## RESET BUTTON PRESSED ##
func _on_reset_button_pressed() -> void:
	print("RESET BUTTON PRESSED")
	Globals.stopwatch_status = Globals.StopwatchState.IDLE
	SignalBus.data_end.emit(stopwatch_text.stopwatch.get_clock_to_str())
	stopwatch_stopped.emit()


#endregion
