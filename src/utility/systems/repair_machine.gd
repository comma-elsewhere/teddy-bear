class_name RepairMachine
extends Node

enum ToyState { DAMAGED, DIRTY, CONTAMINANTS, MISSING_ITEM, TORSO_OPEN }
enum RepairType { STITCH, REMOVE, WASH, CUT, ITEM }

var _needs_repair: Dictionary = {
	ToyState.DAMAGED: false,
	ToyState.DIRTY: false,
	ToyState.CONTAMINANTS: false,
	ToyState.MISSING_ITEM: false,
	ToyState.TORSO_OPEN: false
}

func _ready() -> void:
	for area in get_tree().get_nodes_in_group("RepairArea"):
		area.repair_attempted.connect(_state_flow)

func _state_flow(area: RepairArea, repair: RepairType) -> void:
	if area.repair_type != repair:
		return
	match repair:
		RepairType.STITCH:
			if _needs_repair[ToyState.TORSO_OPEN] and area.get_parent().is_in_group("TorsoBody"):
				# Close torso, set to false
				return
			elif _needs_repair[ToyState.DAMAGED]:
				# remove damage, set to false
				return
		RepairType.REMOVE:
			if _needs_repair[ToyState.CONTAMINANTS]:
				# Remove contam, set to false
				return
		RepairType.WASH:
			if _needs_repair[ToyState.DIRTY]:
				# modulate clean, set to false
				return
		RepairType.CUT:
			if !_needs_repair[ToyState.TORSO_OPEN] and area.get_parent().is_in_group("TorsoBody"):
				# open torso, set to true
				return
		RepairType.ITEM:
			if _needs_repair[ToyState.MISSING_ITEM]:
				# check and place item, set to false
				return
