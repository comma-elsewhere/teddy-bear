class_name TerminalControl
extends Control

@export var redacted_stylebox: StyleBoxFlat
@export var visible_stylebox: StyleBoxFlat

@onready var name_age: RichTextLabel = %NameAge
@onready var repair_plan: RichTextLabel = %RepairPlan
@onready var presentation: RichTextLabel = %Presentation
@onready var patient_brief: RichTextLabel = %PatientBrief
@onready var physician_notes: RichTextLabel = %PhysicianNotes
@onready var audio_tab_manager: AudioTabManager = %AudioTabManager

var toy_data: ToyData = null

func _ready() -> void:
	hide()
	audio_tab_manager.audio_listened.connect(_listening_progress)
	
func set_new_data(new_data: ToyData) -> void:
	toy_data = new_data
	
	name_age.text = new_data.patient_records[0]
	repair_plan.text = new_data.patient_records[1]
	presentation.text = new_data.patient_records[2]
	patient_brief.text = new_data.patient_records[3]
	physician_notes.text = new_data.patient_records[4]
	
	var audio_array: Array[Dictionary] = []
	for i in len(new_data.audio_files):
		audio_array.append(new_data.get_audio_dict(i))
	audio_tab_manager.set_new_audio(audio_array)
	
	toy_data.viewing_round += 1
	_check_progression(toy_data.viewing_round)

func _listening_progress(stream: AudioStreamOggVorbis) -> void:
	if !toy_data.listening_credit.has(stream.get_meta("file_name")):
		toy_data.listening_credit.append(stream.get_meta("file_name"))

func _check_progression(current_round: int) -> void:
	if current_round < 2:
		patient_brief.add_theme_stylebox_override("normal", redacted_stylebox)
		physician_notes.add_theme_stylebox_override("normal", redacted_stylebox)
		audio_tab_manager.audio_rec_tab_0.play_button.disabled = true
		audio_tab_manager.set_tab_disabled(1, true)
	else:
		patient_brief.add_theme_stylebox_override("normal", visible_stylebox)
		physician_notes.add_theme_stylebox_override("normal", visible_stylebox)
		audio_tab_manager.audio_rec_tab_0.play_button.disabled = false
		audio_tab_manager.set_tab_disabled(1, false)
	show()
