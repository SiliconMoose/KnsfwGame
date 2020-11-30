extends Node2D

signal interaction(type)

signal action_available(type)

export var levelId: String

var enemiesList: Array
var targetCG: String

var activeHidingPlace: HidingPlace
var activeDoor: Door

# Called when the node enters the scene tree for the first time.
func _ready():
	var global_l = $Bounds/Left.global_position
	var global_r = $Bounds/Right.global_position
	$World/Player/Camera.limit_left = global_l.x
	$World/Player/Camera.limit_right = global_r.x
	
	
	$Interfaces/Dialogue.connect("dialogue_done", self, "_on_dialogue_done")
	$Interfaces/Dialogue.visible = false
	
	$World/Player.connect("state_changed", self, "_on_player_state_change")
	$World/Player.connect("interact", self, "_on_player_interact")
	
	var triggers = $World/Environment/Triggers.get_children()
	for trigger in triggers:
		trigger.connect('body_entered', self, "_on_player_trip_trigger", [trigger])

	enemiesList = $World/Enemies.get_children()
	for enemy in enemiesList:
		enemy.connect('player_caught', self, "_on_player_caught")
		
	var interacts = $World/Interactables.get_children()
	for place in interacts:
		place.connect('body_entered', self, "_on_player_can_interact", [place, true])
		place.connect('body_exited', self, "_on_player_can_interact", [place, false])
	
	$Interfaces/CGTimer.connect("timeout", self, "_transition_to_CG")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Interfaces/FadePanel.visible = true
	$Interfaces/FadePanel/AnimationPlayer.play("FadeIn")
	
	UserDataManager.set_data("save-file", { level = levelId })
	UserDataManager.save_data()


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
		if (trigger is DialogueTrigger && !trigger.isTripped):
			var key = trigger.DialogueKey as String
			trigger.isTripped = true
			
			var diagDict = $Interfaces/Dialogue.dict as Dictionary
			if(diagDict.has(key)):
				var dialogueList = diagDict[key] as Array
				$Interfaces/Dialogue.startDialogue(dialogueList)
				
				if(trigger.haltPlayer):
					emit_signal('interaction', 'Wait')
		elif (trigger is InstructionTrigger && !trigger.isTripped):
			trigger.isTripped = true
			$Interfaces/Instruction.show_instruction(trigger.Instruction)
		elif trigger is ChangeLevelTrigger:
			LevelManager.start_level(trigger.levelName)


func _on_dialogue_done():
	emit_signal('interaction', 'Idle')


func _on_player_caught(type: String):
	$Interfaces/FadePanel.color = Color.black
	$Interfaces/FadePanel.visible = true
	targetCG = type
	$Interfaces/CGTimer.start() 


func _on_player_can_interact(body: Node, place: Node, isIn: bool):
	if(body.name == "Player"):
		if place is HidingPlace:
			if(isIn):
				activeHidingPlace = place
				place.highlight(true)
				emit_signal("action_available", "CanHide")
			else:
				activeHidingPlace = null
				place.highlight(false)
				emit_signal("action_available", "CannotHide")
		elif place is Door:
			if(isIn):
				activeDoor = place
				place.show_icon(true)
				emit_signal("action_available", "CanUseDoor")
			else:
				activeDoor = null
				place.show_icon(false)
				emit_signal("action_available", "CannotUseDoor")


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


func _on_player_interact(type: String):
	if type == "Door":
		var level = activeDoor.ConnectedLevel
		LevelManager.start_level(level)


func _transition_to_CG():
	if(targetCG == "chimera"):
		LevelManager.goto_scene("res://Scenes/GameOver/ChimeraEnd.tscn")
	elif(targetCG == "boss"):
		LevelManager.goto_scene("res://Scenes/GameOver/BossEnd.tscn")
