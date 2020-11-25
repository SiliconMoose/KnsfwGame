extends Area2D

export var DialogueKey: String

var isTripped:bool = false

func _body_entered(body: Node):
	print(body)
	if (body.name == "Player"):
		var dialogue = body.get_node("Dialogue") as Panel
		dialogue.visible = true;
	
