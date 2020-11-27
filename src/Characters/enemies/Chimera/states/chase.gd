extends OnGround

# pixels/sec
export (float) var SPEED:= 600
export (float) var ACCELERATION:= 1


func enter(host: Chimera) -> void:
	host.get_node('AnimatedSprite').play('Move')


#warning-ignore:unused_argument
func update(host: Chimera, delta: float) -> void:
	if not host.has_target:
		emit_signal('finished', 'Idle')
	else:
		follow(host)


func follow(host: Chimera) -> void:
	var target_direction = (host.target_position - host.position).normalized() 
	update_look_direction(host, Vector2(int(round(target_direction.x)), 0), 1)
	
	if host.position.distance_to(host.target_position) > host.TARGET_MIN_DISTANCE:
		move(host, target_direction, SPEED, ACCELERATION)
	elif host.position.distance_to(host.target_position) <= host.ATTACK_RANGE and host.can_attack:
		emit_signal('finished', 'Catch')
	else:
		emit_signal('finished', 'Idle')
