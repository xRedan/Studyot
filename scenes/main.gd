extends Control

@onready var slider: HSlider = $VBoxContainer/Slider
@onready var number_clock: NumberClock = $VBoxContainer/NumberClock

func _ready() -> void:
	slider.value_changed.connect(_on_value_changed)

func _on_value_changed(value: float):
	number_clock.update_time_sec(value)
	print(value)
