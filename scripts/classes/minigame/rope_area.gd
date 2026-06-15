class_name RopeArea extends Area2D

const LERP_WEIGHT := 0.001
var rope_lerp_point: Area2D = null
var rope := Rope.new()
var rope_interaction := RopeInteraction.new()

func _ready() -> void:
	rope.color = Color("da0037")
	rope.line_width = 15.0
	var collision := CollisionShape2D.new()
	collision.shape = CircleShape2D.new()
	collision.shape.radius = 50.0
	add_child(collision)
	area_entered.connect(_rope_area_entered)
	
func _mouse_event(_viewport: Node, event: InputEvent, _shape_idx: int, end_point: Area2D) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and visible:
			rope_interaction.enable = true
			end_point.monitorable = true
			rope_lerp_point = end_point
		if !event.pressed:
			rope_interaction.enable = false
			end_point.monitorable = false
			rope_lerp_point = null
			
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if rope_lerp_point != null:
			rope_interaction.on_movement_request.emit()
			rope_lerp_point.global_position = rope_lerp_point.global_position.lerp(get_global_mouse_position(), LERP_WEIGHT)
	
func _rope_area_entered(area: Area2D) -> void:
	if area.is_in_group("RopeEnd") and area.get_parent().get_parent() != self:
		area.get_parent().get_parent().set_handle(global_position)
		show()

func set_rope(length: float) -> void:
	var curve := Curve.new()
	var area := Area2D.new()
	var collision := CollisionShape2D.new()
	var rope_anchor := RopeAnchor.new()
	area.input_pickable = true
	area.input_event.connect(_mouse_event.bind(area))
	area.monitorable = false
	curve.add_point(Vector2.ZERO)
	curve.add_point(Vector2.ONE, 2.5)
	rope.segment_length_distribution = curve
	rope.rope_length = length
	collision.shape = CircleShape2D.new()
	collision.shape.radius = 45.0
	rope_anchor.rope_position = 1.0
	add_child(rope)
	add_child(rope_anchor)
	rope_anchor.add_child(area)
	area.add_child(collision)
	area.add_to_group("RopeEnd")
	rope_interaction.target_node = area
	rope.add_child(rope_interaction)
	rope_interaction.rope = rope
	rope_interaction.enable = true
	rope_anchor.rope_path = rope.get_path()
	
func get_rope() -> Rope:
	return rope

func set_handle(handle_pos: Vector2) -> void:
	var rope_handle := RopeHandle.new()
	add_child(rope_handle)
	rope_handle.set_strength(1.0)
	rope_handle.rope_position = 1.0
	rope_handle.global_position = handle_pos
	rope_handle.rope_path = rope_handle.get_path_to(rope)
