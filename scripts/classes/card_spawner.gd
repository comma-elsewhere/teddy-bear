class_name CardSpawner

const CARD_DISPLAY := preload("uid://df6abq4yipgag")
const CARD_OFFSET := Vector2(0, 89)
const CARD_SCALE := 0.3

func initiate(patient_file: PatientFile, arm: RigidBody2D) -> void:
	var display: SubViewport = CARD_DISPLAY.instantiate() as SubViewport
	var card := Sprite2D.new()
	arm.add_child(display)
	arm.add_child(card)
	display.setup(patient_file)
	card.position = CARD_OFFSET
	await RenderingServer.frame_post_draw
	card.texture = display.get_texture()
	card.scale = Vector2(CARD_SCALE, CARD_SCALE)
