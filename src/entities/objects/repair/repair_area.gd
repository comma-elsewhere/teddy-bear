@abstract class_name RepairArea
extends Area2D

@warning_ignore("unused_signal")
signal repair_attempted(repair_area: RepairArea, tool_type: int)

var repair_type: int

func _enter_tree() -> void:
	add_to_group("RepairArea")
	set_collision_layer_value(8, true)
	set_collision_mask_value(8, true)
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	set_deferred("input_pickable", false)
	
func toggle_monitor(enable: bool = true) -> void:
	set_deferred("monitorable", enable)
	set_deferred("monitoring", enable)
