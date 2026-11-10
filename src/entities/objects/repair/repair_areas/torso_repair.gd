class_name TorsoRepair
extends RepairArea

var repair_details: Dictionary = {
	"repair_name": "TorsoOpen",
	"state_id": 3,
	"open": false,
	"tool_type": [0,3]
}

func attempt_repair(tool_type: int) -> void:
	if repair_details["tool_type"].has(repair_details["tool_type"].front()) and repair_details["open"] == true:
		emit_signal("repair_attempted", self, tool_type)
		return
	if repair_details["tool_type"].has(repair_details["tool_type"].back()) and repair_details["open"] == false:
		emit_signal("repair_attempted", self, tool_type)
		return

func open_chest(set_to_open: bool) -> void:
	repair_details["open"] = set_to_open
	
