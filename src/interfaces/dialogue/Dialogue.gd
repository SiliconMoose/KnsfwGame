extends Panel

var currentDialogue: Array
var index: int

signal dialogue_done()


# Called when the node enters the scene tree for the first time.
func _ready():
	showPortrait("default")
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed('interact'):
		if(index < currentDialogue.size()):
			showNext()
		else:
			endDialogue()


func startDialogue(dialogueSet: Array):
	currentDialogue = dialogueSet
	index = 0;
	
	showNext()

func endDialogue():
	visible = false
	emit_signal("dialogue_done")


func showNext():
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
		_:
			$PortraitBox/PortraitNeutral.visible = true


func showDialogue(text: String, hasNext: bool):
	$DialogueBox/Label.text = text
	$DialogueBox/NextArrow.visible = hasNext
