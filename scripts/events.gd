extends Node

enum SCENE {
    TITLE,
    LEVEL,
}

signal toggle_fullscreen(fullscreen: bool)
signal menu_dismissed(menu)
signal change_scene(scene: SCENE)