extends Control

@onready var hours: NumberClock = $Clock/Hours
@onready var minutes: NumberClock = $Clock/Minutes
@onready var seconds: NumberClock = $Clock/Seconds

func _ready() -> void:
	$MarginContainer/ButtonsUp/Button4.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	print("add")
	seconds.add(1)


func _is_inside(container_start_pos: Vector2, container_size: Vector2, content_pos: Vector2) -> bool:
	var container_end_pos: Vector2
	container_end_pos.x = container_start_pos.x + container_size.x
	container_end_pos.y = container_start_pos.y + container_size.y
	
	var is_inside: bool = false
	
	if _beetween(content_pos.x, container_start_pos.x, container_end_pos.x):
		if _beetween(content_pos.y, container_start_pos.y, container_end_pos.y):
			is_inside = true
	
	return is_inside


func _beetween(value: float, min: float, max: float) -> bool:
	if value >= min and value <= max:
		return true
	return false


func _process(delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(minutes.global_position, minutes.size), Color.GREEN, false)
	draw_rect(Rect2(seconds.global_position, seconds.size), Color.RED, false)
	draw_rect(Rect2(hours.global_position, hours.size), Color.YELLOW, false)
	
func add_number() -> void:
	pass

func sub_number() -> void:
	pass
