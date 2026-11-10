class_name DirtyRepair
extends RepairArea

var repair_details: Dictionary = {
	"repair_name": "Dirty",
	"state_id": 1,
	"resolved": false,
	"tool_type": [2]
}
	
func _ready() -> void:
	add_collision()
	
func attempt_repair(tool_type: int) -> void:
	if repair_details["resolved"] == true:
		return
	if repair_details["tool_type"].has(tool_type):
		emit_signal("repair_attempted", self, tool_type)
