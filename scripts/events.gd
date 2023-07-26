extends Node

enum SCENE {
    TITLE,
    LEVEL,
}

enum MENU {
    PAUSE,
    SETTINGS,
}

signal toggle_fullscreen(fullscreen: bool)
signal menu_summoned(menu: MENU)
signal menu_dismissed(menu)
signal change_scene(scene: SCENE)