extends Node

var loader: ResourceInteractiveLoader
var wait_frames: int
var time_max: int = 100 # msec
var loading_screen_scene: Resource = preload('res://interfaces/loading/LoadingScreen.tscn')
var loading_screen: Node
var root: Node
var current_resource
var scene_path = '' setget set_scene_path, get_scene_path


func _ready() -> void:
	root = get_tree().get_root()


func show_error() -> void:
	print('Scene was not loaded')


func set_scene_path(path: String) -> void:
	scene_path = 'res://%s.tscn' % path


func get_scene_path() -> String:
	return scene_path


func goto_scene(path: String, hideSpinner: bool = false) -> void: # game requests to switch to this scene
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		show_error()
		return
	set_process(true)

	root.get_child(root.get_child_count() -1).queue_free() # get rid of the old scene
	
	# start your "loading..." animation
	loading_screen = loading_screen_scene.instance()	
	loading_screen.get_child(2).visible = !hideSpinner
	root.add_child(loading_screen)
	wait_frames = 1


#warning-ignore:unused_argument
func _process(time: float) -> void:
	if loader == null:
		 # no need to process anymore
		set_process(false)
		return
		
	if wait_frames > 1: # wait for frames to let the "loading" animation show up
		wait_frames -= 1
		return
		
	var t := OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control for how long we block this thread

		# poll your loader
		var poll = loader.poll()

		if poll == ERR_FILE_EOF: # Finished loading.
			current_resource = loader.get_resource()
			loader = null
			loading_screen.set_resource(current_resource)
			break
		elif poll == OK:
			break
		else: # error during loading
			show_error()
			loader = null
			break

func set_new_scene(scene_resource: Resource) -> void:
	var scene = scene_resource.instance()
	get_node('/root').add_child(scene)


func start_level(level: String):
	GameManager.currentLevel = level
	LevelManager.goto_scene("res://Levels/%s.tscn" % level)
