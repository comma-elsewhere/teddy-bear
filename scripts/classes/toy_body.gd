class_name ToyBody extends CanvasGroup

const FABRIC_1 := preload("uid://duxnrn3xp2ng5")
const FABRIC_2 := preload("uid://ckt7gitt510xq")

signal grabbed(is_grabbed: RigidBody2D)

@export var toy_res: ToyDetails

@onready var torso_body: RigidBody2D = %Torso
@onready var left_leg_body: RigidBody2D = %LeftLeg
@onready var left_arm_body: RigidBody2D = %LeftArm
@onready var right_leg_body: RigidBody2D = %RightLeg
@onready var right_arm_body: RigidBody2D = %RightArm
@onready var head_body: RigidBody2D = %Head

const DETACH_DIST := 100
const HOOK_LERP := 16.0
const MOUSE_LERP := 8.0
const HOOK_DRAG := 80
const TOSS_DAMP := 1600

var area_spawner := AreaSpawner.new()
var texture_loader := TextureLoader.new()

var hooked: bool = false
var hooked_held: RigidBody2D = null
var is_held: RigidBody2D = null # tracks the current body part being held
var bodies: Array[RigidBody2D] = [] # Array of body parts for connections and calls

var _sounds_playing: int = 0
var _hook_point: Vector2

func _ready() -> void:
# assign parts to bodies array
	bodies = [torso_body, left_arm_body, left_leg_body, right_arm_body, right_leg_body, head_body]
	
# initiate and load classes with toy res
	texture_loader.initiate(toy_res, bodies)
	area_spawner.initiate(toy_res, bodies)
	
	if toy_res.dirty_or_stain:
		modulate = toy_res.dirt
		
# assign to group
	add_to_group("Toy")
	
# assign each part in bodies relevant flags and signals and groups
	for body in bodies:
		body.input_pickable = true # allows mouse input
		body.contact_monitor = true # tracks collisions
		body.max_contacts_reported = 1 # max collisions reported
		body.body_entered.connect(_thump_sound.bind(body)) # signal collisions for thump sounds to specific body part
		body.input_event.connect(_mouse_event.bind(body)) # signal mouse events for click and drag to specific body part
		body.add_to_group("ToyBody")
		
func _physics_process(delta: float) -> void:
	if is_held == null: # if nothing is being held, return
		return
	if hooked:
		is_held.global_position = is_held.global_position.lerp(_hook_point, delta * HOOK_LERP)
		_normalize_velocity(0.7)
		if hooked_held != null:
			hooked_held.apply_central_force((hooked_held.get_global_mouse_position() - hooked_held.global_position) * HOOK_DRAG)
		return
	is_held.global_position = is_held.global_position.lerp(is_held.get_global_mouse_position(), delta * MOUSE_LERP)
	_normalize_velocity(0.5)

#drop is_held when mouse is let go from anywhere on screen, even if not currently colliding with body
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed:
			grabbed.emit(is_held)
			_drop(Input.get_last_mouse_velocity())
			if hooked:
				hooked_held = null

# attaches to hook and assigns hook point
func attach_hook(hook_point: Vector2) -> void:
	hooked = true
	_hook_point = hook_point

# detaches from hook in main root
func detach_hook() -> void:
	if is_held == hooked_held:
		hooked = false
	
# make it jerkily move in appropriate direction when position updates
func update_hook(hook_point: Vector2) -> void:
	var dist_moved := hook_point - _hook_point
	_hook_point = hook_point
	for body in bodies:
		body.apply_central_impulse(dist_moved)
	
	
# Allows mouse collision
func toggle_collision(allow: bool) -> void:
	for body in bodies:
		body.input_pickable = allow
	
	
# stop gravity effects and previous momentum etc
func _normalize_velocity(angular: float) -> void:
	is_held.linear_velocity = Vector2.ZERO
	is_held.angular_velocity *= angular

func _thump_sound(body: Node, location: RigidBody2D) -> void:
	# Prevent sound from triggering on hitting other limbs of self
	for i in bodies:
		if body == i:
			return
	if _sounds_playing > 0:
		return
	# Play random fabric sound at location
	_sounds_playing += 1
	var audio_player := AudioStreamPlayer2D.new()
	audio_player.stream = [FABRIC_1, FABRIC_2].pick_random()
	audio_player.bus = &"SFX"
	add_child(audio_player)
	audio_player.global_position = location.global_position
	audio_player.play(0.15)
	# Clear from scene when finished 
	await audio_player.finished
	remove_child(audio_player)
	audio_player.queue_free()
	_sounds_playing -= 1

func _mouse_event(_viewport: Node, event: InputEvent, _shape_idx: int, body: RigidBody2D) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_pickup(body) # Call pickup if nothing is held and you click a body part

# set body being held to body clicked
func _pickup(body: RigidBody2D) -> void:
	if hooked:
		hooked_held = body
		
		if hooked_held == is_held:
			grabbed.emit(hooked_held)
			hooked_held = null
			return
			
	if is_held:
		return
	is_held = body
	
# set body being held to null, and apply last mouse velocity as central impulse to all body parts (time-independent, one-frame force, no rotation)
func _drop(mouse_velocity: Vector2 = Vector2.ZERO) -> void:
	if hooked:
		return
	if is_held:
		is_held = null
		hooked_held = null
		for body in bodies:
			body.apply_central_impulse(mouse_velocity / TOSS_DAMP)
