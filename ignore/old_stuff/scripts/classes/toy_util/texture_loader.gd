class_name TextureLoader

enum PART {TORSO, LEFT_ARM, LEFT_LEG, RIGHT_ARM, RIGHT_LEG, HEAD}

func initiate(res: ToyDetails, body_parts: Array[RigidBody2D]) -> void:
	for i in len(body_parts):
		if i == 0: # Torso (closed)
			var sprite := Sprite2D.new()
			sprite.texture = res.textures[i]
			sprite.offset = res.texture_offsets[i]
			body_parts[i].add_child(sprite)
		else: # Head and limbs
			var sprite := Sprite2D.new()
			sprite.texture = res.textures[i + 1]
			sprite.offset = res.texture_offsets[i + 1]
			body_parts[i].add_child(sprite)

func open_chest(res: ToyDetails, torso: RigidBody2D) -> void:
	var sprite := Sprite2D.new()
	sprite.texture = res.textures[1]
	sprite.offset = res.texture_offsets[1]
	torso.add_child(sprite)
	sprite.add_to_group("OpenChest")
