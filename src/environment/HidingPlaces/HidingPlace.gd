extends Area2D

class_name HidingPlace

func _ready():
	highlight(false)


func highlight(value: bool):
	$Normal.visible = !value
	$Highlighted.visible = value
