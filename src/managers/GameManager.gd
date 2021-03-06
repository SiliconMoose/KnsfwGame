extends Node

var hasSaveLoaded: bool = false
var currentLevel: String


func restart_current_level():
	LevelManager.start_level(currentLevel)


func _ready():
	randomize()
	
	UserDataManager.connect("loaded", self, "_on_save_loaded")
	UserDataManager.load_data({}, "1.0")


func _on_save_loaded():
	hasSaveLoaded = true
