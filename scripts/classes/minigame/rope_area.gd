class_name RopeArea extends Area2D

var rope := Rope.new()

func _ready() -> void:
	rope.color = Color("da0037")
	rope.line_width = 15.0
	var collision := CollisionShape2D.new()
	collision.shape = CircleShape2D.new()
	collision.shape.radius = 50.0
	add_child(collision)
	input_pickable = true

func set_rope(length: float) -> void:
	rope.rope_length = length
	add_child(rope)
	var area := Area2D.new()
	var collision := CollisionShape2D.new()
	collision.shape = CircleShape2D.new()
	collision.shape.radius = 20.0
	area.add_to_group("RopeEnd")
	var rope_anchor := RopeAnchor.new()
	rope_anchor.rope_path = rope.get_path()
	rope_anchor.rope_position = 1.0
	add_child(rope_anchor)
	rope_anchor.add_child(area)
	area.add_child(collision)
	
func get_rope() -> Rope:
	return rope

func set_handle(new_rope: Rope) -> void:
	var rope_handle := RopeHandle.new()
	add_child(rope_handle)
	rope_handle.set_strength(1.0)
	rope_handle.rope_position = 1.0
	rope_handle.rope_path = rope_handle.get_path_to(new_rope)
