extends OnGround

signal player_caught()

func enter(host: Character):
	var bodies = $GrabArea.get_overlapping_bodies();
	var hasPlayer = false;
	for body in bodies:
		if(body.name == "Player"):
			hasPlayer = true
	
	if(hasPlayer):
		emit_signal("player_caught")
