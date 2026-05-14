class_name LaundryElement extends Area2D

const CLEAN_COLOR := Color("ffffff")
const FLING := Vector2(50, -300)

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	body_entered.connect(_detect_toy_dirty)
	
func disable_collider(disable: bool) -> void:
	collision_shape_2d.set_deferred("disabled", disable)
	print(collision_shape_2d.disabled)
	
func _detect_toy_dirty(body: Node2D) -> void:
	if body.is_in_group("ToyBody"):
		var toy: ToyBody = body.get_parent() as ToyBody
		if !toy.toy_res.dirty or !toy.visible:
			return
		_wash_toy(toy)
		
func _wash_toy(toy: ToyBody) -> void:
	toy.hide()
	toy.is_held = null
	toy.hooked = false
	for body in toy.bodies:
		body.set_deferred("freeze", true)
	toy.modulate = CLEAN_COLOR
	toy.toy_res.dirty = false
	await get_tree().create_timer(3.0).timeout
	
	for body in toy.bodies:
		body.freeze = false
		body.apply_central_impulse(FLING)
	toy.show()
