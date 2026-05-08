class_name SceneStateMachine extends Node

enum STATE {MAIN, TERMINAL, BENCH, CHUTE}

const TOY_BODY := preload("uid://bv027w1ur8f51")
const TOY_SPAWN := Vector2(950, -1800)
const HOOK_DIST := 20.0

@onready var room_layer: CanvasLayer = %RoomLayer
@onready var terminal_layer: CanvasLayer = %TerminalLayer
@onready var bench_layer: CanvasLayer = %BenchLayer
@onready var chute_layer: CanvasLayer = %ChuteLayer

@onready var terminal_nav: PanelContainer = %TerminalNav
@onready var bench_nav: PanelContainer = %BenchNav
@onready var chute_nav: PanelContainer = %ChuteNav

@onready var table_margins: MarginContainer = %TableMargins
@onready var laundry_margins: MarginContainer = %LaundryMargins

@onready var main_root: Node2D = %MainRoot
@onready var hook_margin: MarginContainer = %HookMargin
@onready var hook_point: Control = %HookPoint

@onready var anim_sfx: AnimationPlayer = %AnimSFX

var toy: ToyBody = null

var old_state: int = -1
var current_state: int = -1

func _ready() -> void:
	#terminal_nav.gui_input.connect(_on_nav_gui_input.bind(STATE.TERMINAL))
	#bench_nav.gui_input.connect(_on_nav_gui_input.bind(STATE.BENCH))
	#chute_nav.gui_input.connect(_on_nav_gui_input.bind(STATE.CHUTE))
	
	table_margins.show()
	laundry_margins.hide()
	
	_spawn_toy()
	_set_scene(STATE.MAIN)

func _input(event: InputEvent) -> void:
	if !anim_sfx.is_playing():
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
		
func _on_nav_gui_input(event: InputEvent, state: int) -> void:
	if event is InputEventMouseButton and !anim_sfx.is_playing():
		_swap_scene(state)
		
func transition() -> void:
	for state in [old_state, current_state]:
		match state:
			STATE.MAIN: room_layer.visible = !room_layer.visible
			STATE.TERMINAL: terminal_layer.visible = !terminal_layer.visible
			STATE.BENCH: bench_layer.visible = !bench_layer.visible
			STATE.CHUTE: chute_layer.visible = !chute_layer.visible
			
func _set_scene(new_state: int) -> void:
	current_state = new_state
	anim_sfx.play("fade_in")
	
func _swap_scene(new_state: int) -> void:
	old_state = current_state
	current_state = new_state
	anim_sfx.play("fade_trans")

func _toggle_bench() -> void:
	table_margins.visible = !table_margins.visible
	laundry_margins.visible = !laundry_margins.visible

func _spawn_toy() -> void:
	toy = TOY_BODY.instantiate()
	toy.grabbed.connect(_toy_grabbed)
	main_root.add_child(toy)
	toy.global_position = TOY_SPAWN
	
func _toy_grabbed(is_held: RigidBody2D) -> void:
	if is_held == null:
		return
	if toy.hooked:
		print("detach")
		toy.detach_hook()
		return
	if abs(is_held.global_position - hook_point.global_position) < Vector2(30,30):
		print(is_held)
		toy.attach_hook(hook_point.global_position)
