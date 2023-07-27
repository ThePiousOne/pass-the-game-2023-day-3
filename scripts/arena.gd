extends Node2D


func _process(delta):
	Globals.total_seconds += delta
	%TotalTime.text = Globals.get_formated_time(Globals.total_seconds)


func _on_player_damaged(health):
	%Health.text = str(health)
