extends Motion 


func enter(host: Player) -> void:
	host.get_node('AnimatedSprite').play('Hide')
	host.velocity = Vector2(0, 0)


func handle_input(host: Player, event: InputEvent) -> InputEvent:
	return .handle_input(host, event)
