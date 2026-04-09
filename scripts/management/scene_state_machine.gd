extends Node

@onready var left_nav_button: Button = %LeftNavButton
@onready var top_nav_button: Button = %TopNavButton
@onready var bottom_nav_button: Button = %BottomNavButton
@onready var right_nav_button: Button = %RightNavButton

@onready var main_scene: Node2D = $RoomMainScene2D
@onready var terminal_scene: Node2D = $TerminalScene2D
@onready var workbench_scene: Node2D = $WorkbenchScene2D
@onready var chute_scene: Node2D = $ChuteScene2D

enum STATE {MAIN, TERMINAL, BENCH, CHUTE}

const WIDE_NAV := 500.0
const THIN_NAV := 200.0

var state: int

func _ready() -> void:
	left_nav_button.pressed.connect(change_state.bind(left_nav_button))
	top_nav_button.pressed.connect(change_state.bind(top_nav_button))
	bottom_nav_button.pressed.connect(change_state.bind(bottom_nav_button))
	right_nav_button.pressed.connect(change_state.bind(right_nav_button))
	
	_update_state(STATE.MAIN, null)

func change_state(button_pressed: Button) -> void:
	match state:
		STATE.MAIN:
			if button_pressed == left_nav_button:
				_update_state(STATE.TERMINAL, main_scene)
			elif button_pressed == top_nav_button:
				_update_state(STATE.BENCH, main_scene)
			elif button_pressed == right_nav_button:
				_update_state(STATE.CHUTE, main_scene)
				
		STATE.TERMINAL:
			if button_pressed == left_nav_button:
				_update_state(STATE.CHUTE, terminal_scene)
			elif button_pressed == bottom_nav_button:
				_update_state(STATE.MAIN, terminal_scene)
			elif button_pressed == right_nav_button:
				_update_state(STATE.BENCH, terminal_scene)
				
		STATE.BENCH:
			if button_pressed == left_nav_button:
				_update_state(STATE.TERMINAL, workbench_scene)
			elif button_pressed == bottom_nav_button:
				_update_state(STATE.MAIN, workbench_scene)
			elif button_pressed == right_nav_button:
				_update_state(STATE.CHUTE, workbench_scene)
			
		STATE.CHUTE:
			if button_pressed == left_nav_button:
				_update_state(STATE.BENCH, chute_scene)
			elif button_pressed == bottom_nav_button:
				_update_state(STATE.MAIN, chute_scene)
			elif button_pressed == right_nav_button:
				_update_state(STATE.TERMINAL, chute_scene)
			elif button_pressed == top_nav_button:
				print("signal to ship toy")
				
				
func _update_state(new_state: int, previous_scene: Node2D) -> void:
	state = new_state
	match state:
		STATE.MAIN: _init_main_state(previous_scene)
		STATE.TERMINAL: _init_terminal_state(previous_scene)
		STATE.BENCH: _init_bench_state(previous_scene)
		STATE.CHUTE: _init_chute_state(previous_scene)
		
func _side_button_width(new_width: float) -> void:
	left_nav_button.custom_minimum_size = Vector2(new_width, 0)
	right_nav_button.custom_minimum_size = Vector2(new_width, 0)
	
func _init_main_state(previous_scene: Node2D) -> void:
	if previous_scene != null:
		previous_scene.hide()
	main_scene.show()
	_side_button_width(WIDE_NAV)
	bottom_nav_button.disabled = true
	top_nav_button.disabled = false
	
func _init_terminal_state(previous_scene: Node2D) -> void:
	previous_scene.hide()
	terminal_scene.show()
	_side_button_width(THIN_NAV)
	bottom_nav_button.disabled = false
	top_nav_button.disabled = true
	
func _init_bench_state(previous_scene: Node2D) -> void:
	previous_scene.hide()
	workbench_scene.show()
	_side_button_width(THIN_NAV)
	bottom_nav_button.disabled = false
	top_nav_button.disabled = true
	
func _init_chute_state(previous_scene: Node2D) -> void:
	previous_scene.hide()
	chute_scene.show()
	_side_button_width(THIN_NAV)
	bottom_nav_button.disabled = false
	top_nav_button.disabled = false
