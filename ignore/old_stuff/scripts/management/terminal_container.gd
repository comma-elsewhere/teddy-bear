extends VBoxContainer

@export var scene_control: SceneStateMachine
@export var name_label: Label
@export var age_label: Label
@export var submission_label: Label
@export var instructions_label: Label
@export var file_number_label: Label
@export var diagnosis_label: Label
@export var treatment_label: Label
@export var audio_container: VBoxContainer

const BUTTON_TEXT := "Play Audio"

var audio_players_array : Array[AudioStreamPlayer] =[]

func _ready() -> void:
	scene_control.toy_created.connect(_populate_terminal)
	scene_control.toy_trashed.connect(_hide_terminal.bind(true))
	_hide_terminal(true)
	
func _process(_delta: float) -> void:
	if scene_control.current_state != scene_control.STATE.TERMINAL:
		return
		
	if Input.is_action_just_pressed("ui_accept"):
		_hide_terminal(false)
		
	if audio_players_array.is_empty():
		return
		
	if Input.is_action_just_pressed("c_button"):
		_stop_all_players()
			
	if Input.is_action_just_pressed("z_button"):
		_stop_all_players()
		audio_players_array[0].play()
		
	if Input.is_action_just_pressed("x_button") and audio_players_array.size() > 1:
		_stop_all_players()
		audio_players_array[1].play()
	
func _stop_all_players() -> void:
	for player in audio_players_array:
		player.stop()
	
func _hide_terminal(hide_info: bool) -> void:
	if hide_info:
		audio_players_array.clear()
		for child in audio_container.get_children():
			child.queue_free()
		
		name_label.text = "No Active Patients"
		age_label.text = ""
		instructions_label.text = "Press [Space] to intake a new patient."
		file_number_label.text = "File #: NONE"
		diagnosis_label.text = ""
		treatment_label.text = ""
		submission_label.text = ""
	else:
		if scene_control.toy != null:
			return
		scene_control.spawn_toy()
	
func _populate_terminal(file: DemoPatientFile) -> void:
	name_label.text = file.patient_name
	age_label.text = "AGE: " + str(file.patient_age)
	instructions_label.text = file.instructions
	file_number_label.text = "D#00" + str(file.play_order +1) + "-" + str(randi() % 1000)
	diagnosis_label.text = file.diagnosis
	treatment_label.text = "\n".join(file.treatment)
	submission_label.text = "\n".join(file.submission)
	
	# create new audio
	var count := 0
	for audio in file.audio_recording:
		count += 1
		audio_players_array.append(_create_audio_button(audio, count))
	if !audio_players_array.is_empty():
		_create_audio_button(null, 0)

func _create_audio_button(audio: AudioStreamMP3, count: int) -> AudioStreamPlayer:
	var button := Label.new()
	var audio_player := AudioStreamPlayer.new()
	audio_container.add_child(button)
	button.add_child(audio_player)
	button.add_theme_font_size_override("font_size", 32)
	audio_player.stream = audio
	if count == 1:
		button.text = BUTTON_TEXT + " (Press [Z])"
	elif count == 2:
		button.text = BUTTON_TEXT + " (Press [X])"
	else:
		button.text = "Stop (Press [C])"
	return audio_player
