class_name DemoPatientFile extends Resource

@export_group("File Information")
@export_enum("FIRST", "SECOND", "THIRD") var play_order: int = 0
@export var patient_name: String = ""
@export_range(2,18) var patient_age: int = 0
@export_subgroup("Loop One")
@export var submission: PackedStringArray = []
@export var instructions: String = "Remove contaminants and restore to factory condition."
@export_subgroup("Loop Two")
@export var diagnosis: String = ""
@export var treatment: PackedStringArray = []
@export var audio_recording: Array[AudioStreamMP3]
