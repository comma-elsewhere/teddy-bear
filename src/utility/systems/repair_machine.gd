class_name RepairMachine
extends Node

enum ToyState { DAMAGED, DIRTY, CONTAMINANT, MISSING_ITEM, TORSO_OPEN }
enum RepairType { STITCH, REMOVE, WASH, CUT, ITEM }

var _needs_repair: Array = []
var _current_toy: Toy = null

func _ready() -> void:
	%Systems/ToySpawn.new_toy_spawned.connect(_set_new_areas)
	
func _set_new_areas(toy: Toy) -> void:
	if toy.toy_data.contaminant != null:
		toy.add_repair_area(_spawn_repair_area(ToyState.CONTAMINANT, toy.toy_data.contaminant))
		_needs_repair.append("Contaminant")
	if toy.toy_data.missing_item != null:
		toy.add_repair_area(_spawn_repair_area(ToyState.MISSING_ITEM, toy.toy_data.missing_item))
		_needs_repair.append("MissingItem")
	if toy.toy_data.damaged > 0:
		for i in range(toy.toy_data.damaged):
			toy.add_repair_area(_spawn_repair_area(ToyState.DAMAGED))
			_needs_repair.append("Damaged")
	if toy.toy_data.dirty == true:
		var area = _spawn_repair_area(ToyState.DIRTY)
		toy.get_torso().add_child(area)
		area.toggle_monitor(false)
		toy.hide_on_shut.append(area)
		area.hide()
		toy.modulate = Color(0.657, 0.579, 0.497, 1.0)
		_needs_repair.append("Dirty")
		
	for area in get_tree().get_nodes_in_group("RepairArea"):
		area.repair_attempted.connect(_state_flow)
		
	_current_toy = toy

func _state_flow(area: RepairArea, repair: int) -> void:
	match repair:
		RepairType.STITCH:
				if area.has_method("open_chest"):
					area.open_chest(false)
					_current_toy.set_torso_displayed(false)
				else:
					print("STITCH")
		RepairType.REMOVE:
				print("REMOVE")
		RepairType.WASH:
				_current_toy.modulate = Color(1.0, 1.0, 1.0, 1.0)
		RepairType.CUT:
				if area.has_method("open_chest"):
					area.open_chest(true)
					_current_toy.set_torso_displayed(true)
		RepairType.ITEM:
				print("ITEM")

func _spawn_repair_area(area_type: ToyState, item_data: ItemData = null) -> RepairArea:
	var new_area
	match area_type:
		ToyState.DAMAGED: 
			new_area = DamageRepair.new()
		ToyState.DIRTY:
			new_area = DirtyRepair.new()
		ToyState.CONTAMINANT:
			new_area = ContamRepair.new()
			new_area.repair_details["item_data"] = item_data
		ToyState.MISSING_ITEM:
			new_area = MissingRepair.new()
			new_area.repair_details["item_data"] = item_data
			
	return new_area
