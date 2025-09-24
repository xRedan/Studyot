class_name RDN_Data
extends Resource

@export var argument: String
@export var activity: String
@export var datetime: Dictionary
@export var duration: String

func _init(_activity: String = "", _datetime: Dictionary = {}, _duration: String = "") -> void:
	activity = _activity
	datetime = _datetime
	duration = _duration
