class_name ItemDrop extends DropArea

var item_res: ItemRes

func _ready() -> void:
	add_to_group(item_res.get_group())
	position = item_res.get_position()
	create_collision(RADIUS)
	start()

func set_item_res(new_res: ItemRes) -> void:
	item_res = new_res
