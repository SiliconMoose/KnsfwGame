extends Panel

var currentDialogue: Array
var index: int
var dict = {}

signal dialogue_done()


# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("res://Data/dialogue.json", file.READ)
	var text = file.get_as_text()
	dict = JSON.parse(text).result
	file.close()
	showPortrait("default")
	
	$DialogueBox/NextArrow.connect("pressed", self, "_on_next_clicked")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('interact') && visible:
		if(index < currentDialogue.size()):
			showNext()
		else:
			endDialogue()


func startDialogue(dialogueSet: Array):
	currentDialogue = dialogueSet
	index = 0;
	$DialogueBox/Instructions.visible = true
	$DialogueBox/Instructions.modulate = Color.white
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	showNext()

func endDialogue():
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	emit_signal("dialogue_done")


func showNext():
	if(index == 1):
		$DialogueBox/AnimationPlayer.play("FadeInstruction")
	
	var dialogue = currentDialogue[index]
	showDialogue(dialogue["text"], index < currentDialogue.size() - 1)
	showPortrait(dialogue["portrait"])
	visible = true
	index += 1


func showPortrait(name: String):
	var portraits = $PortraitBox.get_children()
	for portrait in portraits:
		portrait.visible = false
	
	match (name):
		"default":
			$PortraitBox/PortraitNeutral.visible = true
		"smile":
			$PortraitBox/PortraitSmile.visible = true
		"grin":
			$PortraitBox/PortraitGrin.visible = true
		"question":
			$PortraitBox/PortraitQuestion.visible = true
		"npc_smile":
			$PortraitBox/PortraitNPCSmile.visible = true
		"npc_frown":
			$PortraitBox/PortraitNPCFrown.visible = true
		_:
			$PortraitBox/PortraitNeutral.visible = true


func showDialogue(text: String, hasNext: bool):
	$DialogueBox/Label.text = text


func _on_next_clicked():
	if(index < currentDialogue.size()):
		showNext()
	else:
		endDialogue()
