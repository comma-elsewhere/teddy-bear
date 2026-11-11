class_name ToyData
extends Resource

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
@export var subtitle_key: String = "PR__SUB"
@export var KeyedSub1: Dictionary[String, float] # KEY_NUM, timestamp
@export var KeyedSub2: Dictionary[String, float] # KEY_NUM, timestamp

var viewing_round: int = 0 # Should be set to 0

func get_audio_dict(index: int) -> Dictionary:
	var sub_1: bool = false
	if index == 0:
		sub_1 = true
	
	var new_dict: Dictionary = {
		"audio_stream" = audio_files[index],
		"subtitles" = _get_timed_subtitle_keys(sub_1),
	}
	
	return new_dict

func _get_timed_subtitle_keys(sub_1: bool) -> Array[Dictionary]:
	var og_dict: Dictionary
	var new_array: Array[Dictionary] = []
	var str_num: String
	
	if sub_1:
		og_dict = KeyedSub1
		str_num = "1"
	else:
		og_dict = KeyedSub2
		str_num = "2"
	
	for key in og_dict.keys():
		var new_dict := {
			"text_key" : subtitle_key + str_num + "_" + key,
			"timestamp" : og_dict[key],
			"line_number" : str_to_var(key)
		}
		new_array.append(new_dict)
	
	return new_array
