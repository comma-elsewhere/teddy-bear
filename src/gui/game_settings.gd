extends Control

const DYSLEXIA_THEME := preload("res://src/resources/gui/dyslexia.theme")
const STANDARD_THEME := preload("res://src/resources/gui/standard.theme")
const RES_ARRAY: Array[Vector2i] = [Vector2i(2560, 1440), Vector2i(1920, 1080), Vector2i(1366, 768), Vector2i(1280, 720)]

@onready var language_options: OptionButton = %LanguageOptionButton
@onready var master_slider: HSlider = %MasterHSlider
@onready var music_slider: HSlider = %MusicHSlider
@onready var sfx_slider: HSlider = %SFXHSlider
@onready var mute_check_box: CheckButton = %MuteCheckBox
@onready var resolution_options: OptionButton = %ResolutionOptionButton
@onready var fullscreen_check_box: CheckButton = %FullscreenCheckBox
@onready var dyslexia_check_box: CheckButton = %DyslexiaCheckBox
@onready var subtitles_check_box: CheckButton = %SubtitlesCheckBox
@onready var camera_shake_check_box: CheckButton = %CameraShakeCheckBox
@onready var flickering_check_box: CheckButton = %FlickeringCheckBox
@onready var click_drag_check_box: CheckButton = %ClickDragCheckBox

func _ready() -> void:
	language_options.item_selected.connect(_update_langauge)
	master_slider.value_changed.connect(_update_master_volume)
	music_slider.value_changed.connect(_update_music_volume)
	sfx_slider.value_changed.connect(_update_sfx_volume)
	mute_check_box.toggled.connect(_update_mute)
	resolution_options.item_selected.connect(_update_resolution)
	fullscreen_check_box.toggled.connect(_update_fullscreen)
	dyslexia_check_box.toggled.connect(_update_dyslexia)
	subtitles_check_box.toggled.connect(_update_subtitles)
	camera_shake_check_box.toggled.connect(_update_camera_shake)
	flickering_check_box.toggled.connect(_update_flickering_lights)
	click_drag_check_box.toggled.connect(_update_click_drag)
	$CloseMenuButton.pressed.connect(save_changes)
	
	await get_tree().process_frame
	load_settings()

func load_settings() -> void:
	language_options.select(Settings.language)
	master_slider.value = Settings.master_volume
	music_slider.value = Settings.music_volume
	sfx_slider.value = Settings.sfx_volume
	mute_check_box.button_pressed = Settings.mute
	resolution_options.select(Settings.resolution)
	fullscreen_check_box.button_pressed = Settings.fullscreen
	dyslexia_check_box.button_pressed = Settings.dyslexia_font
	subtitles_check_box.button_pressed = Settings.subtitles
	camera_shake_check_box.button_pressed = Settings.camera_shake
	flickering_check_box.button_pressed = Settings.flickering_lights
	click_drag_check_box.button_pressed = Settings.click_drag
	
func save_changes() -> void:
	Settings.save_settings()
	
func _update_langauge(index: int) -> void:
	Settings.language = index
	print("language changed to: " + str(index))
	
func _update_master_volume(value: float) -> void:
	Settings.master_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	
func _update_music_volume(value: float) -> void:
	Settings.music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	
func _update_sfx_volume(value: float) -> void:
	Settings.sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), linear_to_db(value))
	
func _update_mute(value: bool) -> void:
	Settings.mute = value
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), value)
	
func _update_resolution(index: int) -> void:
	Settings.resolution = index
	DisplayServer.window_set_size(RES_ARRAY[index])
	
func _update_fullscreen(value: bool) -> void:
	Settings.fullscreen = value
	if value == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
func _update_dyslexia(value: bool) -> void:
	Settings.dyslexia_font = value
	if value == true:
		theme = DYSLEXIA_THEME
	else:
		theme = STANDARD_THEME
	
func _update_subtitles(value: bool) -> void:
	Settings.subtitles = value
	
func _update_camera_shake(value: bool) -> void:
	Settings.camera_shake = value
	
func _update_flickering_lights(value: bool) -> void:
	Settings.flickering_lights = value
	
func _update_click_drag(value: bool) -> void:
	Settings.click_drag = value
