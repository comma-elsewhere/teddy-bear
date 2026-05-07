class_name TextureLoader

enum PART {TORSO, LEFT_ARM, LEFT_LEG, RIGHT_ARM, RIGHT_LEG, HEAD}

func initiate(res: ToyDetails, body_parts: Array[RigidBody2D]) -> void:
	for i in len(body_parts):
		if i == 0: # Torso (open and closed)
			for j in range(2):
				var sprite := Sprite2D.new()
				sprite.texture = res.textures[j]
				sprite.offset = res.texture_offsets[j]
				body_parts[i].add_child(sprite)
		else: # Head and limbs
			var sprite := Sprite2D.new()
			sprite.texture = res.textures[i + 1]
			sprite.offset = res.texture_offsets[i + 1]
			body_parts[i].add_child(sprite)
