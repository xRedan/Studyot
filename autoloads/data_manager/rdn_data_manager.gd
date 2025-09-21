extends Node

const SAVE_PATH = "user://save.json"

## TEST
var data_cache: Array[RDN_Data]
var tmp_data: RDN_Data

var cache_loaded = false
var cache_changed = false

var auto_save_timer: Timer

func _ready() -> void:
	SignalBus.data_init.connect(_on_data_init)
	SignalBus.data_end.connect(_on_data_end)
	SignalBus.stopwatch_value_changed.connect(_tmp_data_update)
	_setup_auto_save(5.0)


func _setup_auto_save(_wait_time: float) -> void:
	if auto_save_timer:
		auto_save_timer.queue_free()
	
	auto_save_timer = Timer.new()
	auto_save_timer.wait_time = _wait_time
	auto_save_timer.autostart = true
	auto_save_timer.autostart = true
	auto_save_timer.timeout.connect(_on_auto_save_timer_timeout)
	add_child(auto_save_timer)


func _on_auto_save_timer_timeout() -> void:
	## Aggiorna i dati se effettivamente i valori sono cambiati.
	update_data()
	## Salva i dati su disco se differiscono da quelli salvati in precedenza.
	save_data()
	## DEBUG
	print_data()


func update_data() -> void:
	print("Update_Data")
	## Se l'array non contiene nessun membro.
	if not data_cache  or not tmp_data:
		return
	
	## Se non é stato apportato nessun cambiamento ai dati.
	if data_cache.back().duration == tmp_data.duration :
		print("EQUAL")
		return

	print("NOT EQUAL")
	## Salva nella cache.
	data_cache.back().duration = tmp_data.duration
	cache_changed = true


## Aggiorna "duration" ogni volta che viene aggiornato il cronometro.
func _tmp_data_update(_duration: String) -> void:
	tmp_data.duration = _duration


## Segnale emesso quando viene premuto il pulsante "Play" del cronometro.
## Controlla se é stato inserito un nome per activity
## e crea un nuovo oggetto che verrá aggiunto alla cache e
## aggiornato ogni TOT_SEC dall'auto-save.
## BUG: Duplicare la risorsa, attualmente viene passata per indirizzo e non come copia.
func _on_data_init(_activity: String) -> void:
	print("DATA INIT")
	if _activity.is_empty():
		print("null")
		_activity = "Default activity"
	
	tmp_data = RDN_Data.new(_activity, Time.get_date_dict_from_system(), "")
	
	## var copy_tmp_data = tmp_data.duplicate()
	data_cache.append(tmp_data)
	cache_changed = true

## Segnale emesso alle pressione del pulsante "STOP".
## Fa un ultimo salvataggio su disco con gli ultimi dati ricevuti.
func _on_data_end(end_time: String) -> void:
	print("DATA END")
	save_data()


## DEBUG FUNC
func print_data() -> void:
	for data in data_cache:
		print(data.activity + " ", data.datetime, " " + data.duration)


func add_data(_activity: String, _datatime: Dictionary, _duration: String) -> void:
	if not cache_loaded:
		load_data()
	
	data_cache.push_back(RDN_Data.new(_activity, _datatime, _duration))

## TODO:
## Da controllare se tutto viene eseguito corettamente
## e se vengono previsti tutti gli errori.
## Inoltre quando viene caricato il file JSON
## il dizionario datetime viene stampato in ordine alfabetico.
func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	cache_loaded = true

	while file.get_position() < file.get_length():
		var json_string = file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if not parse_result == OK:
			print("ERROR")
			return
		var node_data = json.data
		
		add_data(node_data["activity"], dict_float_to_int(node_data.datetime), node_data["duration"])


## Convert float value from dictionary to integer.
func dict_float_to_int(_dict: Dictionary) -> Dictionary:
	for key in _dict:
		_dict[key] = int(_dict[key])
	return _dict


## TODO:
## Da controllare se tutto viene eseguito corettamente
## e se vengono previsti tutti gli errori.
func save_data() -> void:
	if not cache_changed:
		return
	
	print("SAVE_DATA")
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
	cache_changed = false
