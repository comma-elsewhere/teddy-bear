extends InteractionArea

func _ready() -> void:
	create_collision(300)
	input_pickable = true
	input_event.connect(_mouse_event)

func _mouse_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MASK_LEFT:
		if event.pressed:
			var open: bool = %SafeDoorOpen.visible
			open = !open
			%SafeDoorClosed.visible = !open
			%SafeDoorOpen.visible = open
