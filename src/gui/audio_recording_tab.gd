class_name AudioRecTab
extends PanelContainer

signal play_button_pressed(stream: AudioStreamOggVorbis)

const DEFAULT_TEXT := ". . . ."

@onready var dialogue_text: RichTextLabel = %SubtitlesRichText
@onready var play_button: Button = %PlayButton

var audio_dict: Dictionary # KEYS: "stream_ogg", "subtitles_text"
var typing: bool = false
var typewriter_generation: int = 0
var current_text: String = ""
var typewriter_speed: float = 0.025

func _ready() -> void:
	play_button.button_up.connect(_handle_interact)
	
func new_audio(new_dictionary: Dictionary) -> void:
	audio_dict = new_dictionary
	dialogue_text.text = DEFAULT_TEXT
 
func _skip_typewriter() -> void:
	if not typing:
		return
 
	typewriter_generation += 1
	typing = false
	dialogue_text.visible_characters = -1
	
func _start_typewriter( text: String ) -> void:
	typewriter_generation += 1
	var generation := typewriter_generation
	current_text = text
	typing = true
	dialogue_text.text = text
	dialogue_text.visible_characters = 0
 
	var character_count := text.length()
	for i in range(character_count):
		if generation != typewriter_generation:
			return
 
		dialogue_text.visible_characters = i + 1
		await get_tree().create_timer( typewriter_speed ).timeout
 
	if generation != typewriter_generation:
		return
 
	typing = false
	dialogue_text.visible_characters = -1
	
func _handle_interact() -> void:
	if typing:
		_skip_typewriter()
		return
	dialogue_text.text = ""
	emit_signal("play_button_pressed", audio_dict["stream_ogg"])
	call("_start_typewriter", audio_dict["subtitles_text"])
