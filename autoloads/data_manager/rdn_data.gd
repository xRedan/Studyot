class_name RDN_Data
extends Resource

@export var argument: String
@export var activity: String
@export var datetime: Dictionary
@export var duration: int

func _init(_activity: String = "", _datetime: Dictionary = {}, _duration: int = 0) -> void:
	activity = _activity
	datetime = _datetime
	duration = _duration
