class_name StickyArea
extends Area2D

const JOINT_POS: Array[float] = [0,30,-30,20,-20]

var _lerp_torso: RapierRigidBody2D = null

func _ready() -> void:
	body_entered.connect(_detect_torso)
	body_exited.connect(_drop_body)
	
func _physics_process(delta: float) -> void:
	if _lerp_torso == null:
		return
	_lerp_torso.linear_velocity = Vector2.ZERO
	_lerp_torso.angular_velocity *= 0.1
	_lerp_torso.apply_central_force((global_position - _lerp_torso.global_position) * 1000)
	_lerp_torso.global_rotation = lerp_angle(_lerp_torso.global_rotation, deg_to_rad(0), 20 * delta)
	
func _detect_torso(body: Node2D) -> void:
	if body.is_in_group("TorsoBody"):
		_lerp_torso = body as RapierRigidBody2D
		_set_limb_positions(body.get_parent() as Toy)
		
func _drop_body(body: Node2D) -> void:
	if body == _lerp_torso:
		_lerp_torso.get_parent().free_limbs_pos()
		_lerp_torso = null
		
func _set_limb_positions(toy: Toy) -> void:
	for i in len(JOINT_POS):
		toy.set_limb_pos(i, JOINT_POS[i])
