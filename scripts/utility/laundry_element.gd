class_name LaundryElement extends InteractionArea

const RADIUS := 150.0
const CLEAN_COLOR := Color("ffffff")
const FLING := Vector2(150, -300)
const WASH_TIME := 2.5

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# connect body entered to func
func _ready() -> void:
	super()
	body_entered.connect(_detect_toy_dirty)
	create_collision(RADIUS)
	
# Checks if toy is able to be washed --- needs to be dirty and currently visible
func _detect_toy_dirty(body: Node2D) -> void:
	if body.is_in_group("ToyBody"):
		var toy: ToyBody = body.get_parent() as ToyBody
		if !toy.toy_res.dirty or !toy.visible:
			return
		_wash_toy(toy)
		
# Hide toy, drop from mouse and hook, freeze bodies, set to clean
# finish WASH_TIME timer and fling in FLING direction
# set back to visible only if player AND toy are still in bench scene
func _wash_toy(toy: ToyBody) -> void:
	toy.hide()
	toy.is_held = null
	toy.hooked = false
	for body in toy.bodies:
		body.set_deferred("freeze", true)
	toy.modulate = CLEAN_COLOR
	toy.toy_res.dirty = false
	await get_tree().create_timer(WASH_TIME).timeout
	
	for body in toy.bodies:
		body.freeze = false
		body.apply_central_impulse(FLING)
		
	# Only set toy back to visible if player is in Bench state
	if %BenchLayer.visible:
		toy.show()
