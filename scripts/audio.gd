extends Node2D

func play_sound(name_):
	if name == "":
		return
		
	var sound = get_node(name_)
	var cooldownTimer : Timer = sound.get_node_or_null(^"CooldownTimer")
	if cooldownTimer:
		if cooldownTimer.is_stopped():
			cooldownTimer.start()
		else:
			return
		
	sound.play()
	
