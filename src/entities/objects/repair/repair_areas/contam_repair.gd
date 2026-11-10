class_name ContamRepair
extends RepairArea

var repair_details: Dictionary = {
	"repair_name": "Contaminant",
	"state_id": 2,
	"resolved": false,
	"item_data": null,
	"tool_type": [1]
}

func _ready() -> void:
	add_collision()

func attempt_repair(tool_type: int) -> void:
	if repair_details["resolved"] == true:
		return
	if repair_details["tool_type"].has(tool_type):
		emit_signal("repair_attempted", self, tool_type)
