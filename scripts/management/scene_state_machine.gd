class_name SceneStateMachine extends Node

enum STATE {MAIN, TERMINAL, BENCH, CHUTE}

@onready var room_layer: CanvasLayer = %RoomLayer
@onready var terminal_layer: CanvasLayer = %TerminalLayer
@onready var bench_layer: CanvasLayer = %BenchLayer
@onready var chute_layer: CanvasLayer = %ChuteLayer

@onready var terminal_nav: PanelContainer = %TerminalNav
@onready var bench_nav: PanelContainer = %BenchNav
@onready var chute_nav: PanelContainer = %ChuteNav

@onready var table_margins: MarginContainer = %TableMargins
@onready var laundry_margins: MarginContainer = %LaundryMargins

@onready var anim_sfx: AnimationPlayer = %AnimSFX

var old_state: int = -1
var current_state: int = -1

# connect gui input to scene navigation
# user input to scene navigation
# scene navigation == state change
# establish each state: main, terminal, bench, and chute
# two-part change state / nav function, part one plays animation (scene swap), part two is triggered by the animation player to ensure timing (transition)
# in main room, left right front determines which scene you go to
# in scenes left and right cycle between scenes, and back takes you back
# in workbench front cycles between bench and underneath, otherwise in scenes front does nothing
# on ready, current state == main room, play fade-in animation, and perform startup initializations

func _ready() -> void:
	terminal_nav.gui_input.connect(_on_nav_gui_input.bind(STATE.TERMINAL))
	bench_nav.gui_input.connect(_on_nav_gui_input.bind(STATE.BENCH))
	chute_nav.gui_input.connect(_on_nav_gui_input.bind(STATE.CHUTE))
	
	table_margins.show()
	laundry_margins.hide()
	
	#_set_scene(STATE.MAIN)

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
