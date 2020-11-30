extends OnGround

# pixels/sec
export (float) var SPEED:= 125
export (float) var ACCELERATION:= 1
export var hold_time: float = 3

var targetPosition: Vector2
var elapsed: float
var patrol_index: int = 0

func enter(host: Character) -> void:
	host.get_node('AnimatedSprite').play('Idle')
	host.snap_enable = true
	elapsed = 0
	patrol_index = 0
	targetPosition = _get_next_patrol_point(host)
	host.get_node('AnimatedSprite').speed_scale = 0.75
	host.get_node('Footsteps/FootstepTimer').wait_time = 0.5
	host.get_node('Footsteps/FootstepPlayer').play()
	host.get_node('Footsteps/FootstepTimer').start()


func exit(host: Character) -> void:
	host.snap_enable = false
	host.get_node('AnimatedSprite').speed_scale = 1
	host.get_node('Footsteps/FootstepTimer').wait_time = 0.35


#warning-ignore:unused_argument
func update(host: Character, delta: float) -> void:
#	if host.has_target:
#		emit_signal('finished', 'Chase')
#		return
	
	elapsed += delta
	
	if (elapsed > hold_time):
		targetPosition = _get_next_patrol_point(host)
		elapsed = 0
		host.get_node('Footsteps/FootstepPlayer').play()
		host.get_node('Footsteps/FootstepTimer').start()
	
	moveTo(host, targetPosition)


func moveTo(host:Character, point: Vector2) -> void:
	if abs(host.position.x - point.x) > 200:
		var target_direction = (point - host.position).normalized() 
		update_look_direction(host, Vector2(int(round(target_direction.x)), 0), 1)
		host.get_node('AnimatedSprite').play('Move')
		move(host, target_direction, SPEED, ACCELERATION)
		elapsed = 0
	else:
		host.get_node('AnimatedSprite').play('Idle')
		if host.patrol.directions:
			var lookDir = 1 if  host.patrol.directions.size() > patrol_index && host.patrol.directions[patrol_index] == "right" else -1
			update_look_direction(host, Vector2(lookDir, 0), 1)
		host.velocity.x = 0
		host.get_node('Footsteps/FootstepTimer').stop()

func _get_next_patrol_point(host: Character) -> Vector2:
	var next = host.patrol_path.get_point_position(patrol_index)
	patrol_index = patrol_index + 1 if patrol_index < host.patrol_path.get_point_count() - 1 else 0
	return next
