#warning-ignore-all:unused_class_variable
extends Character

class_name Chimera

signal player_caught(type)

# cache
onready var Physics2D: Node2D = $Physics2D

var has_target: bool = false
var target_position: Vector2 = Vector2()

const TARGET_MIN_DISTANCE: float = 600.0
const FOLLOW_RANGE: float = 2000.0
const ATTACK_RANGE: float = 700.0


func _ready() -> void:
	# Signals
	$CooldownTimer.connect('timeout', self, '_on_Cooldown_timeout')
	$CooldownBar.set_duration($CooldownTimer.wait_time)
	$States/Catch.connect("player_caught", self, "_on_player_caught")
	$Footsteps/FootstepTimer.connect("timeout", self, "_on_footstep")
	
	if get_tree().get_root().has_node('Game/World/Player'):
		get_tree().get_root().get_node('Game/World/Player').connect('player_position_changed', self, '_on_player_position_changed')
	
	._initialize_state()


# Delegate the call to theer
func _physics_process(delta: float) -> void:
	current_state.update(self, delta)
	Physics2D.compute_gravity(self, delta)


func start_cooldown():
	$CooldownTimer.start()
	$CooldownBar.start()


var i = 0;
func _on_player_position_changed(new_position: Vector2) -> void:
	target_position = new_position
	has_target = position.distance_to(target_position) <= FOLLOW_RANGE

func _on_player_caught():
	emit_signal("player_caught", "chimera")
	
func _on_footstep():
	$Footsteps/FootstepPlayer.play()
