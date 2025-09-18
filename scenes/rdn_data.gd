class_name RDN_Data
extends RefCounted

var activity: String
var datetime: Dictionary
var duration: String

func _init(activity: String = "", datetime: Dictionary = {}, duration: String = "") -> void:
	self.activity = activity
	self.datetime = datetime
	self.duration = duration
