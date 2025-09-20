extends Node

## TEST
var data_cache: Array[RDN_Data]
var activity: String
const SAVE_PATH = "user://save.json"

var file_loaded = false

func _ready() -> void:
	SignalBus.data_init.connect(_on_data_init)
	SignalBus.data_end.connect(_on_data_end)

func _on_data_init(_activity: String) -> void:
	print("DATA INIT")
	activity = _activity

func _on_data_end(end_time: String) -> void:
	print("DATA END")
	data_cache.push_back(RDN_Data.new(activity, Time.get_date_dict_from_system(), end_time))
	save_data()


func print_data() -> void:
	for data in data_cache:
		print(data.activity + " ", data.datetime, " " + data.duration)


func add_data(_activity: String, _datatime: Dictionary, _duration: String) -> void:
	if not file_loaded:
		load_data()
	
	data_cache.push_back(RDN_Data.new(_activity, _datatime, _duration))


func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	file_loaded = true
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	
	while file.get_position() < file.get_length():
		var json_string = file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if not parse_result == OK:
			print("ERROR")
			return
		var node_data = json.data
		
		add_data(node_data["activity"], dict_float_to_int(node_data.datetime), node_data["duration"])

func dict_float_to_int(_dict: Dictionary) -> Dictionary:
	for key in _dict:
		_dict[key] = int(_dict[key])
	return _dict


func save_data() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	if not file:
		print("NULL")
	
	for data in data_cache:
		var save_dict = {
			activity = data.activity,
			datetime = data.datetime,
			duration = data.duration
		}
		
		file.store_line(JSON.stringify(save_dict))
