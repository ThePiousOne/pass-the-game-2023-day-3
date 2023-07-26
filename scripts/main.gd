extends Node2D

@onready var fade_rect: ColorRect = $CanvasLayer/FadeRect

func _on_toggle_fullscreen(fullscreen):
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _ready():
	randomize()

	Events.toggle_fullscreen.connect(_on_toggle_fullscreen)
	Events.change_scene.connect(_on_change_scene)


func _on_change_scene(scene: Events.SCENE):
	
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 1, 0.4)
	await tween.finished


	for child in $Scene.get_children():
		$Scene.remove_child(child)
		child.queue_free()

	var new_scene_path
	match scene:
		Events.SCENE.TITLE:
			new_scene_path = "res://scenes/title.tscn"
		Events.SCENE.LEVEL:
			new_scene_path = "res://scenes/level.tscn"
			Globals.reset_game()

	var new_scene = load(new_scene_path).instantiate()
	new_scene.process_mode = PROCESS_MODE_DISABLED
	$Scene.add_child(new_scene)

	tween = create_tween()
	tween.tween_property(fade_rect, "color", Color(0, 0, 0, 0), 0.4)
	await tween.finished

	new_scene.process_mode = PROCESS_MODE_INHERIT



func _process(_delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		Events.toggle_fullscreen.emit(
			DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
		)
