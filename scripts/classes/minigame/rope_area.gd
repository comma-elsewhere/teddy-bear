class_name RopeArea extends Area2D

signal rope_connected

const LINE_WIDTH := 15.0
const LERP_WEIGHT := 25.0
const HOLE_AREA := 20.0
const LERP_AREA := 20.0

var rope_lerp_point := Area2D.new()
var rope := Rope.new()
var rope_interaction := RopeInteraction.new()

func _ready() -> void:
	rope.color = Color("da0037")
	rope.line_width = LINE_WIDTH
	var collision := CollisionShape2D.new()
	collision.shape = CircleShape2D.new()
	collision.shape.radius = HOLE_AREA
	add_child(collision)
	area_entered.connect(_rope_area_entered)
	visibility_changed.connect(_enable_lerp)
	
func _physics_process(delta: float) -> void:
	if rope_interaction.enable == false or visible == false:
		return
	rope_lerp_point.global_position = rope_lerp_point.global_position.lerp(get_global_mouse_position(), LERP_WEIGHT * delta)
	
#func _mouse_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if event.pressed and visible:
			#rope_interaction.enable = true
			#rope_lerp_point.monitorable = rope_interaction.enable
			#
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if !event.pressed:
			#rope_interaction.enable = false
			#rope_lerp_point.monitorable = rope_interaction.enable
	
func _rope_area_entered(area: Area2D) -> void:
	if area.is_in_group("RopeEnd") and area.get_parent().get_parent() != self:
		area.get_parent().get_parent().set_handle(global_position)
		show()

func _enable_lerp() -> void:
	rope_interaction.enable = visible
	rope_lerp_point.set_deferred("monitorable", visible)
	for area in get_overlapping_areas():
		_rope_area_entered(area)
	
func set_rope(length: float) -> void:
	var curve := Curve.new()
	var collision := CollisionShape2D.new()
	var rope_anchor := RopeAnchor.new()
	rope_lerp_point.monitorable = true
	curve.add_point(Vector2.ZERO)
	curve.add_point(Vector2.ONE, 2.5)
	rope.segment_length_distribution = curve
	rope.num_segments = 20
	rope.rope_length = length
	rope.damping = LERP_WEIGHT * 1.5
	rope.stiffness = LERP_WEIGHT / 1.5
	collision.shape = CircleShape2D.new()
	collision.shape.radius = LERP_AREA
	rope_anchor.rope_position = 1.0
	add_child(rope)
	add_child(rope_anchor)
	rope_anchor.add_child(rope_lerp_point)
	rope_lerp_point.add_child(collision)
	rope_lerp_point.add_to_group("RopeEnd")
	rope_interaction.target_node = rope_lerp_point
	rope.add_child(rope_interaction)
	rope_interaction.rope = rope
	rope_interaction.enable = true
	@warning_ignore("int_as_enum_without_cast")
	rope_interaction.position_update_mode = 0
	rope_anchor.rope_path = rope.get_path()
	
func get_rope() -> Rope:
	return rope

func set_handle(handle_pos: Vector2) -> void:
	if rope_interaction.enable == false:
		return
	rope_interaction.enable = false
	var rope_handle := RopeHandle.new()
	add_child(rope_handle)
	rope_handle.set_strength(1.0)
	rope_handle.rope_position = 1.0
	rope_handle.global_position = handle_pos
	rope_handle.rope_path = rope_handle.get_path_to(rope)
	rope_connected.emit()

func set_collisions(layer: int, mask: int) -> void:
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_layer_value(layer, true)
	set_collision_mask_value(mask, true)
	
	rope_lerp_point.set_collision_layer_value(1, false)
	rope_lerp_point.set_collision_mask_value(1, false)
	rope_lerp_point.set_collision_layer_value(layer, true)
	rope_lerp_point.set_collision_mask_value(mask, true)
	
