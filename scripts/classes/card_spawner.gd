class_name CardSpawner

const CARD_DISPLAY := preload("uid://df6abq4yipgag")
const CARD_OFFSET := Vector2(0, 95)
const CARD_SCALE := 0.3

const DANGLE_WEIGHT := 55.0

var card: Sprite2D

func initiate(patient_file: PatientFile, arm: RigidBody2D) -> void:
	var display: SubViewport = CARD_DISPLAY.instantiate() as SubViewport
	arm.add_child(display)
	display.setup(patient_file)
	card = Sprite2D.new()
	arm.add_child(card)
	await RenderingServer.frame_post_draw
	card.texture = display.get_texture()
	card.scale = Vector2(CARD_SCALE, CARD_SCALE)
	card.offset = card.texture.get_size() /2
	card.position = CARD_OFFSET
	card.hide()
	
func dangle_card(delta: float) -> void:
	card.global_rotation_degrees = lerp_angle(card.global_rotation_degrees, 90, DANGLE_WEIGHT * delta)
	
func card_visible(show_card: bool) -> void:
	card.visible = show_card
