extends Node2D

@export var acceleration: float = 5.0
@export var max_speed: float = 100.0 
var speed := Vector2.ZERO

func _ready():
	pass

func _process(delta):
	# Set spaceship sprite to face mouse, same with the spacecraft's engine particles
	$sprite.rotation = get_local_mouse_position().angle()

func _physics_process(delta):
	# Propel the spaceship towards the mouse
	var direction = get_local_mouse_position().normalized()
	speed += direction * acceleration
	# Clamp to max speed
	if speed.length() > max_speed:
		speed = speed.normalized() * max_speed
	self.position += speed * delta
