#warning-ignore-all:unused_class_variable
extends Character

class_name Alt_Player

signal player_caught(type)

# cache
onready var Physics2D: Node2D = $Physics2D

var has_target: bool = false
var player_hidden: bool = false
var target_position: Vector2 = Vector2()
var start_position: Vector2 = position

const TARGET_MIN_DISTANCE: float = 600.0
const FOLLOW_RANGE: float = 1500.0
const ATTACK_RANGE: float = 700.0
const BACK_DETECT_RANGE: float = 400.0

export var patrol_name: String

var patrol_path: Curve2D

func _ready() -> void:
	# Signals
	$Footsteps/FootstepTimer.connect("timeout", self, "_on_footstep")
	
	var path = get_tree().get_root().get_node_or_null('Game/World/PatrolPaths/'+patrol_name)
	patrol_path = path.curve
	
	._initialize_state()


# Delegate the call to theer
func _physics_process(delta: float) -> void:
	current_state.update(self, delta)
	Physics2D.compute_gravity(self, delta)


func _on_player_position_changed(new_position: Vector2) -> void:
	target_position = new_position
	var target_direction = (target_position - position).normalized()
	var isFacingTarget = look_direction.x * target_direction.x > 0
	var detectRange = FOLLOW_RANGE if isFacingTarget else BACK_DETECT_RANGE
	has_target = position.distance_to(target_position) <= detectRange && !player_hidden
	
func _on_player_state_changed(state: String) -> void:
	player_hidden = state == "Hide"


func _on_player_caught():
	emit_signal("player_caught", "chimera")
	
	
func _on_footstep():
	$Footsteps/FootstepPlayer.play()
