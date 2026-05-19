class_name AreaSpawner

func initiate(toy_res: ToyDetails, bodies: Array[RigidBody2D]) -> void:
	for item in toy_res.missing_item:
		match item.placement:
			0: _spawn_item_drop(item, bodies)
			1: _spawn_item_drop(item, [bodies[toy_res.BODY_PARTS.TORSO]])
			2: _spawn_item_drop(item, [bodies[toy_res.BODY_PARTS.TORSO]])
			3: _spawn_item_drop(item, [bodies[toy_res.BODY_PARTS.HEAD]])
			4: _spawn_item_drop(item, [bodies[toy_res.BODY_PARTS.LEFT_ARM], bodies[toy_res.BODY_PARTS.RIGHT_ARM]])
			5: _spawn_item_drop(item, [bodies[toy_res.BODY_PARTS.LEFT_ARM], bodies[toy_res.BODY_PARTS.RIGHT_ARM]])
			6: _spawn_item_drop(item, [bodies[toy_res.BODY_PARTS.LEFT_LEG], bodies[toy_res.BODY_PARTS.RIGHT_LEG]])
			7: _spawn_item_drop(item, [bodies[toy_res.BODY_PARTS.LEFT_LEG], bodies[toy_res.BODY_PARTS.RIGHT_LEG]])
			
func _spawn_item_drop(item_res: ItemRes, body_parts: Array[RigidBody2D]) -> void:
	var item_drop := ItemDrop.new()
	item_drop.set_item_res(item_res)
	body_parts.pick_random().add_child(item_drop)
