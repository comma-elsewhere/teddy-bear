class_name LaundryElement extends InteractionArea

const RADIUS := 150.0
const CLEAN_COLOR := Color("ffffff")
const COLOR_LERP := 10.0
const WASH_SPEED := 1000.0

var toy: ToyBody = null

var can_wash: bool = false

# connect body entered to func
func _ready() -> void:
	input_pickable = true
	body_entered.connect(_detect_toy_dirty)
	input_event.connect(_mouse_event)
	create_collision(RADIUS)
	start()
	
	# Call wash toy when toy is dropped in area
func _mouse_event (_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and toy != null:
			can_wash = true
		elif !event.pressed:
			can_wash = false
			
	if event is InputEventMouseMotion and event.relative.is_zero_approx() == false:
		if toy != null and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if abs(Input.get_last_mouse_velocity()).y > WASH_SPEED:
				_wash_toy()
	
# Checks if toy is able to be washed --- needs to be dirty and currently visible
func _detect_toy_dirty(body: Node2D) -> void:
	if body.is_in_group("ToyBody"):
		toy = body.get_parent() as ToyBody
		if !toy.toy_res.dirty_or_stain or !toy.visible:
			toy = null
		
# Hide toy, drop from mouse and hook, freeze bodies, set to clean
# finish WASH_TIME timer and fling in FLING direction
# set back to visible only if player AND toy are still in bench scene
func _wash_toy() -> void:
	if toy.modulate == CLEAN_COLOR:
		toy = null
		return
	toy.modulate = toy.modulate.lerp(CLEAN_COLOR, 0.01)
	for body in toy.bodies:
			body.modulate = body.modulate.lerp(CLEAN_COLOR, 0.03)
