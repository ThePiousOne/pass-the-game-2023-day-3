extends MarginContainer

@onready var MASTER_BUS = AudioServer.get_bus_index("Master")
@onready var MUSIC_BUS = AudioServer.get_bus_index("Music")
@onready var SFX_BUS = AudioServer.get_bus_index("SFX")

var first_ignored := false

func _ready():
	%MasterVolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(MASTER_BUS))
	%MusicVolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(MUSIC_BUS))
	%SfxVolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(SFX_BUS))

	Events.toggle_fullscreen.connect(_on_toggle_fullscreen)


func _on_toggle_fullscreen(fullscreen):
	%FullscreenCheckBox.button_pressed = fullscreen


func on_show():
	first_ignored = false
	%MasterVolumeSlider.grab_focus()
	%FullscreenCheckBox.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	first_ignored = true


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Audio.play_sound("menu-back")
		Events.menu_dismissed.emit(self)
	

func _on_sfx_volume_slider_value_changed(value:float):
	Audio.play_sound("menu-changed")
	AudioServer.set_bus_volume_db(SFX_BUS, linear_to_db(value))


func _on_music_volume_slider_value_changed(value:float):
	Audio.play_sound("menu-changed")
	AudioServer.set_bus_volume_db(MUSIC_BUS, linear_to_db(value))


func _on_master_volume_slider_value_changed(value:float):
	Audio.play_sound("menu-changed")
	AudioServer.set_bus_volume_db(MASTER_BUS, linear_to_db(value))


func _on_check_box_toggled(button_pressed:bool):
	Audio.play_sound("menu-changed")
	Events.toggle_fullscreen.emit(button_pressed)


func _on_focus_entered():
	if !first_ignored:
		first_ignored = true
		return
	
	Audio.play_sound("menu-changed")
