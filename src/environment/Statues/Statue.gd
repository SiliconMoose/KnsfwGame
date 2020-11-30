extends Area2D

class_name Statue

export var tripped: bool


func _ready():
	highlight(false)
	$Icon.visible = false


func highlight(value: bool):
	$Normal.visible = !value
	$Highlighted.visible = value
	tripped = true
	

func show_icon(value: bool):
	$Icon.visible = value
