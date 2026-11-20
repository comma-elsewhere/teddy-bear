class_name GameSettingsClass
extends Node

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

@onready var _serializer: ThothSerializable = $SaveGameSettings
@onready var _save_state: ThothGameState = $Savestate

func _ready() -> void:
	if _save_state.save_exists() == true:
		_save_state.load_game_state()
		_save_state.get_game_variables(_serializer)
	else:
		language = 0
		default_audio()
		default_graphic()
		default_accessibility()
		
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
