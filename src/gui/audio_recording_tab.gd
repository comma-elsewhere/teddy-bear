class_name AudioRecTab
extends PanelContainer

signal play_button_pressed(stream: AudioStreamOggVorbis)
signal pause_button_pressed()

const _CMS := Vector2(320, 30)

@onready var play_button: Button = %PlayButton
@onready var _subtitle_mother: VBoxContainer = %SubtitleMother

var _audio_dict: Dictionary # KEYS: "audio_stream", "subtitles"
var _text_index: int = -1
var _first_click: bool = false
var _line_timer := Timer.new()

func _ready() -> void:
	play_button.button_up.connect(_button_interaction)
	_line_timer.one_shot = true
	_line_timer.autostart = false
	add_child(_line_timer)
	_line_timer.timeout.connect(_next_in_line)
	
func new_audio(new_dictionary: Dictionary) -> void:
	for child in _subtitle_mother.get_children(true):
		_subtitle_mother.remove_child(child)
		child.call_deferred("queue_free")
	_audio_dict = new_dictionary
	_text_index = 0
	_first_click = false
 
func _button_interaction() -> void:
	if _first_click == true:
		if _text_index < _audio_dict["subtitles"].size():
			_skip_text_scroll()
		else:
			emit_signal("pause_button_pressed")
		return
	_start_text_scroll()
	emit_signal("play_button_pressed", _audio_dict["audio_stream"])
	_first_click = true

func _skip_text_scroll() -> void:
	print("SKIP")
	return
	
func _start_text_scroll() -> void:
	_line_timer.start(_audio_dict["subtitles"][_text_index]["timestamp"])

func _next_in_line() -> void:
	_new_subtitle()
	_text_index += 1
	if _text_index < _audio_dict["subtitles"].size():
		_line_timer.start(_audio_dict["subtitles"][_text_index]["timestamp"])

func _new_subtitle() -> RichTextLabel:
	var new_label := RichTextLabel.new()
	_subtitle_mother.add_child(new_label)
	new_label.scroll_active = false
	new_label.custom_minimum_size = _CMS
	new_label.fit_content = true
	new_label.text = _audio_dict["subtitles"][_text_index]["text_key"]
	await get_tree().process_frame
	new_label.update_maximum_size()
	return new_label
