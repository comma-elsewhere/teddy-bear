class_name TableElement extends InteractionArea

# Snap to these offsets and rotations for the cruficied look
const OFFSETS : Array[Vector2] = [Vector2(0,0), Vector2(-189,-68), Vector2(-116, 241), Vector2(188, -67), Vector2(116, 245), Vector2(0, -267)]
const ROTATIONS : Array[float] = [0, deg_to_rad(85), deg_to_rad(15), deg_to_rad(-85), deg_to_rad(-15), 0]
# Lerp weight to snap
const LERP_WEIGHT := 50.0
# ToyBody var to track and control toy body
var toy: ToyBody = null
var capture: bool = false

func _ready() -> void:
	body_entered.connect(_activate_freeze)
	input_event.connect(_mouse_event)
	%TableMargins.visibility_changed.connect(_toggle_toy_visible)
	%BenchLayer.visibility_changed.connect(_toggle_toy_visible)
	create_collision(250)
	start()
	
func _physics_process(delta: float) -> void:
	if capture == false or toy == null:
		return
	for i in len(toy.bodies):
		toy.bodies[i].global_position = lerp(toy.bodies[i].global_position, global_position + OFFSETS[i], LERP_WEIGHT * delta)
		toy.bodies[i].global_rotation = lerp_angle(toy.bodies[i].global_rotation, ROTATIONS[i], LERP_WEIGHT * delta)
		toy.bodies[i].linear_velocity = Vector2.ZERO
	
func _activate_freeze(body: Node2D) -> void:
	if body.is_in_group("ToyBody") and %TableMargins.visible:
		toy = body.get_parent() as ToyBody
		
func _mouse_event (_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and toy != null:
			_free_toy()
			return
		if !event.pressed and toy != null:
			_capture_toy()

func _capture_toy() -> void:
	toy.toggle_collision(false)
	input_pickable = true
	capture = true
	
func _free_toy() -> void:
	toy.toggle_collision(true)
	capture = false
	toy = null

func _toggle_toy_visible() -> void:
	if %TableMargins.visible and %BenchLayer.visible and toy != null:
		toy.show()
		input_pickable = true
	elif toy != null:
		toy.hide()
		input_pickable = false
