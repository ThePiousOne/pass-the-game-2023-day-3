extends CharacterBody2D

@onready var engine_particles: GPUParticles2D = $engine_particles
var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

@export var health := 20
var iframe := false
var dead := false

const min_speed := 300.0
const max_speed := 400.0
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

@export var killer_speed: float = 300
var can_shoot = false

signal Damaged

func _set_current_speed(value):
	if value < min_speed:
		value = min_speed
		
	elif value > max_speed:
		value = max_speed
		

	_current_speed = value
	#engine_particles.amount = int(remap(_current_speed, min_speed, max_speed, p_amount[0], p_amount[1]))
#	engine_particles.process_material.scale_max = remap(_current_speed, min_speed, max_speed, p_scale_max[0], p_scale_max[1])
#	engine_particles.process_material.initial_velocity_max = remap(_current_speed, min_speed, max_speed, p_velocity_max[0], p_velocity_max[1])
	#engine_particles.lifetime = remap(_current_speed, min_speed, max_speed, p_lifetime[0], p_lifetime[1])
	


func _ready():
	current_speed = min_speed
	engine_particles.amount = 128
	engine_particles.lifetime = 1.0
	Damaged.emit(health)

func _process(_delta):
	look_at(get_global_mouse_position())

func _physics_process(_delta):

	Globals.player_location = global_position

	if Input.is_action_pressed("shoot"):
		current_speed = max_speed
		if can_shoot:
			handle_shooting()
		$engine_particles.emitting = false
		$engine_particles2.emitting = true
	else:
		current_speed = min_speed
		$engine_particles.emitting = true
		$engine_particles2.emitting = false

	# Propel the spaceship towards the mouse
	velocity += transform.x * acceleration

	# Clamp to max speed
	if velocity.length() > current_speed:
		velocity = velocity.move_toward(velocity.normalized() * current_speed, acceleration)

	move_and_slide()
#	print(str(velocity))
	
#	if abs(velocity.x) >= killer_speed or abs(velocity.y) >= killer_speed:
	if velocity.length() >= killer_speed:
		$sprite.modulate = Color(0.96, 0.30, 0.49)
#		$ShootCooldown.wait_time = 0.05
		$SpeedHitbox/CollisionShape2D.disabled = false
		can_shoot = true
	else:
		$sprite.modulate = Color(1,1,1)
#		$ShootCooldown.wait_time = 0.3
		$SpeedHitbox/CollisionShape2D.disabled = true
		can_shoot = false

	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var collision_normal := collision.get_normal()
		velocity += collision_normal * current_speed / 2
		Audio.play_sound("hit")
		Globals.shake_screen()
		if collision.get_collider().is_in_group("Enemy") and !can_shoot:
			hurt()

func hurt():
	health -= 1
	if health <= 0:
		dead = true
		Audio.play_sound("enemy-die")
		$CollisionPolygon2D.set_deferred("disabled", true)
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property($sprite, "scale", Vector2(2, 2), 0.5)
		tween.tween_property($sprite, "rotation_degrees", 90, 0.5)
		tween.tween_property($sprite, "modulate:a", 0, 0.5)
		await tween.finished
		queue_free()
	else:
		Damaged.emit(health)
		iframe = true
		Audio.play_sound("enemy-hit")
		var tween = create_tween()
		tween.tween_property($sprite, "modulate:a", 0, 0).set_delay(0.2)
		tween.tween_property($sprite, "modulate:a", 1, 0).set_delay(0.2)
		tween.set_loops(3)
		await tween.finished
		iframe = false

func handle_shooting():
	
	if !$ShootCooldown.time_left:
		$ShootCooldown.start()
		shoot()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $ShootFrom.global_position
	bullet.global_rotation = global_rotation
	get_tree().get_root().add_child(bullet)
	Audio.play_sound("shoot")
	var tween = create_tween()
#	tween.tween_property($sprite, "position:x", 3, 0.05).as_relative()
#	tween.tween_property($sprite, "position:x", -3, 0.05).as_relative()
#	velocity = velocity.move_toward(Vector2.ZERO, velocity.length() / 2)
