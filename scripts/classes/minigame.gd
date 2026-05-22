class_name MiniGame extends SubViewport

@warning_ignore("unused_signal")
signal minigame_complete()

@onready var game_root = $GameRoot

const WAIT_TIME := 1.0

func _ready() -> void:
	# Settings setup in code for consistency
	size = Vector2(512, 512)
	size_2d_override = Vector2(1024, 1024)
	size_2d_override_stretch = true
	handle_input_locally = true
	physics_object_picking = true
	physics_object_picking_sort = true
	physics_object_picking_first_only = true
	canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	
	game_root.game_done.connect(_finished)

func set_res(new_res: Array[AddonRes]) -> void:
	if new_res.is_empty():
		return

func _finished(good_job: bool) -> void:
	print(good_job)
	await get_tree().create_timer(WAIT_TIME).timeout
	call_deferred("emit_signal", "minigame_complete")
