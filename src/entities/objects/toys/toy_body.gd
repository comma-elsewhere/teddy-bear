class_name Toy extends Node2D

signal body_picked(pick_body: RapierRigidBody2D)
signal body_dropped(drop_body: RapierRigidBody2D)

enum JOINT { NECK, L_SHOULDER, R_SHOULDER, L_HIP, R_HIP }

const LERP_WEIGHT := 500.0

@export var toy_data: ToyData = null
@export var limb_bodies: Array[RapierRigidBody2D] = []
@export var show_on_shut: Array[Sprite2D] = []
@export var hide_on_shut: Array[Sprite2D] = []

var lerp_body: RapierRigidBody2D = null
var _pin_joints: Array[RapierPinJoint2D] = []
var _current_collision_layer: int = -1

@onready var pin_joint_parent: Node2D = $PinJoint

func _ready() -> void:
	for body in limb_bodies:
		body.input_pickable = true
		body.input_event.connect(_click_event.bind(body))
		body.add_to_group("ToyBody")
	
	for joint in pin_joint_parent.get_children():
		joint.motor_position_stiffness = 10000
		joint.motor_position_damping = 100000
		_pin_joints.append(joint as RapierPinJoint2D)
		
func _physics_process(_delta: float) -> void:
	if lerp_body == null:
		return
	if Input.is_action_just_released("click"):
		emit_signal("body_dropped", lerp_body)
		lerp_body = null
		return
	_normalize_velocity(0.7)
	lerp_body.apply_central_force((get_global_mouse_position() - lerp_body.global_position) * LERP_WEIGHT)
	
func get_torso() -> RapierRigidBody2D:
	for body in limb_bodies:
		if body.is_in_group("TorsoBody"):
			return body
	return null
	
func set_limb_pos(index: int, motor_angle: float) -> void:
	_pin_joints[index].motor_position_enabled = true
	_pin_joints[index].motor_position_target_angle = motor_angle
	
func free_limbs_pos() -> void:
	for joint in _pin_joints:
		joint.motor_position_enabled = false
	
func disable_limbs() -> void:
	for body in limb_bodies:
		body.freeze = true
		body.set_collision_mask_value(_current_collision_layer, false)
		
func set_collision_mask(mask_layer: int) -> void:
	for body in limb_bodies:
		if _current_collision_layer > 0: body.set_collision_mask_value(_current_collision_layer, false)
		body.set_collision_mask_value(mask_layer, true)
	_current_collision_layer = mask_layer
	
func _click_event(viewport: Node, event: InputEvent, _shape_idx: int, body: RapierRigidBody2D) -> void:
	if event.is_action_pressed("click"):
		viewport.set_input_as_handled()
		if lerp_body == null:
			emit_signal("body_picked", body)
		lerp_body = body
		
func _normalize_velocity(delta: float) -> void:
	lerp_body.linear_velocity = Vector2.ZERO
	lerp_body.angular_velocity *= delta
