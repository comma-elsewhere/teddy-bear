extends ThothSerializable

@onready var save_state: ThothGameState = $SaveState
@onready var _toy_spawn: ToySpawn = %Systems/ToySpawn

func _ready() -> void:
	if save_state.save_exists() == true: # Load save file if it exists
		print("Loading...")
		save_state.load_game_state()
		save_state.unpack_level(self)
	
	_toy_spawn.new_toy_spawned.connect(_autosave_on_toy_spawn) # Connect autosave to new toy spawning
	
func _autosave_on_toy_spawn(_ignore) -> void:
	if save_state.save_exists() == true:
		save_state.load_game_state()
	save_state.pack_level(self)
	save_state.save_game_state()
	print(save_state.save_filename)
