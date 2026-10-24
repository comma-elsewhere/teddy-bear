class_name Toy extends Node2D

signal body_picked(pick_body: RapierRigidBody2D)
signal body_dropped(drop_body: RapierRigidBody2D)

const LERP_WEIGHT := 500.0

@export var toy_data: ToyData = null
@export var limb_bodies: Array[RapierRigidBody2D] = []
@export var show_on_shut: Array[Sprite2D] = []
@export var hide_on_shut: Array[Sprite2D] = []

var lerp_body: RapierRigidBody2D = null

func _ready() -> void:
	for body in limb_bodies:
		body.input_pickable = true
		body.input_event.connect(_click_event.bind(body))
		body.add_to_group("ToyBody")
		
func _physics_process(_delta: float) -> void:
	if lerp_body == null:
		return
	if Input.is_action_just_released("click"):
		emit_signal("body_dropped", lerp_body)
		lerp_body = null
		return
	_normalize_velocity(0.7)
	lerp_body.apply_central_force((get_global_mouse_position() - lerp_body.global_position) * LERP_WEIGHT)
	
func disable_limbs() -> void:
	for body in limb_bodies:
		body.freeze = true
		body.set_collision_mask_value(1, false)
	
func _click_event(viewport: Node, event: InputEvent, _shape_idx: int, body: RapierRigidBody2D) -> void:
	if event.is_action_pressed("click"):
		viewport.set_input_as_handled()
		if lerp_body == null:
			emit_signal("body_picked", body)
		lerp_body = body
		
func _normalize_velocity(delta: float) -> void:
	lerp_body.linear_velocity = Vector2.ZERO
	lerp_body.angular_velocity *= delta
