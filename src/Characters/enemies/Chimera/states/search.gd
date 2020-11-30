extends OnGround

# pixels/sec
export (float) var SPEED:= 125
export (float) var ACCELERATION:= 1
export var SearchTime: float = 10

var targetPosition: Vector2
var targetTime: float
var timeWaited: float
var elapsed: float

func enter(host: Character) -> void:
	host.get_node('AnimatedSprite').play('Idle')
	host.snap_enable = true
	targetTime = 3.0
	timeWaited = 0
	elapsed = 0
	targetPosition = host.target_position
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
	if host.has_target:
		emit_signal('finished', 'Chase')
		return
	
	timeWaited += delta
	elapsed += delta
	
	if(elapsed > SearchTime):
		emit_signal('finished', 'Patrol')
		return
	
	if (timeWaited > targetTime):
		var newX = (randi() % 1000) + 500
		newX *= 1 if (randi() % 2 == 0) else -1
		targetPosition = Vector2(targetPosition.x + newX, targetPosition.y)
		targetTime = (randf() * 2) + 2
		timeWaited = 0
		host.get_node('Footsteps/FootstepPlayer').play()
		host.get_node('Footsteps/FootstepTimer').start()
	
	moveTo(host, targetPosition)


func moveTo(host:Character, point: Vector2) -> void:
	if host.position.distance_to(point) > 200:
		var target_direction = (point - host.position).normalized() 
		update_look_direction(host, Vector2(int(round(target_direction.x)), 0), 1)
		host.get_node('AnimatedSprite').play('Move')
		move(host, target_direction, SPEED, ACCELERATION)
	else:
		host.get_node('AnimatedSprite').play('Idle')
		host.velocity.x = 0
		host.get_node('Footsteps/FootstepTimer').stop()
