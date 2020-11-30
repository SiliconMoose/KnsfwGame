extends OnGround


func enter(host: Player) -> void:
	host.get_node('AnimatedSprite').play('Idle')
	host.snap_enable = true
	host.velocity.x = 0


func exit(host: Player) -> void:
	host.snap_enable = false


#warning-ignore:unused_argument
func update(host: Player, delta: float) -> void:
	var isHiding = Input.is_action_pressed('hide')
	if isHiding && host.can_hide:
		emit_signal('finished', 'Hide')
		return
		
	var input_direction: Vector2 = get_input_direction()
	if input_direction.x:
		emit_signal('finished', 'Move')

	if not host.is_grounded:
		emit_signal('finished', 'Fall')
