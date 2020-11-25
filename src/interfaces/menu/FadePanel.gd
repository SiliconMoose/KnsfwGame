extends ColorRect
class_name FadePanel


func fadeIn():
	$AnimationPlayer.play("FadeIn");
	
func fadeOut():
	$AnimationPlayer.play("FadeOut");
