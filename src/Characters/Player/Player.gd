#warning-ignore-all:unused_class_variable
extends Character

class_name Player

signal player_position_changed(new_position)

signal interact(type)

# cache
onready var Physics2D: Node2D = $Physics2D

var previous_position: Vector2 = Vector2()

var can_hide: bool = false
var can_use_door: bool = false
var can_use_statue: bool = false


func _ready() -> void:
	# Signals
	$CooldownTimer.connect('timeout', self, '_on_Cooldown_timeout')
	$CooldownBar.set_duration($CooldownTimer.wait_time)
	$Footsteps/FootstepTimer.connect("timeout", self, "_on_footstep")
	
	var game = get_tree().get_root().get_node('Game')
	if game != null:
		game.connect('interaction', self, '_on_interaction')
		game.connect('action_available', self, '_on_action_available')
	
	_show_icon("Detected_1")
	
	._initialize_state()


func _physics_process(delta: float) -> void:
	current_state.update(self, delta)
	Physics2D.compute_gravity(self, delta)
	if previous_position != position:
		_on_position_changed()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('interact'):
		if can_use_door:
			emit_signal("interact", "Door")
		elif can_use_statue:
			emit_signal("interact", "Statue")
			
	
	current_state.handle_input(self, event)


func start_cooldown():
	$CooldownTimer.start()
	$CooldownBar.start()


func _on_position_changed():
	previous_position = position
	emit_signal('player_position_changed', position)


func _on_interaction(type: String):
	_change_state(type)


func _on_action_available(type: String):
	match type:
		"CanHide":
			can_hide = true
		"CannotHide":
			can_hide = false
		"CanUseDoor":
			can_use_door = true
		"CannotUseDoor":
			can_use_door = false
		"CanUseStatue":
			can_use_statue = true
		"CannotUseStatue":
			can_use_statue = false


func _on_footstep():
	$Footsteps/FootstepPlayer.play()


func _show_icon(name: String):
	var icons = $Icons.get_children()
	for icon in icons:
		icon.visible = icon.name == name
