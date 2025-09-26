class_name RDN_DataManager
extends Node

const SAVE_PATH = "user://save.json"

var data_cache: Array[RDN_Data]
var tmp_data: RDN_Data

var cache_loaded = false
var cache_changed = false

var auto_save_timer: Timer

func _ready() -> void:
	load_data()
	print_data()
	_setup_auto_save(30.0)
	SignalBus.data_init.connect(_on_data_init)
	SignalBus.data_end.connect(_on_data_end)
	SignalBus.stopwatch_value_changed.connect(_tmp_data_update)


func _setup_auto_save(_wait_time: float) -> void:
	if auto_save_timer:
		auto_save_timer.queue_free()
	
	auto_save_timer = Timer.new()
	auto_save_timer.wait_time = _wait_time
	auto_save_timer.autostart = true
	auto_save_timer.ignore_time_scale = true
	auto_save_timer.timeout.connect(_on_auto_save_timer_timeout)
	add_child(auto_save_timer)


func _on_auto_save_timer_timeout() -> void:
	## Aggiorna i dati se effettivamente i valori sono cambiati.
	update_data()
	## Salva i dati su disco se differiscono da quelli salvati in precedenza.
	save_data()
	## DEBUG
	##print_data()


func get_data_from_dict(_date: Dictionary) -> Array[RDN_Data]:
	var selected_data: Array[RDN_Data] = []
	for data in data_cache:
		if is_date_equal(data.datetime, _date):
			selected_data.append(data)
	return selected_data


func is_date_equal(_date: Dictionary, date_to_compare: Dictionary) -> bool:
	if _date["day"] != date_to_compare["day"]:
		return false
	elif _date["month"] != date_to_compare["month"]:
		return false
	elif  _date["year"] != date_to_compare["year"]:
		return false
	return true


func update_data() -> void:
	print("## UPDATE DATA FUNC ##")
	## Se l'array non contiene nessun membro.
	if not data_cache  or not tmp_data:
		print("ERROR: NO DATA TO UPDATE")
		return
	
	## Se non é stato apportato nessun cambiamento ai dati.
	if data_cache.back().duration == tmp_data.duration :
		print("## RETURN FUNC: NO CHANGE TO SUBMIT ##")
		return

	## Salva nella cache.
	data_cache.back().duration = tmp_data.duration
	cache_changed = true
	print("## RETURN FUNC: CHANGE SUBMITTED ##")


func forced_save() -> void:
	print("## FORCED SAVE FUNC ##")
	update_data()
	save_data()


## Aggiorna "duration" ogni volta che viene aggiornato il cronometro.
func _tmp_data_update(_duration: String) -> void:
	tmp_data.duration = _duration


## Segnale emesso quando viene premuto il pulsante "Play" del cronometro.
## Controlla se é stato inserito un nome per activity
## e crea un nuovo oggetto che verrá aggiunto alla cache e
## aggiornato ogni TOT_SEC dall'auto-save.
func _on_data_init(_activity: String) -> void:
	print("## DATA INIT FUNC ##")
	if _activity.is_empty():
		print("ERROR: NO ACTIVITY FOUND")
		_activity = "Default activity"
	
	tmp_data = RDN_Data.new(_activity, Time.get_datetime_dict_from_system())
	
	## Inserisco il una copia di tmp_data nell'array
	data_cache.append(tmp_data.duplicate())
	cache_changed = true


## Segnale emesso alle pressione del pulsante "STOP".
## Fa un ultimo salvataggio su disco con gli ultimi dati ricevuti.
func _on_data_end(_end_time: String) -> void:
	print("## DATA END FUNC ##")
	forced_save()


## DEBUG FUNC
func print_data() -> void:
	for data in data_cache:
		print("##--ACTIVITY--DATE--DURATION--##")
		print("##--"+ data.activity + "--##--", data.datetime, "--##" + data.duration + "--##")
		print("##----------------------------##")


func get_data_stats(_data: RDN_Data) -> String:
	var str := ""
	str += "##--ACTIVITY--DATE--DURATION--##\n"
	str += "##--"+ _data.activity + "--##--" + str(_data.datetime) + "--##" + _data.duration + "--##" + '\n'
	str += "##----------------------------##"
	return str


func add_data(_activity: String, _datatime: Dictionary, _duration: String) -> void:
	if not cache_loaded:
		load_data()
	data_cache.push_back(RDN_Data.new(_activity, _datatime, _duration))


func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("ERROR: SAVE_PATH")
		return
	
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		print("ERROR: IMPOSSIBLE TO OPEN THE FILE")
		return
	
	cache_loaded = true

	while file.get_position() < file.get_length():
		var json_string = file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if not parse_result == OK:
			print("ERROR: json.parse")
			return
			
		var node_data = json.data
		add_data(node_data["activity"], dict_float_to_int(node_data.datetime), node_data["duration"])


## Converte tutti i membri di un dizionario in valori interi.
func dict_float_to_int(_dict: Dictionary) -> Dictionary:
	for key in _dict:
		if typeof(_dict[key]) == TYPE_FLOAT:
			_dict[key] = int(_dict[key])
	return _dict


func save_data() -> void:
	if not cache_changed:
		return
	
	print("SAVE_DATA")
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file:
		print("ERROR: IMPOSSIBLE TO OPEN THE FILE")
	
	for data in data_cache:
		var save_dict = {
			activity = data.activity,
			datetime = data.datetime,
			duration = data.duration
		}
		
		file.store_line(JSON.stringify(save_dict))
	cache_changed = false
