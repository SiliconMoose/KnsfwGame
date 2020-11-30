extends Node2D

signal loaded()

signal version_mismatch()

const LOADED = "loaded"
const VERSION_MISMATCH = "version_mismatch"

var _path = "user://corp-hell-save.json" #Change this to user://data.dat after testing
var _user_data = {}

func load_data(default_data, version):
	_user_data["version"] = version
	_user_data["data"] = default_data
	var f = File.new()
	if(not f.file_exists(_path)):
		save_data()
	f.open(_path, File.READ)
	var path = f.get_path_absolute()
	var loaded_data = {}
	var text = f.get_as_text()
	loaded_data =JSON.parse(f.get_as_text()).result
	_parse_loaded_data(loaded_data)
	f.close()


func _parse_loaded_data(loaded_data):
	var loaded_version = loaded_data.version
	for key in loaded_data.data.keys():
		_user_data["data"][key] = loaded_data["data"][key]
	if(loaded_version != _user_data.version):
		emit_signal(VERSION_MISMATCH,loaded_version,loaded_data.data)
	else:
		emit_signal(LOADED)


func save_corrected_data(corrected_user_data):
	_user_data["data"] = corrected_user_data
	save_data()


func update_version(version):
	_user_data["version"] = version
	save_data()


func save_data():
	var f = File.new()
	f.open(_path,File.WRITE)
	f.store_string(JSON.print(_user_data))
	f.close()


func set_data(key,value):
	_user_data["data"][key] = value


func get_data(key):
	return _user_data["data"][key]
