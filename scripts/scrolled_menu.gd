extends MarginContainer

@onready var Scroller := $VBoxContainer/Menu/MarginContainer/ScrollContainer


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Audio.play_sound("menu-back")
		Events.menu_dismissed.emit(self)

	if Input.is_action_just_pressed("ui_down"):
		Scroller.set_v_scroll(Scroller.get_v_scroll() + 100)
	elif Input.is_action_just_pressed("ui_up"):
		Scroller.set_v_scroll(Scroller.get_v_scroll() - 100)
