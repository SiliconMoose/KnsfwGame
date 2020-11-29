extends OnGround

signal player_caught()

export var catchSound:AudioStream

func enter(host: Character):
	var bodies = $GrabArea.get_overlapping_bodies();
	var hasPlayer = false;
	for body in bodies:
		if(body.name == "Player"):
			hasPlayer = true
			
	if(hasPlayer):
		play_sound(host, catchSound)
		emit_signal("player_caught")
