extends ColorRect

signal fade_complete()

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_animation_complete")
	var fade = $AnimationPlayer.get_animation("FadeIn")

func fadeIn():
	var temp = $AnimationPlayer
	$AnimationPlayer.play("FadeIn");
	
func fadeOut():
	$AnimationPlayer.play("FadeOut");
	

func _animation_complete(name: String): 
	emit_signal("fade_complete")
