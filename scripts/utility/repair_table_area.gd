class_name TableElement extends InteractionArea

const OFFSETS : Array[Vector2] = [Vector2(8, 147), Vector2(-152, 134), Vector2(-92, 401), Vector2(164, 132), Vector2(82, 420), Vector2(8, -124)]
const ROTATIONS : Array[float] = [0, deg_to_rad(45), 0, deg_to_rad(-45), 0, 0]
const LERP_WEIGHT := 50.0

var toy: ToyBody = null

func _ready() -> void:
	gravity_space_override = Area2D.SPACE_OVERRIDE_DISABLED
	body_entered.connect(_activate_freeze)
	input_event.connect(_free_toy)
	create_collision(250)
	start()
	
func _physics_process(delta: float) -> void:
	if toy == null:
		return
	for i in len(toy.bodies):
		toy.bodies[i].global_rotation = lerp_angle(toy.bodies[i].global_rotation, ROTATIONS[i], LERP_WEIGHT * delta)
		toy.bodies[i].global_position = lerp(toy.bodies[i].global_position, global_position + OFFSETS[i], LERP_WEIGHT * delta)
		toy.bodies[i].linear_velocity = Vector2.ZERO
		toy.visible = %TableMargins.visible
	
func _activate_freeze(body: Node2D) -> void:
	if body.is_in_group("ToyBody") and %TableMargins.visible:
		toy = body.get_parent() as ToyBody
		toy.is_held = null
		toy.hooked_held = null
		toy.hooked = false
			
func _free_toy(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and toy != null:
			toy = null
