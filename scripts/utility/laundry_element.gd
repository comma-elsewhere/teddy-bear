class_name LaundryElement extends InteractionArea

const RADIUS := 150.0
const CLEAN_COLOR := Color("ffffff")
const FLING := Vector2(150, -300)
const WASH_TIME := 2.5

var toy: ToyBody = null
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
		if !event.pressed and toy != null:
			_wash_toy()
	
# Checks if toy is able to be washed --- needs to be dirty and currently visible
func _detect_toy_dirty(body: Node2D) -> void:
	if body.is_in_group("ToyBody"):
		toy = body.get_parent() as ToyBody
		if !toy.toy_res.dirty or !toy.visible:
			toy = null
		
# Hide toy, drop from mouse and hook, freeze bodies, set to clean
# finish WASH_TIME timer and fling in FLING direction
# set back to visible only if player AND toy are still in bench scene
func _wash_toy() -> void:
	toy.hide()
	toy.is_held = null
	toy.hooked = false
	for body in toy.bodies:
		body.set_deferred("freeze", true)
	toy.modulate = CLEAN_COLOR
	toy.toy_res.dirty = false
	await get_tree().create_timer(WASH_TIME).timeout
	
	for body in toy.bodies:
		body.freeze = false
		body.apply_central_impulse(FLING)
		
	# Only set toy back to visible if player is in Laundry state
	if %LaundryMargins.visible:
		toy.show()
	else:
		await %LaundryMargins.visibility_changed
		toy.show()
	
	# reset toy variable
	toy = null
