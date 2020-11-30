extends Control


func _ready():
	$Timer.connect("timeout", self, "_hide_message")
	$Panel/VBoxContainer/Label.modulate = Color.transparent


func show_instruction(instruction: String):
	$Panel/VBoxContainer/Label.text = instruction
	$AnimationPlayer.play("FadeIn")
	$Timer.start()


func _hide_message():
	$AnimationPlayer.play("FadeOut")
