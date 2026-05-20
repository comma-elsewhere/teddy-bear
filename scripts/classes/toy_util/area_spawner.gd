class_name AreaSpawner

func initiate(toy_res: ToyDetails, bodies: Array[RigidBody2D]) -> void:
	_spawn_toy_cutzone(bodies[toy_res.BODY_PARTS.TORSO])
	
	if !toy_res.interior_contam.is_empty():
		_spawn_internal_removal(toy_res.interior_contam, bodies[toy_res.BODY_PARTS.TORSO])
	
	for damage in toy_res.damage_areas:
		match damage.placement:
			0: _spawn_toy_damage(damage, bodies)
			1: _spawn_toy_damage(damage, [bodies[toy_res.BODY_PARTS.TORSO]])
			2: _spawn_toy_damage(damage, [bodies[toy_res.BODY_PARTS.TORSO]])
			3: _spawn_toy_damage(damage, [bodies[toy_res.BODY_PARTS.HEAD]])
			4: _spawn_toy_damage(damage, [bodies[toy_res.BODY_PARTS.LEFT_ARM], bodies[toy_res.BODY_PARTS.RIGHT_ARM]])
			5: _spawn_toy_damage(damage, [bodies[toy_res.BODY_PARTS.LEFT_ARM], bodies[toy_res.BODY_PARTS.RIGHT_ARM]])
			6: _spawn_toy_damage(damage, [bodies[toy_res.BODY_PARTS.LEFT_LEG], bodies[toy_res.BODY_PARTS.RIGHT_LEG]])
			7: _spawn_toy_damage(damage, [bodies[toy_res.BODY_PARTS.LEFT_LEG], bodies[toy_res.BODY_PARTS.RIGHT_LEG]])
		
	for contam in toy_res.exterior_contam:
		match contam.placement:
			0: _spawn_external_removal(contam, bodies)
			1: _spawn_external_removal(contam, [bodies[toy_res.BODY_PARTS.TORSO]])
			2: _spawn_external_removal(contam, [bodies[toy_res.BODY_PARTS.TORSO]])
			3: _spawn_external_removal(contam, [bodies[toy_res.BODY_PARTS.HEAD]])
			4: _spawn_external_removal(contam, [bodies[toy_res.BODY_PARTS.LEFT_ARM], bodies[toy_res.BODY_PARTS.RIGHT_ARM]])
			5: _spawn_external_removal(contam, [bodies[toy_res.BODY_PARTS.LEFT_ARM], bodies[toy_res.BODY_PARTS.RIGHT_ARM]])
			6: _spawn_external_removal(contam, [bodies[toy_res.BODY_PARTS.LEFT_LEG], bodies[toy_res.BODY_PARTS.RIGHT_LEG]])
			7: _spawn_external_removal(contam, [bodies[toy_res.BODY_PARTS.LEFT_LEG], bodies[toy_res.BODY_PARTS.RIGHT_LEG]])
	
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
			
func open_chest(torso: RigidBody2D) -> void:
	_spawn_toy_damage(DamageRes.new(), [torso])
	
func _spawn_item_drop(item_res: AddonRes, body_parts: Array[RigidBody2D]) -> void:
	var item_drop := ItemDrop.new()
	item_drop.set_item_res(item_res)
	body_parts.pick_random().add_child(item_drop)

func _spawn_toy_cutzone(torso: RigidBody2D) -> void:
	var cutzone := PopupArea.new()
	cutzone.initiate_cutting_popup()
	torso.add_child(cutzone)
	
func _spawn_toy_damage(damage_res: DamageRes, body_parts: Array[RigidBody2D]) -> void:
	var damage_popup := PopupArea.new()
	damage_popup.initiate_stitching_popup(damage_res)
	body_parts.pick_random().add_child(damage_popup)

func _spawn_external_removal(item_res: AddonRes, body_parts: Array[RigidBody2D]) -> void:
	var external_popup := PopupArea.new()
	external_popup.initiate_removal_exterior(item_res)
	body_parts.pick_random().add_child(external_popup)
	external_popup.position = item_res.get_position()

func _spawn_internal_removal(item_array: Array[AddonRes], torso: RigidBody2D) -> void:
	var internal_popup := PopupArea.new()
	internal_popup.initiate_removal_interior(item_array)
	torso.add_child(internal_popup)
	
