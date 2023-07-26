extends CharacterBody2D

@onready var engine_particles: GPUParticles2D = $engine_particles
var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

const min_speed := 100.0
const max_speed := 200.0
const p_amount: Array[int] = [30, 128]
const p_scale_max: Array[float] = [0.2, 1.0]
const p_velocity_max: Array[float] = [30.0, 200.0]
const p_lifetime: Array[float] = [0.2, 1.0]


@export var acceleration: float = 5.0

var _current_speed: float = min_speed
@export var current_speed: float :
	set (value):
		_set_current_speed(value)
	get:
		return _current_speed


func _set_current_speed(value):
	if value < min_speed:
		value = min_speed
	elif value > max_speed:
		value = max_speed

	_current_speed = value
	#engine_particles.amount = int(remap(_current_speed, min_speed, max_speed, p_amount[0], p_amount[1]))
	engine_particles.process_material.scale_max = remap(_current_speed, min_speed, max_speed, p_scale_max[0], p_scale_max[1])
	engine_particles.process_material.initial_velocity_max = remap(_current_speed, min_speed, max_speed, p_velocity_max[0], p_velocity_max[1])
	#engine_particles.lifetime = remap(_current_speed, min_speed, max_speed, p_lifetime[0], p_lifetime[1])
	


func _ready():
	current_speed = min_speed
	engine_particles.amount = 128
	engine_particles.lifetime = 1.0


func _process(_delta):
	look_at(get_global_mouse_position())

func _physics_process(_delta):

	Globals.player_location = global_position

	if Input.is_action_pressed("boost"):
		current_speed = max_speed
	else:
		current_speed = min_speed

	if Input.is_action_pressed("shoot") and !$ShootCooldown.time_left:
		$ShootCooldown.start()
		shoot()

	# Propel the spaceship towards the mouse
	velocity += transform.x * acceleration

	# Clamp to max speed
	if velocity.length() > current_speed:
		velocity = velocity.move_toward(velocity.normalized() * current_speed, acceleration)

	move_and_slide()

	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var collision_normal := collision.get_normal()
		velocity += collision_normal * current_speed / 2
		Audio.play_sound("hit")
		Globals.shake_screen()



func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $ShootFrom.global_position
	bullet.global_rotation = global_rotation
	get_tree().get_root().add_child(bullet)
	Audio.play_sound("shoot")
	var tween = create_tween()
	tween.tween_property($sprite, "position:x", 3, 0.05).as_relative()
	tween.tween_property($sprite, "position:x", -3, 0.05).as_relative()
	velocity = velocity.move_toward(Vector2.ZERO, velocity.length() / 2)
