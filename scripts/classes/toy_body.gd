class_name ToyBody extends Node2D

@onready var torso_body: RigidBody2D = %Torso
@onready var left_leg_body: RigidBody2D = %LeftLeg
@onready var left_arm_body: RigidBody2D = %LeftArm
@onready var right_leg_body: RigidBody2D = %RightLeg
@onready var right_arm_body: RigidBody2D = %RightArm
@onready var head_body: RigidBody2D = %Head

enum LOCATION {TORSO_HEART, TORSO_NECK, TORSO_TUMMY, TORSO_ABDOMEN, TORSO_GROIN, LEFT_LEG, LEFT_ARM, RIGHT_FOOT, RIGHT_THIGH, RIGHT_HAND, RIGHT_SHOULDER, HEAD_LEFT, HEAD_RIGHT}
enum PART {TORSO, LEFT_ARM, LEFT_LEG, RIGHT_ARM, RIGHT_LEG, HEAD}

const ADDITIONAL : Array[Vector2] = [Vector2(19, -89), Vector2(-16, -127), Vector2(5, 51), Vector2(-79, 135), Vector2(-17, 161), Vector2(-15, 85), Vector2(24, 72), Vector2(-15, 131), Vector2(-5, -19), Vector2(-4, 130), Vector2(4, -38), Vector2(-51, -106), Vector2(60, -99)] # Accessory locations
const GRAVITY_SCALE : Array[float] = [1.25, 0.75, 0.9, 0.75, 0.9, 1.0]

var is_held: RigidBody2D = null
var bodies: Array[RigidBody2D] = []

func _ready() -> void:
	bodies = [torso_body, left_arm_body, left_leg_body, right_arm_body, right_leg_body, head_body]
# report collisions for thump sounds
# report mouse events for click and drag
	for body in bodies:
		body.input_pickable = true
		body.contact_monitor = true
		body.max_contacts_reported = 1
		body.body_entered.connect(_thump_sound.bind(body))
		body.input_event.connect(_mouse_event.bind(body))
	
func _physics_process(delta: float) -> void:
	global_position = torso_body.global_position
	if is_held == null:
		return
	is_held.global_position = lerp(is_held.global_position, get_global_mouse_position(), delta * 10.0)
	is_held.linear_velocity = Vector2.ZERO
	is_held.angular_velocity *= 0.5
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed and is_held:
			_drop(Input.get_last_mouse_velocity())

func _thump_sound(body: Node, _location: RigidBody2D) -> void:
	if body != RigidBody2D:
		#print("thump")
		pass

func _mouse_event(_viewport: Node, event: InputEvent, _shape_idx: int, body: RigidBody2D) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and !is_held:
			_pickup(body)

# click and drag --> freeze body part and lerp to mouse position
func _toggle_gravity(toggle: bool) -> void:
	for i in len(bodies):
		if toggle:
			bodies[i].gravity_scale = 0.01
		else:
			bodies[i].gravity_scale = GRAVITY_SCALE[i]

func _pickup(body: RigidBody2D) -> void:
	if is_held:
		return
	#_toggle_gravity(true)
	is_held = body

func _drop(mouse_velocity: Vector2 = Vector2.ZERO) -> void:
	if is_held:
		#_toggle_gravity(false)
		is_held = null
		for body in bodies:
			body.apply_central_impulse(mouse_velocity / 1000)
