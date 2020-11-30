extends "res://Scenes/Game.gd"


var flareSound: Resource = preload("res://Assets/Audio/Effects/Foley/Fire Burst 4.wav")

var stage: int = 0


# This class is an abomination held together by chewing gum and prayer

func _ready():
	var global_l = $Bounds/Left.global_position
	var global_r = $Bounds/Right.global_position
	$World/Player/Camera.limit_left = global_l.x
	$World/Player/Camera.limit_right = global_r.x
	
	$Interfaces/Dialogue.connect("dialogue_done", self, "_on_dialogue_done")
	$Interfaces/Dialogue.visible = false
	
	$Interfaces/FadePanel.connect("fade_complete", self, '_fadeComplete')
	
	var triggers = $World/Environment/Triggers.get_children()
	for trigger in triggers:
		trigger.connect('body_entered', self, "_on_player_trip_trigger", [trigger])

	$World/Player._change_state("Wait")
	$World/Player.visible = false

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Interfaces/FadePanel.visible = true
	$Interfaces/FadePanel/AnimationPlayer.play("FadeIn")
	
	$Timers/StartDialogTimer.connect("timeout", self, "_start_dialogue")
	$Timers/StartDialogTimer.start()
	
	$Timers/WalkOffTimer.connect("timeout", self, "_trigger_fade_out")


func _on_player_trip_trigger(body: Node, trigger: Node):
	if body.name == "Player":
		if trigger is ChangeLevelTrigger:
			LevelManager.start_level(trigger.levelName)
			# stop the simulated keypress
			var a = InputEventKey.new()
			a.scancode = KEY_RIGHT
			a.pressed = false 
			Input.parse_input_event(a)


func _on_dialogue_done():
	if(stage == 0):
		stage = 1
		$Timers/WalkOffTimer.start()
		$World/Hazards/Alt_Player/States/Patrol.targetPosition = $World/Hazards/Position2D.position
		$World/Hazards/Alt_Player._change_state("Patrol")



func _start_dialogue():
	var diagDict = $Interfaces/Dialogue.dict as Dictionary
	var dialogueList = diagDict["outtro"] as Array
	$Interfaces/Dialogue.startDialogue(dialogueList)


func _fadeComplete(): 
	if stage == 1:
		LevelManager.goto_scene("res://Scenes/MainMenu.tscn")


func _trigger_fade_out():
	$Interfaces/FadePanel.fadeOut()
