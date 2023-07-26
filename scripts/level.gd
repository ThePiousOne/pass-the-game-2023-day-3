extends Node2D


@onready var fade_rect: ColorRect = $CanvasLayer/FadeRect
var menu_stack = []



func _ready():
	Events.menu_summoned.connect(_on_menu_summoned)
	Events.menu_dismissed.connect(_on_menu_dismissed)


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if menu_stack.is_empty():			
			Events.menu_summoned.emit(Events.MENU.PAUSE)
		else:
			Events.menu_dismissed.emit(menu_stack[-1])


func _on_menu_summoned(menu_):
	var menu
	match menu_:
		Events.MENU.PAUSE: menu = %PauseMenu
		Events.MENU.SETTINGS: menu = %SettingsMenu

	if menu_stack.is_empty():
		$Arena.process_mode = PROCESS_MODE_DISABLED
	else:
		menu_stack[-1].process_mode = PROCESS_MODE_DISABLED
		tween_out_menu(menu_stack[-1])
	menu_stack.append(menu)


	menu.show()
	menu.process_mode = PROCESS_MODE_INHERIT

	if menu.has_method("on_show"):
		menu.on_show()

	await tween_in_menu(menu)



func _on_menu_dismissed(menu):
	menu.process_mode = PROCESS_MODE_DISABLED
	menu_stack.pop_back()
	tween_out_menu(menu)
	
	if !menu_stack.is_empty():
		menu_stack[-1].show()
		menu_stack[-1].process_mode = PROCESS_MODE_INHERIT
	
		if menu_stack[-1].has_method("on_resume"):
			menu_stack[-1].on_resume()

		await tween_in_menu(menu_stack[-1])
	else:
		$Arena.process_mode = PROCESS_MODE_INHERIT

	

	




func tween_in_menu(menu):
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(fade_rect, "color:a", 0.9, 0.4)
	tween.tween_property(menu, "global_position", Vector2(menu.global_position.x, 0), 0.4).set_trans(Tween.TRANS_BACK)
	await tween.finished

func tween_out_menu(menu):
	var tween = create_tween()
	tween.set_parallel()
	if menu_stack.is_empty():
		tween.tween_property(fade_rect, "color:a", 0, 0.4)
	tween.tween_property(menu, "global_position", Vector2(menu.global_position.x, 360), 0.4).set_trans(Tween.TRANS_BACK) 
	await tween.finished
