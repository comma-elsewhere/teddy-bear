class_name ToyData
extends Resource

#@export_group("Progression")
#@export_subgroup("First Loop")
#@export var appears_in_first_loop: bool = true
#@export_enum("Monday", "Tuesday", "Wednesday", "Thursday", "Friday") var day_of_week: int = 0
#@export_range(0, 2) var appearance_order: int = 0
#@export_subgroup("Later Loops")
@export var toy_name: String
@export_group("Repairs Needed")
@export var dirty: bool = false
@export_range(0, 2) var damaged: int = 0
@export var missing_item: ItemData = null
@export var contaminant: ItemData = null
@export_group("Terminal Data")
@export var patient_records: Array[String] = ["","","","",""]
@export var audio_files: Array[AudioStreamOggVorbis] = [null]
@export_subgroup("Subtitles")
@export var subtitles_1: Array[String] = [""]
@export var subtitles_2: Array[String] = [""]

var listening_credit: Array[String] = []
var viewing_round: int = 0 # Should be set to 0

func get_audio_dict(index: int) -> Dictionary:
	var subtitles: Array[Array] = [subtitles_1, subtitles_2]
	
	var new_dict: Dictionary = {
		"stream_ogg" = audio_files[index],
		"subtitles_text" = subtitles[index],
	}
	var file_name: String = patient_records[0].to_snake_case() + "_" + str(index)
	
	new_dict["stream_ogg"].set_meta("file_name", file_name)
	
	return new_dict
