class_name ShippingArea extends InteractionArea

signal ship_toy

func _ready() -> void:
	create_collision(200)
	body_entered.connect(_emit_ship)
	toggle_collision(true)
	
func _emit_ship(body: Node2D) -> void:
	if get_parent().visible and body.get_parent().is_in_group("Toy") and body.get_parent().visible:
		ship_toy.emit()
