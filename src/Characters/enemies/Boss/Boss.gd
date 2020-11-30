#warning-ignore-all:unused_class_variable
extends Character

class_name Boss

signal player_caught(type)

# cache
onready var Physics2D: Node2D = $Physics2D

var has_target: bool = false
var player_hidden: bool = false
var target_position: Vector2 = Vector2()
var start_position: Vector2 = position

const TARGET_MIN_DISTANCE: float = 800.0
const FOLLOW_RANGE: float = 2000.0
const ATTACK_RANGE: float = 900.0
const BACK_DETECT_RANGE: float = 600.0

export var phase_1_patrol: String
export var phase_2_patrol: String
export var phase_3_patrol: String

var currentPhase: int = 1

var patrol_path: Curve2D
var patrol: Node2D

func _ready() -> void:
	# Signals
	$CooldownTimer.connect('timeout', self, '_on_Cooldown_timeout')
	$CooldownBar.set_duration($CooldownTimer.wait_time)
	$States/Catch.connect("player_caught", self, "_on_player_caught")
	$Footsteps/FootstepTimer.connect("timeout", self, "_on_footstep")
	
	var player = get_tree().get_root().get_node('Game/World/Player')
	if player != null:
		player.connect('player_position_changed', self, '_on_player_position_changed')
		player.connect('state_changed', self, '_on_player_state_changed')
	
	set_phase(1)
	
	var startState = "Patrol" if patrol_path != null else "Idle"
	._initialize_state(startState)


# Delegate the call to theer
func _physics_process(delta: float) -> void:
	current_state.update(self, delta)
	Physics2D.compute_gravity(self, delta)


func start_cooldown():
	$CooldownTimer.start()
	$CooldownBar.start()


func set_phase(phase: int):
	currentPhase = phase
	
	if(phase == 1):
		patrol = get_tree().get_root().get_node_or_null('Game/World/PatrolPaths/'+phase_1_patrol)
		patrol_path = patrol.curve
	elif phase == 2:
		patrol = get_tree().get_root().get_node_or_null('Game/World/PatrolPaths/'+phase_2_patrol)
		patrol_path = patrol.curve
	elif phase == 3:
		patrol = get_tree().get_root().get_node_or_null('Game/World/PatrolPaths/'+phase_3_patrol)
		patrol_path = patrol.curve
		
	$States/Patrol.patrol_index = 0
	$States/Patrol.elapsed = 1000;
	$States/Patrol.targetPosition = $States/Patrol._get_next_patrol_point(self)



func _on_player_position_changed(new_position: Vector2) -> void:
	target_position = new_position
	var target_direction = (target_position - position).normalized()
	var isFacingTarget = look_direction.x * target_direction.x > 0
	var detectRange = FOLLOW_RANGE if isFacingTarget else BACK_DETECT_RANGE
	has_target = position.distance_to(target_position) <= FOLLOW_RANGE && !player_hidden
	
func _on_player_state_changed(state: String) -> void:
	player_hidden = state == "Hide"


func _on_player_caught():
	emit_signal("player_caught", "boss")
	
	
func _on_footstep():
	$Footsteps/FootstepPlayer.play()
