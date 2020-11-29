extends Node2D

signal interaction(type)

signal action_available(type)

var enemiesList: Array
var targetCG: String

var activeHidingPlace: HidingPlace

# Called when the node enters the scene tree for the first time.
func _ready():
	var global_l = $Bounds/Left.global_position
	var global_r = $Bounds/Right.global_position
	$World/Player/Camera.limit_left = global_l.x
	$World/Player/Camera.limit_right = global_r.x
	
	
	$Interfaces/Dialogue.connect("dialogue_done", self, "_on_dialogue_done")
	$Interfaces/Dialogue.visible = false
	
	$World/Player.connect("state_changed", self, "_on_player_state_change")
	
	var triggers = $World/Environment/Triggers.get_children()
	for trigger in triggers:
		trigger.connect('body_entered', self, "_on_player_trip_trigger", [trigger])

	enemiesList = $World/Enemies.get_children()
	for enemy in enemiesList:
		enemy.connect('player_caught', self, "_on_player_caught")
		
	var hidingPlaces = $World/HidingPlaces.get_children()
	for place in hidingPlaces:
		place.connect('body_entered', self, "_on_player_can_hide", [place, true])
		place.connect('body_exited', self, "_on_player_can_hide", [place, false])
	
	$Interfaces/CGTimer.connect("timeout", self, "_transition_to_CG")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Interfaces/FadePanel.visible = true
	$Interfaces/FadePanel/AnimationPlayer.play("FadeIn")


var total = 0.0
func _process(delta: float):
	if(total > 0.2): # only run 5 times a second
		total = 0
		var detected = _is_player_detected()
		match(detected):
			Hidden:
				$World/Player._show_icon("Hidden")
			Found:
				$World/Player._show_icon("Found")
			Search:
				$World/Player._show_icon("Search")
	else:
		total += delta


func _on_player_trip_trigger(body: Node, trigger: Node):
	if body.name == "Player":
		if(trigger is DialogueTrigger && !trigger.isTripped):
			var key = trigger.DialogueKey as String
			trigger.isTripped = true
			
			var diagDict = $Interfaces/Dialogue.dict as Dictionary
			if(diagDict.has(key)):
				var dialogueList = diagDict[key] as Array
				$Interfaces/Dialogue.startDialogue(dialogueList)
				
				if(trigger.haltPlayer):
					emit_signal('interaction', 'Wait')
		elif trigger is ChangeLevelTrigger:
			LevelManager.goto_scene("res://Levels/%s.tscn" % trigger.levelName)


func _on_dialogue_done():
	emit_signal('interaction', 'Idle')


func _on_player_caught(type: String):
	$Interfaces/FadePanel.color = Color.black
	$Interfaces/FadePanel.visible = true
	targetCG = type
	$Interfaces/CGTimer.start() 


func _on_player_can_hide(body: Node, place: Node, isIn: bool):
	if(body.name == "Player"):
		if(isIn):
			activeHidingPlace = place
			place.highlight(true)
			emit_signal("action_available", "CanHide")
		else:
			activeHidingPlace = null
			place.highlight(false)
			emit_signal("action_available", "CannotHide")


enum { Found, Hidden, Search }
func _is_player_detected() -> int:
	var anyChasing = false
	var anySearching = false
	for enemy in enemiesList:
		if(enemy.current_state != null):
			if(enemy.current_state.name == "Chase"):
				anyChasing = true
			elif (enemy.current_state.name == "Search"):
				anySearching = true
	
	return Found if anyChasing else Search if anySearching else Hidden


func _on_player_state_change(state: String):
	if state == "Hide":
		$World/Player.z_index = 5
		if activeHidingPlace != null:
			activeHidingPlace.highlight(false)
			activeHidingPlace.modulate = Color(1, 1, 1, 0.7)
	else:
		$World/Player.z_index = 15
		if activeHidingPlace != null:
			activeHidingPlace.highlight(true)
			activeHidingPlace.modulate = Color.white


func _transition_to_CG():
	if(targetCG == "chimera"):
		get_tree().change_scene("res://Scenes/GameOver/ChimeraEnd.tscn")
