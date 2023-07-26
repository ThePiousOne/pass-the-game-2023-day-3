extends CharacterBody2D

@onready var engine_particles: GPUParticles2D = $engine_particles

const min_speed := 50.0
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
	engine_particles.amount = int(remap(_current_speed, min_speed, max_speed, p_amount[0], p_amount[1]))
	engine_particles.process_material.scale_max = remap(_current_speed, min_speed, max_speed, p_scale_max[0], p_scale_max[1])
	engine_particles.process_material.initial_velocity_max = remap(_current_speed, min_speed, max_speed, p_velocity_max[0], p_velocity_max[1])
	engine_particles.lifetime = remap(_current_speed, min_speed, max_speed, p_lifetime[0], p_lifetime[1])
	


func _ready():
	current_speed = min_speed


func _process(_delta):
	look_at(get_global_mouse_position())

func _physics_process(_delta):

	if Input.is_action_just_pressed("ui_up"):
		current_speed += 50
	if Input.is_action_just_pressed("ui_down"):
		current_speed -= 50

	# Propel the spaceship towards the mouse
	velocity += transform.x * acceleration

	# Clamp to max speed
	if velocity.length() > current_speed:
		velocity = velocity.normalized() * current_speed

	move_and_slide()

	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var collision_normal := collision.get_normal()
		velocity += collision_normal * current_speed / 2
		Audio.play_sound("hit")
		Globals.shake_screen()


