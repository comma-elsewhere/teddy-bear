class_name Laundry extends MarginContainer

@onready var laundry_machine_area: LaundryElement = $LaundryMachineArea

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	laundry_machine_area.disable_collider(true)
	
func _on_visibility_changed() -> void:
	if visible:
		laundry_machine_area.disable_collider(false)
	else:
		laundry_machine_area.disable_collider(true)
