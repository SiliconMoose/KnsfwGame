extends Control


func _ready() -> void:
	$SideMenu/NewGameButton.connect('pressed', self, '_onNewPressed')
	$SideMenu/ContinueButton.connect('pressed', self, '_onContinuePressed')
	$SideMenu/OptionsButton.connect('pressed', self, '_onOptionPressed')
	$SideMenu/QuitButton.connect('pressed', self, '_onQuitPressed')
	$FadePanel/AnimationPlayer.play("FadeIn")
	$FadePanel/AnimationPlayer.connect("animation_finished", self, '_fadeComplete')
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# disables the cursor and begins fade out to load next level
func _onNewPressed() -> void:
	$FadePanel.mouse_filter = Control.MOUSE_FILTER_STOP
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$FadePanel/AnimationPlayer.play("FadeOut");


func _onContinuePressed() -> void:
	get_tree().change_scene("res://Scenes/Game.tscn")
	
	
func _onOptionPressed() -> void:
	$FadePanel/AnimationPlayer.play("FadeOut")
	
	
func _onQuitPressed() -> void:
	get_tree().quit()
	
	
# Enables input after the initial fade in and loads the next scene after fade out
func _fadeComplete(anim_name: String) -> void: 
	if (anim_name == "FadeOut"):
		get_tree().change_scene("res://Scenes/Game.tscn")
	elif (anim_name == "FadeIn"):
		$FadePanel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
