class_name ToySpawn
extends Node

signal new_toy_spawned(new_toy: Toy)

@export var _spawn_point: Marker2D
@export var _toys: Array[PackedScene] = []

var current_toy: Toy = null

func _enter_tree() -> void:
	add_to_group("ToyMonitor")

# temp for testing and debugging --- REMOVE BEFORE BETA
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_tree().call_group("ToyMonitor", "clear_current_toy")
		_spawn_toy(0)

# group callback function of the "ToyMonitor" Group
func clear_current_toy() -> void:
	if current_toy == null:
		return
	current_toy.get_parent().remove_child(current_toy)
	current_toy.call_deferred("queue_free")

func _spawn_toy(index: int) -> void:
	current_toy = _toys[index].instantiate() as Toy
	
	_spawn_point.global_rotation_degrees = randi_range(0, 355)
	_spawn_point.global_position.x = randi_range(450, 1500)
	_spawn_point.global_position.y = randi_range(-1300, -750)
	
	_spawn_point.add_child(current_toy)
	emit_signal("new_toy_spawned", current_toy)
