extends InteractionArea

@export var inside_area: InteractionArea

const CLOSE_POS := Vector2(-155,0)
const OPEN_POS := Vector2(450, 190)

func _ready() -> void:
	create_collision(150)
	input_pickable = true
	input_event.connect(_mouse_event)
	position = CLOSE_POS
	start()

func _mouse_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MASK_LEFT:
		if event.pressed:
			var open: bool = %SafeDoorOpen.visible
			open = !open
			%SafeDoorClosed.visible = !open
			%SafeDoorOpen.visible = open
			
			if open:
				position = OPEN_POS
			else: 
				position = CLOSE_POS
			
			if inside_area:
				inside_area.input_pickable = open
