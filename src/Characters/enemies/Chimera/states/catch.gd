extends OnGround

signal player_caught()

export var catchSound:AudioStream

func enter(host: Character):
	play_sound(host, catchSound)
	emit_signal("player_caught")
