extends PanelContainer

@export var load_save_file: bool = false
@export_group("Connect")
@export var base_label: Label
@export var hover_label: Label
@export var play_button: Button

func _enter_tree() -> void:
	if load_save_file and !Settings.save_file_exists:
		hide()
		return

func _ready() -> void:
	base_label.show()
	hover_label.hide()
	play_button.mouse_entered.connect(_toggle_visible_label.bind(true))
	play_button.mouse_exited.connect(_toggle_visible_label.bind(false))
	play_button.button_up.connect(_load_game)
	
func _toggle_visible_label(mouse_hover: bool) -> void:
	base_label.visible = !mouse_hover
	hover_label.visible = mouse_hover
	
func _load_game() -> void:
	if load_save_file:
		Settings.load_save_file = true
	get_tree().change_scene_to_file("res://src/core/main_game/Main.tscn")
