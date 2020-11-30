extends Node2D

signal cg_complete()

var stage: int = 1

func _ready():
	$CanvasLayer/CumButton.connect("pressed", self, "_on_cum")
	$AnimationPlayer.connect("animation_finished", self, "_on_anim_complete")
	$CanvasLayer/NextButton.connect("pressed", self, "_on_next")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	for i in range(1, 6):
		$Images.get_child(i).visible = false
		
	$CanvasLayer/NextButton.visible = false
	$CanvasLayer/FadePanel.connect("fade_complete", self, "_on_fade_complete")
	$CanvasLayer/FadePanel.fadeIn()


func _on_cum():
	if(stage == 1):
		$Images/Boss_CG_Jizz1.visible = true
		$AnimationPlayer.play("Show_01")
		$CanvasLayer/CumButton.visible = false
		$CanvasLayer/NextButton.visible = true
	elif(stage == 2):
		$Images/Boss_CG_Jizz2.visible = true
		$AnimationPlayer.play("Show_03")
		$CanvasLayer/CumButton.visible = false
		$CanvasLayer/NextButton.visible = true
	elif(stage == 3):
		$Images/Boss_CG_Jizz3.visible = true
		$AnimationPlayer.play("Show_05")
		$CanvasLayer/CumButton.visible = false
		$CanvasLayer/NextButton.visible = true
		$CanvasLayer/NextButton.text = "Continue"
		


func _on_next():
	if(stage == 1):
		$Images/Boss_CG2.visible = true
		$AnimationPlayer.play("Show_02")
		$CanvasLayer/CumButton.visible = true
		$CanvasLayer/NextButton.visible = false
		stage = 2
	elif(stage == 2):
		$Images/Boss_CG3.visible = true
		$AnimationPlayer.play("Show_04")
		$CanvasLayer/CumButton.visible = true
		$CanvasLayer/NextButton.visible = false
		stage = 3
	elif(stage == 3):
		LevelManager.goto_scene("res://Levels/ExitLevel.tscn")


func _on_fade_complete():
	if $CanvasLayer/NextButton.visible:
		GameManager.restart_current_level()
