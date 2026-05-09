class_name SceneStateMachine extends Node

enum STATE {MAIN, TERMINAL, BENCH, CHUTE}

const TOY_BODY := preload("uid://bv027w1ur8f51")
const HOOK_DIST := 100
const MARGIN : Array[int] = [450, 650, 350, 300]

@onready var room_layer: CanvasLayer = %RoomLayer
@onready var terminal_layer: CanvasLayer = %TerminalLayer
@onready var bench_layer: CanvasLayer = %BenchLayer
@onready var chute_layer: CanvasLayer = %ChuteLayer

@onready var table_margins: MarginContainer = %TableMargins
@onready var laundry_margins: MarginContainer = %LaundryMargins

@onready var main_root: Node2D = %MainRoot
@onready var hook_margin: MarginContainer = %HookMargin
@onready var meat_hook: TextureRect = %MeatHook

@onready var anim_sfx: AnimationPlayer = %AnimSFX

var toy: ToyBody = null

var old_state: int = -1
var current_state: int = -1
var toy_state: int = -1

func _ready() -> void:
	# pre-start cleanup
	table_margins.show() # Needs to start visible for the bench toggle to work
	laundry_margins.hide() # Needs to start ooposite of table margins
	# All these need to start hidden
	room_layer.hide()
	terminal_layer.hide()
	bench_layer.hide()
	chute_layer.hide()
	
	# Actual scene setup
	_spawn_toy()
	_set_scene(STATE.MAIN)

func _input(event: InputEvent) -> void:
	if !anim_sfx.is_playing():
		if event.is_action_pressed("ui_accept"): # TEMP FOR DEBUGGING --- clears current toy from scene tree and creates a new toy 
			main_root.remove_child(toy)
			toy.queue_free()
			_spawn_toy()
		
		# Handle user input nav for state machine
		if event.is_action_pressed("nav_back"):
			match current_state:
				STATE.TERMINAL: _swap_scene(STATE.MAIN)
				STATE.BENCH: _swap_scene(STATE.MAIN)
				STATE.CHUTE: _swap_scene(STATE.MAIN)
			return
		if event.is_action_pressed("nav_front"):
			match current_state:
				STATE.MAIN: _swap_scene(STATE.BENCH)
				STATE.BENCH: _toggle_bench()
			return
		if event.is_action_pressed("nav_left"):
			match current_state:
				STATE.MAIN: _swap_scene(STATE.TERMINAL)
				STATE.TERMINAL: _swap_scene(STATE.CHUTE)
				STATE.BENCH: _swap_scene(STATE.TERMINAL)
				STATE.CHUTE: _swap_scene(STATE.BENCH)
			return
		if event.is_action_pressed("nav_right"):
			match current_state:
				STATE.MAIN: _swap_scene(STATE.CHUTE)
				STATE.TERMINAL: _swap_scene(STATE.BENCH)
				STATE.BENCH: _swap_scene(STATE.CHUTE)
				STATE.CHUTE: _swap_scene(STATE.TERMINAL)
			return
		
# connect to gui_input from control nodes and bind the state they should nav to
func _on_nav_gui_input(event: InputEvent, state: int) -> void:
	if event is InputEventMouseButton and !anim_sfx.is_playing():
		_swap_scene(state)
		
# Called by the animation sfx "fade_trans"
# Hides old state and shows new state, sets correct hook margins, toy visibility based on toy state, and updates toy location if it's on the hook
func transition() -> void:
	for state in [old_state, current_state]:
		match state:
			STATE.MAIN: 
				room_layer.visible = !room_layer.visible
			STATE.TERMINAL: 
				terminal_layer.visible = !terminal_layer.visible
			STATE.BENCH: 
				bench_layer.visible = !bench_layer.visible
			STATE.CHUTE: 
				chute_layer.visible = !chute_layer.visible
	_get_hook_margins()
	_check_toy_state()
	if toy.hooked:
		await get_tree().process_frame
		toy.call_deferred("update_hook", _get_hook_pos())
	
# Called once by _ready(), after this old state will need to be reset
func _set_scene(new_state: int) -> void:
	current_state = new_state
	anim_sfx.play("fade_in") # fade in from black, cue transition()
	
# sets both old state and current state, then "fade_trans" with the animation player which will trigger transition()
func _swap_scene(new_state: int) -> void:
	old_state = current_state
	current_state = new_state
	anim_sfx.play("fade_trans") # crossfade with black, transition() in the middle

# toggles whether you are on upper or lower part of bench --- remains constant throughout state changes
func _toggle_bench() -> void:
	table_margins.visible = !table_margins.visible
	laundry_margins.visible = !laundry_margins.visible

# creates new toy, connects grabbed signal to toy grabbed func, and sets a random position above player pov so it will fall into screen 
# set toy state to main state and then checks if the toy should be visible
func _spawn_toy() -> void:
	toy = TOY_BODY.instantiate()
	toy.grabbed.connect(_toy_grabbed)
	main_root.add_child(toy)
	toy.global_position = Vector2( randf_range(400, 1200), randf_range(-600, -1000) )
	toy.global_rotation_degrees = randf_range(0, 360)
	_change_toy_state() # Default to main state
	_check_toy_state()
	
# Take the toy on and off the hook --- is_held is the 'last body part held by the player' and will lerp to _get_hook_pos() while toy.hooked

func _toy_grabbed(is_held: RigidBody2D) -> void:
	if is_held == null:
		return
	if toy.hooked:
		toy.detach_hook()
		_change_toy_state(current_state)
		return
	if is_held.global_position.distance_to(_get_hook_pos()) < HOOK_DIST:
		toy.attach_hook(_get_hook_pos())
		
# Updates toy state --- default to main state where the toy spawns
# toy state determines which area the toy should be visible in when it is not on the hook
func _change_toy_state(new_state: int = STATE.MAIN) -> void:
	toy_state = new_state
	
# if current state is not toy state, and toy is not on the hook --> toy will be hidden and un-interactable
# else: toy is visible and clickable
func _check_toy_state() -> void:
	if !toy.hooked:
		if toy_state != current_state:
			toy.hide()
			toy.toggle_collision(false) # toggles input_pickable value
			return
	toy.show()
	toy.toggle_collision(true)

# returns the center bottom of the meat hook texture
func _get_hook_pos() -> Vector2:
	return meat_hook.global_position + (Vector2(meat_hook.size.x/2, meat_hook.size.y))

# Changes the margin_left of the hook_margins, thereby moving the hook around the screen based on state
func _get_hook_margins() -> void:
	hook_margin.remove_theme_constant_override("margin_left")
	match current_state:
		STATE.MAIN: hook_margin.add_theme_constant_override("margin_left", MARGIN[STATE.MAIN])
		STATE.TERMINAL: hook_margin.add_theme_constant_override("margin_left", MARGIN[STATE.TERMINAL])
		STATE.BENCH: hook_margin.add_theme_constant_override("margin_left", MARGIN[STATE.BENCH])
		STATE.CHUTE: hook_margin.add_theme_constant_override("margin_left", MARGIN[STATE.CHUTE])
