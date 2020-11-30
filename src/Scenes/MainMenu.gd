extends Control

var actionAfterFade: String = "enableMenu"

var continueOnLevel: String

func _ready() -> void:
	$SideMenu/NewGameButton.connect('pressed', self, '_onNewPressed')
	$SideMenu/ContinueButton.connect('pressed', self, '_onContinuePressed')
	$SideMenu/OptionsButton.connect('pressed', self, '_onOptionPressed')
	$SideMenu/QuitButton.connect('pressed', self, '_onQuitPressed')
	$FadePanel.connect("fade_complete", self, '_fadeComplete')
	$FadePanel.visible = true
	
	UserDataManager.connect("loaded", self, "_on_save_loaded")
	
	if GameManager.hasSaveLoaded:
		_on_save_loaded()
	
	actionAfterFade = "enableMenu"
	$FadePanel.fadeIn()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$FadePanel.mouse_filter = Control.MOUSE_FILTER_STOP


# disables the cursor and begins fade out to load next level
func _onNewPressed() -> void:
	actionAfterFade = "startNew"
	$FadePanel.mouse_filter = Control.MOUSE_FILTER_STOP
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$FadePanel.fadeOut()


func _onContinuePressed() -> void:
	LevelManager.start_level(continueOnLevel)
	
	
func _onOptionPressed() -> void:
	get_tree().reload_current_scene()
	
	
func _onQuitPressed() -> void:
	get_tree().quit()
	
	
# Enables input after the initial fade in and loads the next scene after fade out
func _fadeComplete() -> void: 
	if (actionAfterFade == "startNew"):
		LevelManager.start_level("IntroLevel")
	elif (actionAfterFade == "enableMenu"):
		$FadePanel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_save_loaded():
	var saveFile = UserDataManager.get_data("save-file")
	if(saveFile != null):
		continueOnLevel = saveFile["level"]
	if(continueOnLevel != null):
		$SideMenu/ContinueButton.disabled = false
