@abstract class_name RepairArea
extends Area2D

@warning_ignore("unused_signal")
signal repair_attempted(repair_area: RepairArea, type: int)

const RADIUS := 50.0

func _enter_tree() -> void:
	add_to_group("RepairArea")
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_layer_value(8, true)
	set_collision_mask_value(8, true)
	set_deferred("input_pickable", false)
	
func toggle_monitor(enable: bool = true) -> void:
	set_deferred("monitorable", enable)
	set_deferred("monitoring", enable)
	
func attempt_repair(_tool_type: int) -> void:
	return

func add_collision() -> void:
	var collision := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = RADIUS
	collision.shape = shape
	add_child(collision)
