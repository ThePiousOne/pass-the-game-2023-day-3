class_name Bullet
extends Area2D

@export var speed := 900.0
var frames := 0

func _physics_process(delta):
	frames += 1
	if frames >= 120:
		call_deferred("queue_free")
	position += transform.x * speed * delta
