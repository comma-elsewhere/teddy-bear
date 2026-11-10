class_name DamageRepair
extends RepairArea

var repair_details: Dictionary = {
	"repair_name": "Damaged",
	"state_id": 0,
	"resolved": false,
	"tool_type": [0]
}

func _ready() -> void:
	add_collision()
	
func attempt_repair(tool_type: int) -> void:
	if repair_details["resolved"] == true:
		return
	if repair_details["tool_type"].has(tool_type):
		emit_signal("repair_attempted", self, tool_type)
