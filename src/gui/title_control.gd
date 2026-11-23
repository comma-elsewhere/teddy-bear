extends Control

@export var open_settings_button: Button
@export var settings_menu: SettingsMenu
@export var everything_else: Array[Control] = []

func _ready() -> void:
	settings_menu.close_menu.connect(_toggle_settings_menu.bind(false))
	open_settings_button.button_up.connect(_toggle_settings_menu.bind(true))
	
func _toggle_settings_menu(show_menu: bool) -> void:
	settings_menu.visible = show_menu
	for node in everything_else:
		node.visible = !show_menu
