class_name CardSpawner

#const SUBVIEWPORT_MAT = preload("uid://d0j2mfassxm8y")
const CARD_DISPLAY := preload("uid://df6abq4yipgag")
const CARD_OFFSET := Vector2(0, 89)

func initiate(patient_file: PatientFile, arm: RigidBody2D) -> void:
	var display: SubViewport = CARD_DISPLAY.instantiate() as SubViewport
	#var texture: ViewportTexture
	#var placeholder := PlaceholderTexture2D.new()
	var card := Sprite2D.new()
	arm.add_child(display)
	arm.add_child(card)
	display.setup(patient_file)
	#placeholder.size = CARD_SIZE
	#card.texture = placeholder
	card.position = CARD_OFFSET
	#card.material = SUBVIEWPORT_MAT
	#card.material.resource_local_to_scene = true
	#texture = display.get_texture()
	#texture.resource_local_to_scene = true
	#card.material.set_shader_parameter("viewport_texture", texture)
	
	await RenderingServer.frame_post_draw
	card.texture = display.get_texture()
	card.scale = Vector2(0.3, 0.3)
