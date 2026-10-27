class_name HookSystem
extends Node

# TERMINAL, CHUTE, BENCH_BOT, BENCH_TOP, MAIN_ROOM
enum _MASK {TERMINAL = 10, CHUTE = 11, BENCH_BOT = 13, BENCH_TOP = 12, MAIN_ROOM = 9}

const _X_ARRAY: Array[float] = [670, 250, 800, 220, 320]
const _HANG_DIST := 150
const _LERP_WEIGHT := 400.0
const _ANGULAR_NORM := 0.2
const _COLOR_NORM := Color(1.0, 1.0, 1.0)
const _COLOR_HIGH := Color(4.0, 4.0, 4.0)

@export var _hook_sprite: Sprite2D
@export var _nav_system: NavSystem
@export var _toy_spawn: ToySpawn

var _current_toy: Toy = null
var _hanging_limb: RapierRigidBody2D = null
var _toy_visible_state: int = -1

func _enter_tree() -> void:
	add_to_group("ToyMonitor")
	_nav_system.state_change.connect(_move_hook)
	_toy_spawn.new_toy_spawned.connect(_new_toy_spawned)
	
func _physics_process(_delta: float) -> void:
	if _hanging_limb == null:
		return
	_hanging_limb.linear_velocity = Vector2.ZERO
	_hanging_limb.angular_velocity *= _ANGULAR_NORM
	_hanging_limb.apply_central_force((_hook_sprite.global_position + Vector2(float(_hook_sprite.texture.get_width()) /2, float(_hook_sprite.texture.get_height())) - _hanging_limb.global_position) * _LERP_WEIGHT)
	
# group callback function of the "ToyMonitor" Group
func clear_current_toy() -> void:
	if _current_toy == null:
		return
	if _current_toy.has_connections("body_dropped") and _current_toy.has_connections("body_picked"):
		_current_toy.disconnect("body_dropped", _hang_toy_limb)
		_current_toy.disconnect("body_picked", _unhang_toy_limb)
	
func _hang_toy_limb(check_limb: RapierRigidBody2D) -> void:
	_hook_sprite.self_modulate = _COLOR_NORM
	if _hanging_limb != null:
		return
	if check_limb.global_position.distance_to(_hook_sprite.global_position + (_hook_sprite.texture.get_size() / 2)) <= _HANG_DIST:
		_hanging_limb = check_limb
	
func _unhang_toy_limb(check_limb: RapierRigidBody2D) -> void:
	if _hanging_limb == null:
		_hook_sprite.self_modulate = _COLOR_HIGH
		return
	elif _hanging_limb != check_limb:
		return
	_hanging_limb = null
	
func _move_hook(index: int) -> void:
	_hook_sprite.global_position = Vector2(_X_ARRAY[index], 0)
	if _hanging_limb:
		_toy_visible_state = index
	_toggle_toy_visible(index)
	
func _toggle_toy_visible(current_state: int) -> void:
	if _current_toy == null or current_state < 0:
		return
	
	if current_state == _toy_visible_state:
		_current_toy.show()
		match current_state:
			_nav_system.BD.TERMINAL: _current_toy.set_collision_mask(_MASK.TERMINAL)
			_nav_system.BD.CHUTE: _current_toy.set_collision_mask(_MASK.CHUTE)
			_nav_system.BD.BENCH_BOT: _current_toy.set_collision_mask(_MASK.BENCH_BOT)
			_nav_system.BD.BENCH_TOP: _current_toy.set_collision_mask(_MASK.BENCH_TOP)
			_nav_system.BD.MAIN_ROOM: _current_toy.set_collision_mask(_MASK.MAIN_ROOM)
	else:
		_current_toy.hide()
	
func _new_toy_spawned(new_toy: Toy) -> void:
	_current_toy = new_toy
	_current_toy.body_dropped.connect(_hang_toy_limb)
	_current_toy.body_picked.connect(_unhang_toy_limb)
	_toy_visible_state = _nav_system.BD.MAIN_ROOM
	_toggle_toy_visible(_nav_system.current_bd.get_index())
