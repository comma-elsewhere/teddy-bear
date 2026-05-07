class_name ToyBody extends CanvasGroup

@export var toy_res: ToyDetails

@onready var torso_body: RigidBody2D = %Torso
@onready var left_leg_body: RigidBody2D = %LeftLeg
@onready var left_arm_body: RigidBody2D = %LeftArm
@onready var right_leg_body: RigidBody2D = %RightLeg
@onready var right_arm_body: RigidBody2D = %RightArm
@onready var head_body: RigidBody2D = %Head

enum LOCATION {TORSO_HEART, TORSO_NECK, TORSO_TUMMY, TORSO_ABDOMEN, TORSO_GROIN, LEFT_LEG, LEFT_ARM, RIGHT_FOOT, RIGHT_THIGH, RIGHT_HAND, RIGHT_SHOULDER, HEAD_LEFT, HEAD_RIGHT}

const ADDITIONAL : Array[Vector2] = [Vector2(19, -89), Vector2(-16, -127), Vector2(5, 51), Vector2(-79, 135), Vector2(-17, 161), Vector2(-15, 85), Vector2(24, 72), Vector2(-15, 131), Vector2(-5, -19), Vector2(-4, 130), Vector2(4, -38), Vector2(-51, -106), Vector2(60, -99)] # Accessory locations
const GRAVITY_SCALE : Array[float] = [1.25, 0.75, 0.9, 0.75, 0.9, 1.0]

var area_spawner := AreaSpawner.new()
var card_display := CardSpawner.new()
var texture_loader := TextureLoader.new()

var is_held: RigidBody2D = null # tracks the current body part being held
var bodies: Array[RigidBody2D] = [] # Array of body parts for connections and calls

func _ready() -> void:
# assign parts to bodies array
	bodies = [torso_body, left_arm_body, left_leg_body, right_arm_body, right_leg_body, head_body]
	texture_loader.initiate(toy_res, bodies)

# assign each part in bodies relevant flags and signals
	for body in bodies:
		body.input_pickable = true # allows mouse input
		body.contact_monitor = true # tracks collisions
		body.max_contacts_reported = 1 # max collisions reported
		body.body_entered.connect(_thump_sound.bind(body)) # signal collisions for thump sounds to specific body part
		body.input_event.connect(_mouse_event.bind(body)) # signal mouse events for click and drag to specific body part
	
func _physics_process(delta: float) -> void:
	if is_held == null: # if nothing is being held, return
		return
	is_held.global_position = lerp(is_held.global_position, is_held.get_global_mouse_position(), delta * 10.0)
 # stop gravity effects and previous momentum etc
	is_held.linear_velocity = Vector2.ZERO
	is_held.angular_velocity *= 0.5
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed and is_held:
			_drop(Input.get_last_mouse_velocity()) # Call drop if something is held and you un-click

func _thump_sound(body: Node, _location: RigidBody2D) -> void:
	# Prevent sound from triggering on hitting other limbs of self
	for i in bodies:
		if body == i:
			return
	# Play a fabric-y thump at location.global_position

func _mouse_event(_viewport: Node, event: InputEvent, _shape_idx: int, body: RigidBody2D) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and !is_held:
			_pickup(body) # Call pickup if nothing is held and you click a body part

# set body being held to body clicked
func _pickup(body: RigidBody2D) -> void:
	if is_held:
		return
	is_held = body

# set body being held to null, and apply last mouse velocity as central impulse to all body parts (time-independent, one-frame force, no rotation)
func _drop(mouse_velocity: Vector2 = Vector2.ZERO) -> void:
	if is_held:
		is_held = null
		for body in bodies:
			body.apply_central_impulse(mouse_velocity / 1000)
