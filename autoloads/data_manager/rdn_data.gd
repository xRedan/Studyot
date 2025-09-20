## TEST:
## Forse sarebbe meglio utilizzare un dizionario
## invece di una classe specifica?

class_name RDN_Data
extends RefCounted

var activity: String
var datetime: Dictionary
var duration: String

func _init(_activity: String = "", _datetime: Dictionary = {}, _duration: String = "") -> void:
	activity = _activity
	datetime = _datetime
	duration = _duration
