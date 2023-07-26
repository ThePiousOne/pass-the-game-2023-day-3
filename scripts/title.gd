extends Node2D

var focused_node
var first_ignored := false

@onready var fade_rect: ColorRect = $CanvasLayer/FadeRect

func _ready():
	var tween = create_tween()
	tween.tween_property($Label, "position:y", $Label.position.y - 4, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(
		Tween.TRANS_SINE
	)
	tween.tween_property($Label, "position:y", $Label.position.y + 4, 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(
		Tween.TRANS_SINE
	)
	tween.set_loops()

	if OS.get_name() == "Web":
		%Quit.hide()
	else:
		%Quit.show()
	set_wrap()

	%StartGame.grab_focus()

	Events.menu_dismissed.connect(_on_menu_dismissed)


func _on_menu_dismissed(menu):
	menu.process_mode = PROCESS_MODE_DISABLED
	tween_out_menu(menu)
	first_ignored = false
	focused_node.grab_focus()
	first_ignored = true
	%Buttons.process_mode = Node.PROCESS_MODE_INHERIT


func set_wrap():
	var buttons = []
	for button in %Buttons.get_children():
		button.focus_neighbor_top = ""
		button.focus_neighbor_bottom = ""

		if button.visible:
			buttons.append(button)

	if buttons.size() > 1:
		buttons[0].focus_neighbor_top = buttons[-1].get_path()
		buttons[-1].focus_neighbor_bottom = buttons[0].get_path()


func tween_in_menu(menu):
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(fade_rect, "color:a", 0.9, 0.4)
	tween.tween_property(menu, "global_position", Vector2(menu.global_position.x, 0), 0.4).set_trans(Tween.TRANS_BACK)

func tween_out_menu(menu):
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(fade_rect, "color:a", 0, 0.4)
	tween.tween_property(menu, "global_position", Vector2(menu.global_position.x, 360), 0.4).set_trans(Tween.TRANS_BACK) 


func _on_quit_pressed():
		get_tree().quit()



func open_menu(menu):
	Audio.play_sound("menu-select")
	focused_node = get_viewport().gui_get_focus_owner()
	%Buttons.process_mode = Node.PROCESS_MODE_DISABLED
	menu.process_mode = Node.PROCESS_MODE_INHERIT
	tween_in_menu(menu)



func _on_credits_pressed():
	open_menu(%CreditsMenu)


func _on_settings_pressed():
	open_menu(%SettingsMenu)
	%SettingsMenu.on_show()


func _on_focus_entered():
	if !first_ignored:
		first_ignored = true
		return
	
	Audio.play_sound("menu-changed")
	

func _on_start_game_pressed():
	Audio.play_sound("menu-select")
	%Buttons.process_mode = Node.PROCESS_MODE_DISABLED
	Events.change_scene.emit(Events.SCENE.LEVEL)
