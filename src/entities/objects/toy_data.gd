class_name ToyData
extends Resource

@export var patient_records: Array[String] = ["","","","",""]
@export var audio_files: Array[AudioStreamOggVorbis] = [null]
@export var subtitles: Array[String] = [""]

var listening_credit: Array[String] = []
var viewing_round: int = 0

func get_audio_dict(index: int) -> Dictionary:
	var new_dict: Dictionary = {
		"stream_ogg" = audio_files[index],
		"subtitles_text" = subtitles[index],
	}
	var file_name: String = patient_records[0].to_snake_case() + "_" + str(index)
	
	new_dict["stream_ogg"].set_meta("file_name", file_name)
	
	return new_dict
