extends Node2D


func _ready():
	$Timer.connect("timeout", self, "_on_timer_done")

func _on_timer_done():
	$CanvasLayer/FadePanel.fadeIn()
