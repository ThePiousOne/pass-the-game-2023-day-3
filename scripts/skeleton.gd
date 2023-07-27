extends CharacterBody2D

var speed = 15
var iframe := false
var dead := false
var health := 2


func _physics_process(_delta):
	if Globals.player_location:
		velocity = (Globals.player_location - global_position).normalized() * speed
		move_and_slide()

func hurt():
	health -= 1
	if health <= 0:
		dead = true
		Audio.play_sound("enemy-die")
		$CollisionShape2D.set_deferred("disabled", true)
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property($Sprite2D, "scale", Vector2(2, 2), 0.5)
		tween.tween_property($Sprite2D, "rotation_degrees", 90, 0.5)
		tween.tween_property($Sprite2D, "modulate:a", 0, 0.5)
		await tween.finished
		queue_free()
	else:
		iframe = true
		Audio.play_sound("enemy-hit")
		var tween = create_tween()
		tween.tween_property($Sprite2D, "modulate:a", 0, 0).set_delay(0.1)
		tween.tween_property($Sprite2D, "modulate:a", 1, 0).set_delay(0.1)
		tween.set_loops(1)
		await tween.finished
		iframe = false
			

func _on_hitbox_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if area is Bullet:
		area.queue_free()

	if iframe or dead:
		return
	
	if area is Bullet:
		hurt()

	if area.is_in_group("Player"):
		health = 0
		hurt()
		
