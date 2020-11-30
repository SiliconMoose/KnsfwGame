extends Node2D

signal cg_complete()

func _ready():
	$CanvasLayer/CumButton.connect("pressed", self, "_on_cum")
	$AnimationPlayer.connect("animation_finished", self, "_on_anim_complete")
	$CanvasLayer/NextButton.connect("pressed", self, "_on_next")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Images.get_child(1).visible = false
	$CanvasLayer/NextButton.visible = false
	$CanvasLayer/FadePanel.connect("fade_complete", self, "_on_fade_complete")
	$CanvasLayer/FadePanel.fadeIn()


func _on_cum():
	$Images.get_child(1).visible = true
	$AnimationPlayer.play("Show_01")
	$CanvasLayer/CumButton.visible = false;


func _on_next():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$CanvasLayer/FadePanel.fadeOut()


func _on_anim_complete(anim: String):
	$CanvasLayer/NextButton.visible = true


func _on_fade_complete():
	if $CanvasLayer/NextButton.visible:
		GameManager.restart_current_level()
