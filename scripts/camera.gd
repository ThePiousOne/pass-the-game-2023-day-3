extends Camera2D

var amplitude := 0


func shake_screen(duration = 0.1, frequency = 12, amplitude_param = 10):
	self.amplitude = amplitude_param
	$DurationTimer.wait_time = duration
	$FrequencyTimer.wait_time = 1 / float(frequency)
	$DurationTimer.start()
	$FrequencyTimer.start()

	_shake()


func _shake():
	var target = Vector2(randi_range(-amplitude, amplitude), randi_range(-amplitude, amplitude))
	var tween = create_tween()
	tween.tween_property(self, "offset", target, $FrequencyTimer.wait_time).set_trans(Tween.TRANS_SINE).set_ease(
		Tween.EASE_IN_OUT
	)


func _reset():
	var tween = create_tween()
	tween.tween_property(self, "offset", Vector2.ZERO, $FrequencyTimer.wait_time).set_trans(Tween.TRANS_SINE).set_ease(
		Tween.EASE_IN_OUT
	)

	self.amplitude = 0


func _on_duration_timer_timeout():
	$FrequencyTimer.stop()
	_reset()


func _on_frequency_timer_timeout():
	_shake()
