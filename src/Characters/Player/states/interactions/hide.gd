extends Motion 


func enter(host: Player) -> void:
	host.get_node('AnimatedSprite').play('Hide')
	host.velocity = Vector2(0, 0)


func update(host, delta: float) -> void:
	var isHiding = Input.is_action_pressed('hide')
	if !isHiding:
		emit_signal('finished', 'Idle')
		return


func handle_input(host: Player, event: InputEvent) -> InputEvent:
	return .handle_input(host, event)
