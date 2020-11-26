extends Control


func _ready() -> void:
	$Panel/VBoxContainer/ResumeButton.connect('pressed', self, '_on_Resume_pressed')
	$Panel/VBoxContainer/QuitButton.connect('pressed', self, '_on_Quit_pressed')


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('pause'):
		var new_pause_state: bool = !get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
		if(visible):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		get_node('Panel/VBoxContainer/ResumeButton').grab_focus()


func _on_Resume_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_Quit_pressed() -> void:
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
