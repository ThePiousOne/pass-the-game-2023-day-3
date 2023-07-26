extends Node

var total_seconds := 0.0
var player_location = null


func reset_game():
	total_seconds = 0.0
	player_location = null


func shake_screen(duration = 0.1, frequency = 12, amplitude_param = 10):
	var camera = get_viewport().get_camera_2d()
	if camera and camera.has_method("shake_screen"):
		camera.shake_screen(duration, frequency, amplitude_param)


func get_formated_time(time_seconds: float, with_ms: bool = false) -> String:
	var ms = floor(fmod(time_seconds * 1000.0, 1000.0))
	var seconds = floor(fmod(time_seconds, 60.0))
	var minutes = floor(time_seconds / 60.0)

	if with_ms:
		return "%02d:%02d.%03d" % [minutes, seconds, ms]

	return "%02d:%02d" % [minutes, seconds]
