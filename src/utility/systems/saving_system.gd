extends ThothSerializable

@onready var save_state: ThothGameState = $SaveState
@onready var _toy_spawn: ToySpawn = %Systems/ToySpawn
@onready var _pause_root: Control = %PauseRoot

func _ready() -> void:
	_pause_root.hide()
	if Settings.load_save_file and save_state.save_exists(): # Load save file if it exists
		print("Loading...")
		save_state.load_game_state()
		save_state.unpack_level(self)
	
	_toy_spawn.new_toy_spawned.connect(_autosave_on_toy_spawn) # Connect autosave to new toy spawning
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		_pause_root.visible = !_pause_root.visible
		get_tree().paused = _pause_root.visible
	
func _autosave_on_toy_spawn(_ignore) -> void:
	if save_state.save_exists() == true:
		save_state.load_game_state()
	save_state.pack_level(self)
	save_state.save_game_state()
	print(save_state.save_filename)
