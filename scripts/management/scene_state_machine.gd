class_name SceneStateMachine extends Node

signal toy_created(file: DemoPatientFile)
signal toy_trashed()

enum STATE {MAIN, TERMINAL, BENCH, CHUTE}

const TOY_BODY := preload("uid://bv027w1ur8f51")
const GRAB_DIST := 100
const HOOK_POS : Array[Vector2] = [Vector2(330,0),Vector2(695,0),Vector2(210,0),Vector2(135,0)]

@onready var room_layer: CanvasLayer = %RoomLayer
@onready var terminal_layer: CanvasLayer = %TerminalLayer
@onready var bench_layer: CanvasLayer = %BenchLayer
@onready var chute_layer: CanvasLayer = %ChuteLayer

@onready var table_margins: Sprite2D = %TableMargins
@onready var laundry_margins: Sprite2D = %LaundryMargins
@onready var shipping_area: ShippingArea = %ShippingArea

@onready var main_root: Node2D = %MainRoot
@onready var meat_hook: Sprite2D = %MeatHook

@onready var anim_sfx: AnimationPlayer = %AnimSFX

var toy: ToyBody = null
var state_array: Array[CanvasLayer] = []

var old_state: int = -1
var current_state: int = -1
var toy_state: int = -1

func _ready() -> void:
	state_array = [room_layer, terminal_layer, bench_layer, chute_layer]
	# pre-start cleanup
	# All these need to start hidden
	_bench_laundry_hide()
	room_layer.hide()
	terminal_layer.hide()
	bench_layer.hide()
	chute_layer.hide()
	# Connect Signals
	shipping_area.ship_toy.connect(_trash_toy)
	
	# Actual scene setup
	_set_scene(STATE.MAIN)

func _input(event: InputEvent) -> void:
	if !anim_sfx.is_playing():
		
		# Handle user input nav for state machine
		if event.is_action_pressed("nav_back"):
			match current_state:
				STATE.TERMINAL: _swap_scene(STATE.MAIN)
				STATE.BENCH: 
					_swap_scene(STATE.MAIN)
					await get_tree().create_timer(0.45).timeout
					_bench_laundry_hide()
				STATE.CHUTE: _swap_scene(STATE.MAIN)
			return
		if event.is_action_pressed("nav_front"):
			match current_state:
				STATE.MAIN: 
					_swap_scene(STATE.BENCH)
					await get_tree().create_timer(0.45).timeout
					_bench_laundry_toggle()
				STATE.BENCH: _bench_laundry_toggle(!table_margins.visible)
			return
		if event.is_action_pressed("nav_left"):
			match current_state:
				STATE.MAIN: _swap_scene(STATE.TERMINAL)
				STATE.TERMINAL: _swap_scene(STATE.CHUTE)
				STATE.BENCH: 
					_swap_scene(STATE.TERMINAL)
					await get_tree().create_timer(0.45).timeout
					_bench_laundry_hide()
				STATE.CHUTE: 
					_swap_scene(STATE.BENCH)
					await get_tree().create_timer(0.45).timeout
					_bench_laundry_toggle()
			return
		if event.is_action_pressed("nav_right"):
			match current_state:
				STATE.MAIN: _swap_scene(STATE.CHUTE)
				STATE.TERMINAL: 
					_swap_scene(STATE.BENCH)
					await get_tree().create_timer(0.45).timeout
					_bench_laundry_toggle()
				STATE.BENCH: 
					_swap_scene(STATE.CHUTE)
					await get_tree().create_timer(0.45).timeout
					_bench_laundry_hide()
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
	_set_hook_pos()
	# update toy position if it's on the hook
	if toy == null:
		return
	if toy.hooked: # change toy state if on hook
		_change_toy_state(current_state)
		await get_tree().process_frame
		toy.call_deferred("update_hook", _get_hook_pos())
	else:
		_check_toy_state() # toggle collision if not hooked
	
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
func _bench_laundry_hide() -> void:
	table_margins.hide()
	laundry_margins.hide()
	
func _bench_laundry_toggle(show_bench: bool = true) -> void:
	table_margins.visible = show_bench
	laundry_margins.visible = !show_bench
	
# creates new toy, connects grabbed signal to toy grabbed func, and sets a random position above player pov so it will fall into screen 
# set toy state to main state and then checks if the toy should be visible
func spawn_toy() -> void:
	toy = TOY_BODY.instantiate()
	toy_created.emit(toy.toy_res.get_file())
	toy.grabbed.connect(_toy_grabbed)
	await get_tree().create_timer(2.0).timeout
	main_root.call_deferred("add_child", toy)
	toy.global_position = Vector2( randf_range(400, 1200), randf_range(-600, -1000) )
	toy.global_rotation_degrees = randf_range(0, 360)
	toy.set_visibility_layer_bit(2, true)
	_change_toy_state() # Default to main state
	
# Take the toy on and off the hook --- is_held is the 'last body part held by the player' and will lerp to _get_hook_pos() while toy.hooked

func _toy_grabbed(is_held: RigidBody2D) -> void:
	if is_held == null:
		return
	if toy.hooked: # detach toy and change toy state to current room so its visibility updates when room changes
		toy.detach_hook()
		_change_toy_state(current_state)
		return
	if is_held.global_position.distance_to(_get_hook_pos()) < GRAB_DIST: # attach toy to hook
		toy.attach_hook(_get_hook_pos())
		return
	#if is_held.global_position.distance_to(_get_trash_pos()) < GRAB_DIST: # destroy toy and spawn a new one
		#_trash_toy()
		
func _trash_toy() -> void:
	toy.get_parent().remove_child(toy)
	toy.queue_free()
	toy_trashed.emit()
		
# Updates toy state --- default to main state where the toy spawns
# toy state determines which area the toy should be visible in when it is not on the hook
func _change_toy_state(new_state: int = STATE.MAIN) -> void:
	toy.call_deferred("reparent", state_array[new_state])
	toy_state = new_state
	_check_toy_state()
	
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
	return meat_hook.global_position + (Vector2(meat_hook.texture.get_size().x/2, meat_hook.texture.get_size().y)) * meat_hook.scale
	
#func _get_trash_pos() -> Vector2:
	#return trash_can.global_position + (trash_can.size/2)

# Changes the margin_left of the hook_margins, thereby moving the hook around the screen based on state
func _set_hook_pos() -> void:
	meat_hook.reparent(state_array[current_state])
	meat_hook.global_position = HOOK_POS[current_state]
	meat_hook.move_to_front()
