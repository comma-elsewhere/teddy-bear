class_name GameSettingsClass
extends Node

const DYSLEXIA_THEME := preload("res://src/resources/gui/dyslexia.theme")
const STANDARD_THEME := preload("res://src/resources/gui/standard.theme")

var language: int

var master_volume: float
var music_volume: float
var sfx_volume: float
var mute: bool

var resolution: int
var fullscreen: bool

var dyslexia_font: bool
var subtitles: bool
var camera_shake: bool
var flickering_lights: bool
var click_drag: bool

var save_file_exists: bool
var load_save_file: bool

var _serializer:= ThothSerializable.new()
var _save_state:= ThothGameState.new()

func _ready() -> void:
	add_child(_serializer)
	add_child(_save_state)
	_serializer.variables = ["language", "master_volume", "music_volume", "sfx_volume", "mute", "resolution", "fullscreen", "dyslexia_font", "subtitles", "camera_shake", "flickering_lights", "click_drag"]
	if _save_state.save_exists() == true:
		_save_state.load_game_state()
		_save_state.get_game_variables(_serializer)
		save_file_exists = true
	else:
		language = 0
		default_audio()
		default_graphic()
		default_accessibility()
		save_file_exists = false
		
func save_settings() -> void:
	_save_state.set_game_variables(_serializer)
	_save_state.save_game_state()
	
func default_audio() -> void:
	master_volume = db_to_linear(0)
	music_volume = db_to_linear(-13)
	sfx_volume = db_to_linear(-1)
	mute = false
	
func default_graphic() -> void:
	resolution = 1
	fullscreen = true

func default_accessibility() -> void:
	dyslexia_font = false
	subtitles = true
	camera_shake = true
	flickering_lights = true
	click_drag = false
