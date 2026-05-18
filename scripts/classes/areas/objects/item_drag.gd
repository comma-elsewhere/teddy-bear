class_name ItemDrag extends DragArea

var item_res: ItemRes = null

func _ready() -> void:
	var sprite := Sprite2D.new()
	sprite.texture = item_res.texture
	sprite.apply_scale(item_res.scale)
	add_child(sprite)
	body_entered.connect(_detect_body)
	body_exited.connect(_forget_body)
	create_collision(float(sprite.texture.get_width())/2)
	start()

func set_item_res(new_res: ItemRes) -> void:
	item_res = new_res

func _detect_body(body: Node2D) -> void:
	if body.is_in_group(item_res.drop_group):
		drop_body = body as RigidBody2D
		_color_body(true)
	else:
		_color_body(false)
		drop_body = null

func _forget_body(body: Node2D) -> void:
	if body.is_in_group(item_res.drop_group):
		_color_body(false)
		drop_body = null
