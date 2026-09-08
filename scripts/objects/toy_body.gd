class_name Toy extends Node2D

@export var limb_bodies: Array[RapierRigidBody2D] = []

const LERP_WEIGHT := 500.0

var lerp_body: RapierRigidBody2D = null

func _ready() -> void:
	for body in limb_bodies:
		body.input_pickable = true
		body.input_event.connect(_click_event.bind(body))
		
func _physics_process(_delta: float) -> void:
	if lerp_body == null:
		return
	if Input.is_action_just_released("click"):
		lerp_body = null
		return
	_normalize_velocity(0.7)
	lerp_body.apply_central_force((get_global_mouse_position() - lerp_body.global_position) * LERP_WEIGHT)
	
func _click_event(_viewport: Node, event: InputEvent, _shape_idx: int, body: RapierRigidBody2D) -> void:
	if event.is_action_pressed("click"):
		lerp_body = body
		
func _normalize_velocity(delta: float) -> void:
	lerp_body.linear_velocity = Vector2.ZERO
	lerp_body.angular_velocity *= delta
