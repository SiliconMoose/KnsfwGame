extends Node2D


signal interaction(type)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Interfaces/Dialogue.connect("dialogue_done", self, "_on_dialogue_done")
	$Interfaces/Dialogue.visible = false
	
	var triggers = $World/Environment/Triggers.get_children()
	for trigger in triggers:
		trigger.connect('body_entered', self, "_on_player_trip_dialogue", [trigger])
		
	var enemies = $World/Enemies.get_children()
	for enemy in enemies:
		enemy.connect('player_caught', self, "_on_player_caught")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Interfaces/FadePanel.visible = true
	$Interfaces/FadePanel/AnimationPlayer.play("FadeIn")


func _on_player_trip_dialogue(body: Node, trigger: Node):
	if(body.name == "Player" && !trigger.isTripped):
		var key = trigger.DialogueKey as String
		trigger.isTripped = true
		
		var diagDict = $World/Environment/Triggers.dict as Dictionary
		if(diagDict.has(key)):
			var dialogueList = diagDict[key] as Array
			$Interfaces/Dialogue.startDialogue(dialogueList)
			
			if(trigger.haltPlayer):
				emit_signal('interaction', 'Wait')
			


func _on_dialogue_done():
	emit_signal('interaction', 'Idle')

func _on_player_caught(type: String):
	$Interfaces/FadePanel.color = Color.black
	$Interfaces/FadePanel.visible = true
	if(type == "chimera"):
		get_tree().change_scene("res://Scenes/GameOver/ChimeraEnd.tscn")
