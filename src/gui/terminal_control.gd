class_name TerminalControl
extends Control

@export var redacted_stylebox: StyleBoxFlat
@export var visible_stylebox: StyleBoxFlat

@onready var name_age: Label = %NameAge
@onready var repair_plan: Label = %RepairPlan
@onready var presentation: Label = %Presentation
@onready var patient_brief: Label = %PatientBrief
@onready var physician_notes: Label = %PhysicianNotes
@onready var audio_tab_manager: AudioTabManager = %AudioTabManager

var toy_data: ToyData = null

func _ready() -> void:
	hide()
	add_to_group("ToyMonitor")
	
func clear_current_toy() -> void: # group call function of the "ToyMonitor" Group
	hide()
	audio_tab_manager.stop_and_clear()
	toy_data = null
	
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
	
	_check_progression(toy_data.viewing_round)

func _check_progression(current_round: int) -> void:
	if current_round <= 0:
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
