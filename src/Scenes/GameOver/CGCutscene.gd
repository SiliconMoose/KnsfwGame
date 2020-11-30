extends Node2D

signal cg_complete()

func _ready():
	$CanvasLayer/CumButton.connect("pressed", self, "_on_cum")
	$AnimationPlayer.connect("animation_finished", self, "_on_anim_complete")
	$CanvasLayer/NextButton.connect("pressed", self, "_on_next")


func start():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Images.get_child(1).visible = false
	$CanvasLayer/NextButton.visible = false


func _on_cum():
	$Images.get_child(1).visible = true
	$AnimationPlayer.play("Show_01")
	$CanvasLayer/CumButton.visible = false;


func _on_next():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	emit_signal("cg_complete")


func _on_anim_complete(_anim: String):
	$CanvasLayer/NextButton.visible = true
