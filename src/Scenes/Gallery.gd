extends Node2D


var cg_index: int = 0
var is_playing: bool = false
var fade_index: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Interface/Panel/BackButton.connect('pressed', self, '_onBackPressed')
	
	# npc buttons
	$Interface/Panel/TabContainer/NPCs/GridContainer/NPC.connect("pressed", self, "_start_scene", [0])
	$Interface/Panel/TabContainer/NPCs/GridContainer/NPC_bonus.connect("pressed", self, "_start_scene", [2])
	$Interface/Panel/TabContainer/NPCs/GridContainer/Chimera.connect("pressed", self, "_start_scene", [4])
	
	# boss buttons
	$Interface/Panel/TabContainer/Boss/GridContainer/Boss1.connect("pressed", self, "_start_scene", [6])
	$Interface/Panel/TabContainer/Boss/GridContainer/Boss2.connect("pressed", self, "_start_scene", [8])
	$Interface/Panel/TabContainer/Boss/GridContainer/Boss3.connect("pressed", self, "_start_scene", [10])
	$Interface/Panel/TabContainer/Boss/GridContainer/Boss4.connect("pressed", self, "_start_scene", [12])
	
	# nav buttons
	$Controls/HBoxContainer/Return.connect("pressed", self, "_return_to_select")
	$Controls/HBoxContainer/Play.connect("pressed", self, "_play_scene")
	$Controls/HBoxContainer/Pause.connect("pressed", self, "_pause_scene")
	$Controls/HBoxContainer/Next.connect("pressed", self, "_next_scene")
	$Controls/HBoxContainer/Previous.connect("pressed", self, "_previous_scene")
	
	$AdvanceTimer.connect("timeout", self, "_next_scene")
	#$FadeTween.connect("tween_completed", self, "_fade_done")
	
	$Scenes.visible = false
	$Controls/HBoxContainer.visible = false
	$Interface/Panel.visible = true


func _onBackPressed(): 
	LevelManager.goto_scene("res://Scenes/MainMenu.tscn")
	

func _fade_done(object: Object, key: NodePath):
	var cgs = $Scenes.get_children()
	for cg in cgs:
		cg.visible = false
	
	cgs[cg_index].visible = true


func _start_scene(index: int):
	cg_index = index
	
	var cgs = $Scenes.get_children()
	for cg in cgs:
		cg.visible = false
	
	cgs[cg_index].visible = true
	
	$Interface/Panel.visible = false
	$Scenes.visible = true
	$Controls/HBoxContainer.visible = true
	_pause_scene()


func _play_scene():
	is_playing = true
	$Controls/HBoxContainer/Play.visible = false
	$Controls/HBoxContainer/Pause.visible = true
	$AdvanceTimer.start()


func _pause_scene():
	is_playing = false
	$Controls/HBoxContainer/Play.visible = true
	$Controls/HBoxContainer/Pause.visible = false
	$AdvanceTimer.stop()


func _next_scene():
	fade_index = cg_index
	
	cg_index += 1
	if cg_index > ($Scenes.get_child_count() - 1):
		cg_index = 0
	
	_fade_image()


func _previous_scene():
	fade_index = cg_index
	
	cg_index -= 1
	if cg_index < 0:
		cg_index = $Scenes.get_child_count() - 1
	
	_fade_image()


func _return_to_select():
	_pause_scene()
	$FadeTween.remove_all()
	$Scenes.visible = false
	$Controls/HBoxContainer.visible = false
	$Interface/Panel.visible = true


func _fade_image():
	$FadeTween.remove_all()
	
	var cgs = $Scenes.get_children()
	
	for cg in cgs:
		cg.visible = false
	
	cgs[cg_index].visible = true
	cgs[fade_index].visible = true
	cgs[cg_index].modulate = Color.white
	cgs[fade_index].modulate = Color.white
	
	if fade_index < cg_index:
		cgs[cg_index].modulate = Color.transparent
		$FadeTween.interpolate_property(cgs[cg_index], "modulate", Color.transparent, Color.white, 1.0)
	else:
		$FadeTween.interpolate_property(cgs[fade_index], "modulate", Color.white, Color.transparent, 1.0)
	
	$FadeTween.start()
