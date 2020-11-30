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
	
	$Interfaces/CG.connect("cg_complete", self, "_cg_complete")
	
	var triggers = $World/Environment/Triggers.get_children()
	for trigger in triggers:
		trigger.connect('body_entered', self, "_on_player_trip_trigger", [trigger])

	$World/Player._change_state("Wait")
	$World/Player.visible = false

	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Interfaces/FadePanel.visible = true
	$Interfaces/FadePanel/AnimationPlayer.play("FadeIn")
	
	$Timers/StartDialogTimer.connect("timeout", self, "_start_dialogue")
	$Timers/ShowImpTimer.connect("timeout", self, "_show_imp")
	$Timers/ShowImpTimer.start()


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
		$Interfaces/FadePanel.fadeOut()
	else:
		emit_signal('interaction', 'Idle')
		# simulate a keypress to the right
		var a = InputEventKey.new()
		a.scancode = KEY_RIGHT
		a.pressed = true 
		Input.parse_input_event(a)


func _show_imp():
	$World/Environment/Props/IMP_MC.visible = true
	$World/Environment/Props/IMP_MC/AnimatedSprite.play("Show")
	$Interfaces/FireSound.play()
	$Timers/StartDialogTimer.start()


func _start_dialogue():
	var diagDict = $Interfaces/Dialogue.dict as Dictionary
	var dialogueList = diagDict["intro"] as Array
	$Interfaces/Dialogue.startDialogue(dialogueList)
	$World/Environment/Props/IMP_MC/AnimatedSprite.play("default")


func _start_dialogue_part2():
	var diagDict = $Interfaces/Dialogue.dict as Dictionary
	var dialogueList = diagDict["intro2"] as Array
	$Interfaces/Dialogue.startDialogue(dialogueList)
	
func _fadeComplete(): 
	if stage == 1:
		stage = 2
		$Interfaces/CG.visible = true
		$Interfaces/CG.start()
		$Interfaces/FadePanel.fadeIn()
	elif stage == 3:
		$Interfaces/CG.visible = false
		$Interfaces/FadePanel.fadeIn()
		stage = 4
	elif stage == 4:
		_start_dialogue_part2()


func _cg_complete():
		$World/Environment/Props/IMP_MC.visible = false
		$World/Environment/Props/NPC_Extra/AnimatedSprite.play("Dead")
		$World/Player.visible = true
		stage = 3
		$Interfaces/FadePanel.fadeOut()
		
