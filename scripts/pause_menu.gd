extends MarginContainer


var first_ignored := false
var focused_node

func _ready():
	if OS.get_name() == "Web":
		%Quit.hide()
	else:
		%Quit.show()
	set_wrap()

	%Resume.grab_focus()


func on_show():
	%Resume.grab_focus()

func on_resume():
	if focused_node:
		focused_node.grab_focus()
	else:
		%Resume.grab_focus()


func set_wrap():
	var buttons = []
	for button in %Buttons.get_children():
		button.focus_neighbor_top = ""
		button.focus_neighbor_bottom = ""

		if button.visible:
			buttons.append(button)

		button.focus_entered.connect(_on_focus_entered.bind(button))
		button.mouse_entered.connect(_on_mouse_entered)

	if buttons.size() > 1:
		buttons[0].focus_neighbor_top = buttons[-1].get_path()
		buttons[-1].focus_neighbor_bottom = buttons[0].get_path()


func _on_quit_pressed():
	get_tree().quit()

func _on_settings_pressed():
	Events.menu_summoned.emit(Events.MENU.SETTINGS)

func _on_focus_entered(button):
	focused_node = button

	if !first_ignored:
		first_ignored = true
		return

	Audio.play_sound("menu-changed")
	
func _on_mouse_entered():
	Audio.play_sound("menu-changed")
	

func _on_restart_pressed():
	Audio.play_sound("menu-select")
	%Buttons.process_mode = Node.PROCESS_MODE_DISABLED
	Events.change_scene.emit(Events.SCENE.LEVEL)


func _on_exit_to_title_pressed():
	Audio.play_sound("menu-select")
	%Buttons.process_mode = Node.PROCESS_MODE_DISABLED
	Events.change_scene.emit(Events.SCENE.TITLE)


func _on_resume_pressed():
	Events.menu_dismissed.emit(self)
