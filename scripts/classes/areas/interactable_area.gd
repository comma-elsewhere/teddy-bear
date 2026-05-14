class_name InteractionArea extends Area2D

var collision_shape := CollisionShape2D.new()

func start() -> void:
	visibility_changed.connect(_enable_on_visible)
	await RenderingServer.frame_post_draw
	call_deferred("_enable_on_visible")

func create_collision(radius: float) -> void:
	var shape := CircleShape2D.new()
	shape.radius = radius
	collision_shape.shape = shape
	add_child(collision_shape)
	
func toggle_collision(disable: bool) -> void:
	collision_shape.set_deferred("disabled", disable)

func _enable_on_visible() -> void:
	if get_parent().visible:
		toggle_collision(false)
	else:
		toggle_collision(true)
