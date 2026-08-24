extends InteractionArea

signal activate()

@export var texture: Texture2D
@export var texture_scale: Vector2 = Vector2.ONE

func _ready() -> void:
	create_collision(100)
	input_event.connect(_mouse_event)
	_add_texture()
	show_behind_parent = true
	
func _mouse_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MASK_LEFT:
		if event.pressed and visible:
			activate.emit()
			print("connecting")
			get_parent().remove_child(self)
			call_deferred("queue_free")

func _add_texture() -> void:
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.apply_scale(texture_scale)
	add_child(sprite)
