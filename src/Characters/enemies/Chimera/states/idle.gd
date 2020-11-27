extends OnGround


func enter(host) -> void:
	host.get_node('AnimatedSprite').play('Idle')
	host.snap_enable = true
	host.velocity.x = 0


func exit(host) -> void:
	host.snap_enable = false


#warning-ignore:unused_argument
#warning-ignore:unused_argument
func update(host, delta: float) -> void:
	if not host.is_grounded:
		emit_signal('finished', 'Fall')
		
	if host.has_target:
		emit_signal('finished', 'Chase')
