class_name AudioTabManager
extends TabContainer

signal audio_listened(stream: AudioStreamOggVorbis)

@onready var audio_rec_tab_0: AudioRecTab = $AudioRecTab1
@onready var audio_rec_tab_1: AudioRecTab = $AudioRecTab2
@onready var stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	audio_rec_tab_0.play_button_pressed.connect(_play_new_audio)
	audio_rec_tab_1.play_button_pressed.connect(_play_new_audio)
	stream_player.finished.connect(func(): emit_signal("audio_listened", stream_player.stream))

func set_new_audio(new_dict_array: Array[Dictionary]) -> void:
	audio_rec_tab_0.new_audio(new_dict_array[0])
	if new_dict_array.size() > 1:
		audio_rec_tab_1.new_audio(new_dict_array[1])
		set_tab_hidden(1, false)
	else:
		set_tab_hidden(1, true)
		
func _play_new_audio(new_stream: AudioStreamOggVorbis) -> void:
	if stream_player.playing:
		stream_player.stop()
		if stream_player.stream == new_stream:
			return
	stream_player.stream = new_stream
	stream_player.play()
