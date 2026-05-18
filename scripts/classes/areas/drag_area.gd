class_name DragArea extends InteractionArea

signal drop_complete()

const DROP_DIST := 50.0
const LERP_WEIGHT := 30.0
const GOOD_COLOR := Color(0.18, 0.961, 0.106, 1.0)
const RESET_COLOR := Color(1.0, 1.0, 1.0, 1.0)

var drop_body : Node2D = null
var reset_point : Vector2 # must be set to current global position in ready

var is_dragging: bool = false
var is_dropped: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed:
			_attempt_drop()
	
func _input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_enable_drag()
	
func _physics_process(delta: float) -> void:
	if is_dropped:
		if drop_body == null:
			return
		global_position = global_position.lerp(drop_body.global_position, LERP_WEIGHT * delta)
		if global_position.distance_squared_to(drop_body.global_position) < 6.0:
			drop_complete.emit()
		return
	if is_dragging:
		global_position = global_position.lerp(get_global_mouse_position(), LERP_WEIGHT * delta)
		return
	global_position = global_position.lerp(reset_point, 50.0 * delta)
	
func _enable_drag() -> void:
	is_dragging = true
	
func _attempt_drop() -> void:
	is_dragging = false
	if drop_body == null:
		return
	if global_position.distance_to(drop_body.global_position) <= DROP_DIST:
		is_dropped = true

func _color_body(color: bool) -> void:
	if drop_body == null:
		return
	if color:
		drop_body.get_parent().modulate = GOOD_COLOR
	else:
		drop_body.get_parent().modulate = RESET_COLOR
