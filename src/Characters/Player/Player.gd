#warning-ignore-all:unused_class_variable
extends Character

class_name Player

signal player_position_changed(new_position)
#warning-ignore:unused_signal
signal player_death

# cache
onready var Physics2D: Node2D = $Physics2D

var previous_position: Vector2 = Vector2()


func _ready() -> void:
	# Signals
	$CooldownTimer.connect('timeout', self, '_on_Cooldown_timeout')
	$CooldownBar.set_duration($CooldownTimer.wait_time)
	
	if get_tree().get_root().has_node('Game'):
		get_tree().get_root().get_node('Game').connect('interaction', self, '_on_interaction')
	
	._initialize_state()


# Delegate the call to theer
func _physics_process(delta: float) -> void:
	current_state.update(self, delta)
	Physics2D.compute_gravity(self, delta)
	if previous_position != position:
		_on_position_changed()


# Catch input
func _input(event: InputEvent) -> void:
	current_state.handle_input(self, event)


func start_cooldown():
	$CooldownTimer.start()
	$CooldownBar.start()


func _on_position_changed():
	previous_position = position
	emit_signal('player_position_changed', position)


func _on_interaction(type: String):
	_change_state(type)
