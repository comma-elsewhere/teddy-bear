class_name ToyBody extends CanvasGroup

@onready var torso_texture_closed: Sprite2D = %TorseAtlasTextureClosed
@onready var torso_texture_open: Sprite2D = %TorseAtlasTextureOpen

@onready var torso_body: RigidBody2D = $Torso
@onready var left_leg_body: RigidBody2D = $LeftLeg
@onready var left_arm_body: RigidBody2D = $LeftArm
@onready var right_leg_body: RigidBody2D = $RightLeg
@onready var right_arm_body: RigidBody2D = $RightArm
@onready var head_body: RigidBody2D = $Head

var is_held: bool = false
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
		body.input_event.connect(_mouse_event)
	
func _physics_process(delta: float) -> void:
	if !is_held:
		return
	global_position = lerp(global_position, get_global_mouse_position(), delta * 10.0)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed and is_held:
			_drop(Input.get_last_mouse_velocity())

func _thump_sound(_body: Node, _location: RigidBody2D) -> void:
	#location.global_position
	pass

func _mouse_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and !is_held:
			_pickup()

# click and drag --> freeze body part and lerp to mouse position
func _toggle_freeze(toggle: bool) -> void:
	for body in bodies:
		body.freeze = toggle

func _pickup():
	if is_held:
		return
	_toggle_freeze(true)
	is_held = true

func _drop(mouse_velocity: Vector2 = Vector2.ZERO):
	if is_held:
		_toggle_freeze(false)
		is_held = false
		for body in bodies:
			body.apply_central_impulse(mouse_velocity)
