extends Node2D

func _ready():
	$Timer.connect("timeout", self, "_on_timer_done")
	$CanvasLayer/CumButton.connect("pressed", self, "_on_cum")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$AnimationPlayer.connect("animation_finished", self, "_on_anim_complete")
	$CanvasLayer/FadePanel.visible = true
	
	$Images.get_child(1).visible = false
	$CanvasLayer/NextButton.visible = false
	
func _on_timer_done():
	$CanvasLayer/FadePanel.fadeIn()


func _on_cum():
	$Images.get_child(1).visible = true
	$AnimationPlayer.play("Show_01")
	$CanvasLayer/CumButton.visible = false;


func _on_anim_complete(anim: String):
	$CanvasLayer/NextButton.visible = true
