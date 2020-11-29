extends OnGround

# pixels/sec
export (float) var SPEED:= 125
export (float) var ACCELERATION:= 1

func enter(host: Player) -> void:
	host.get_node('AnimatedSprite').play('Move')
	host.snap_enable = true

	host.get_node('Footsteps/FootstepPlayer').play()
	host.get_node('Footsteps/FootstepTimer').start()

func exit(host: Player) -> void:
	host.snap_enable = false
	host.get_node('Footsteps/FootstepTimer').stop()


#warning-ignore:unused_argument
func update(host: Player, delta: float) -> void:
	var isHiding = Input.is_action_pressed('hide')
	if isHiding && host.can_hide:
		emit_signal('finished', 'Hide')
		return
	
	var input_direction: Vector2 = get_input_direction()
	update_look_direction(host, get_input_direction())
	if not input_direction:
		emit_signal('finished', 'Idle')
	if not host.is_grounded:
		emit_signal('finished', 'Fall')
	
	move(host, input_direction, SPEED, ACCELERATION)
