extends Control

@onready var slider: HSlider = $VBoxContainer/Slider
@onready var number_clock: NumberClock = $VBoxContainer/NumberClock

func _ready() -> void:
	slider.value_changed.connect(_on_value_changed)

func _on_value_changed(value: float):
	if number_clock.selected_timer == number_clock.TimeType.HOUR:
		slider.max_value = 23
	else:
		slider.max_value = number_clock.clock_values.MAX_MINUTES - 1
	number_clock.update_time(number_clock.selected_timer, value)
	print(value)
