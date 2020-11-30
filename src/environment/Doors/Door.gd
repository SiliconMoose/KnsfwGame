extends Area2D

class_name Door

export var ConnectedLevel: String

func _ready():
	$Icon.visible = false


func show_icon(value: bool):
	$Icon.visible = value
