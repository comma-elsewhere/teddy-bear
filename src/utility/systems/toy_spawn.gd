class_name ToySpawn
extends Node

signal new_toy_spawned(new_toy: Toy)

@export var _spawn_point: Marker2D
@export var _toys: Array[PackedScene] = []

var current_toy: Toy = null
var toy_prog: int = 0

func _enter_tree() -> void:
	add_to_group("ToyMonitor")

func spawn_first_toy() -> void:
	_spawn_toy(toy_prog)

# group callback function of the "ToyMonitor" Group
func clear_current_toy() -> void:
	if current_toy == null:
		return
	current_toy.get_parent().remove_child(current_toy)
	current_toy.call_deferred("queue_free")
	_spawn_toy(toy_prog)

func _spawn_toy(index: int) -> void:
	current_toy = _toys[index].instantiate() as Toy
	
	_spawn_point.global_rotation_degrees = randi_range(0, 355)
	_spawn_point.global_position.x = randi_range(450, 1500)
	_spawn_point.global_position.y = randi_range(-1300, -750)
	
	_spawn_point.add_child(current_toy)
	current_toy.z_index = 20
	emit_signal("new_toy_spawned", current_toy)
	%TerminalControl.set_new_data(current_toy.toy_data)
	
	toy_prog += 1
	if toy_prog > _toys.size():
		toy_prog = 0
