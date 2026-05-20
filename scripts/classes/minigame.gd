class_name MiniGame extends SubViewport

@warning_ignore("unused_signal")
signal minigame_complete()

@onready var button: Button = %Button

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
	
	button.pressed.connect(_finished) # TEMP for testing

func set_res(new_res: Array[AddonRes]) -> void:
	if new_res.is_empty():
		return

func _finished() -> void:
	call_deferred("emit_signal", "minigame_complete")
