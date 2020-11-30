extends ColorRect

signal fade_complete()

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_animation_complete")

func fadeIn():
	$AnimationPlayer.play("FadeIn");
	
func fadeOut():
	$AnimationPlayer.play("FadeOut");
	

func _animation_complete(name: String):
	if name == "FadeIn":
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	emit_signal("fade_complete")
