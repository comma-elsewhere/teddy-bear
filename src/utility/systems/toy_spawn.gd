class_name ToySpawn
extends Node

signal new_toy_spawned(new_toy: Toy)

const MIN_TIME := 2.0
const MAX_TIME := 4.0

@export var _spawn_point: Marker2D
@export var _toys: Array[PackedScene] = []

var spawn_timer := Timer.new()
var current_toy: Toy = null
var toy_prog: int = 0

func _enter_tree() -> void:
	add_to_group("ToyMonitor")
	
func _ready() -> void:
	spawn_timer.one_shot = true
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_spawn_toy)

func spawn_first_toy() -> void:
	_spawn_toy()

# group callback function of the "ToyMonitor" Group
func clear_current_toy() -> void:
	if current_toy == null or !spawn_timer.is_stopped():
		return
	spawn_timer.start( randf_range(MIN_TIME, MAX_TIME) )
	current_toy.get_parent().remove_child(current_toy)
	current_toy.call_deferred("queue_free")

func _spawn_toy() -> void:
	current_toy = _toys[toy_prog].instantiate() as Toy
	
	_spawn_point.global_rotation_degrees = randi_range(0, 355)
	_spawn_point.global_position.x = randi_range(450, 1500)
	_spawn_point.global_position.y = randi_range(-900, -700)
	
	_spawn_point.add_child(current_toy)
	current_toy.z_index = 20
	emit_signal("new_toy_spawned", current_toy)
	%TerminalControl.set_new_data(current_toy.toy_data)
	
	toy_prog += 1
	if toy_prog >= _toys.size():
		toy_prog = 0
