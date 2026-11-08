class_name AudioRecTab
extends PanelContainer

signal play_button_pressed(stream: AudioStreamOggVorbis)

const _CMS := Vector2(320, 30)

@onready var play_button: Button = %PlayButton
@onready var _subtitle_mother: VBoxContainer = %SubtitleMother

var typing: bool = false
var _audio_dict: Dictionary # KEYS: "stream_ogg", "subtitles_text"
#var _typewriter_generation: int = 0
#var _current_text: String = ""
#var _typewriter_speed: float = 0.04 # Smaller number means faster typing
var _text_index: int = -1
var _current_subtitle: RichTextLabel = null

func _ready() -> void:
	play_button.button_up.connect(_handle_interact)
	
func new_audio(new_dictionary: Dictionary) -> void:
	for child in _subtitle_mother.get_children():
		_subtitle_mother.remove_child(child)
		child.call_deferred("queue_free")
	
	_audio_dict = new_dictionary
	_text_index = 0
 
func _skip_typewriter() -> void:
	if not typing:
		return
	# Print all text at once
	
func _start_typewriter( text: String ) -> void:
	typing = true
	_current_subtitle = _spawn_new_subtitle()
	_current_subtitle.text = text
	#_typewriter_generation += 1
	#var generation := _typewriter_generation
	#_current_text = text
	#_current_subtitle.text = text
	#_current_subtitle.visible_characters = 0
 #
	#var character_count := text.length()
	#for i in range(character_count):
		#if generation != _typewriter_generation:
			#return
 #
		#_current_subtitle.visible_characters = i + 1
		#await get_tree().create_timer( _typewriter_speed ).timeout
 #
	#if generation != _typewriter_generation:
		#return
 	
	_text_index += 1
	if _text_index < _audio_dict["subtitles_text"].size():
		await get_tree().create_timer(2.5).timeout
		call("_start_typewriter", _audio_dict["subtitles_text"][_text_index])
		return
	typing = false
	#_current_subtitle.visible_characters = -1
	
func _handle_interact() -> void:
	emit_signal("play_button_pressed", _audio_dict["stream_ogg"]) # Play, pause, and restart audio
	
	if typing or _text_index >= _audio_dict["subtitles_text"].size() -1:
		return
	
	call("_start_typewriter", _audio_dict["subtitles_text"][_text_index])
	
func _spawn_new_subtitle() -> RichTextLabel:
	var new_label := RichTextLabel.new()
	new_label.scroll_active = false
	new_label.fit_content = true
	_subtitle_mother.add_child(new_label)
	new_label.custom_minimum_size = _CMS
	return new_label
