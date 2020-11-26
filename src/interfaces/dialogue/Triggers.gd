extends Node2D

var dict = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("res://Data/dialogue.json", file.READ)
	var text = file.get_as_text()
	dict = JSON.parse(text).result
	file.close()
