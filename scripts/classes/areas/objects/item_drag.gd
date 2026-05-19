class_name ItemDrag extends DragArea

@export var item_res: ItemRes

var sprite: Sprite2D

func _ready() -> void:
	reset_point = global_position
	sprite = Sprite2D.new()
	sprite.texture = item_res.texture
	sprite.apply_scale(item_res.scale)
	add_child(sprite)
	sprite.z_index = 8
	area_entered.connect(_detect_body)
	area_exited.connect(_forget_body)
	drop_complete.connect(_set_reparent)
	create_collision(float(sprite.texture.get_width())/2)
	input_pickable = true
	start()

func set_item_res(new_res: ItemRes) -> void:
	item_res = new_res

func _detect_body(body: Node2D) -> void:
	if body.is_in_group(item_res.get_group()):
		drop_body = body
		_color_body(true)
	else:
		_color_body(false)
		drop_body = null

func _forget_body(body: Node2D) -> void:
	if body.is_in_group(item_res.get_group()):
		_color_body(false)
		drop_body = null

func _set_reparent() -> void:
	await RenderingServer.frame_post_draw
	if drop_body == null:
		return
	_color_body(false)
	reparent(drop_body)
	drop_body = null
	
