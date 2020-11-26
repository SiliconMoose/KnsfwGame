extends Node2D


signal interaction(type)

# Called when the node enters the scene tree for the first time.
func _ready():
	$World/Player/Dialogue.visible = false
	var triggers = $World/Environment/Triggers.get_children()
	
	for trigger in triggers:
		trigger.connect('body_entered', self, "_onPlayerInDialogTrigger", [trigger])
	
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$World/Player/Camera2D/FadePanel.visible = true
	$World/Player/Camera2D/FadePanel/AnimationPlayer.play("FadeIn")


func _onPlayerInDialogTrigger(body: Node, trigger: Node):
	if(body.name == "Player" && !trigger.isTripped):
		var key = trigger.DialogueKey as String
		trigger.isTripped = true
		
		var diagDict = $World/Environment/Triggers.dict as Dictionary
		if(diagDict.has(key)):
			var dialogueList = diagDict[key] as Array
			$World/Player/Dialogue.startDialogue(dialogueList)
			
			emit_signal('interaction', 'Wait')
			


func _on_dialogue_done():
	emit_signal('interaction', 'Idle')
