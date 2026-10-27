class_name RepairTool
extends Area2D

const NORMAL_COLOR := Color(1.0, 1.0, 1.0, 1.0)
const HIGHLIGHT := Color(1.825, 1.825, 1.825, 1.0)

@export var texture: Texture2D = null
@export_enum("STITCH", "REMOVE", "WASH", "CUT", "ITEM") var type: int = 0

var _lerp: bool = false
var _origin := Vector2.ZERO

func _ready() -> void:
	mouse_entered.connect(_highlight_texture.bind(true))
	mouse_exited.connect(_highlight_texture.bind(false))
	area_entered.connect(_attempt_repair)
	input_event.connect(_mouse_event)
	_generate_collision_from_sprite()
	_origin = global_transform.origin
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("click"):
		_lerp = false
	if !_lerp:
		global_position = global_position.lerp(_origin, 10 * delta)
		return
	global_position = global_position.lerp(get_global_mouse_position(), 30 * delta)
	
func _mouse_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		_lerp = true
		
func _highlight_texture(highlight: bool) -> void:
	if highlight:
		modulate = HIGHLIGHT
	else:
		modulate = NORMAL_COLOR
	
func _attempt_repair(area: Area2D) -> void:
	if area.is_in_group("RepairArea"):
		area.emit_signal("repair_attempted", area, type)
	
	
func _generate_collision_from_sprite() -> void:
	var sprite := Sprite2D.new()
	sprite.texture = texture
	add_child(sprite)
	
	var collision := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = float(texture.get_width()) / 3
	collision.shape = shape
	add_child(collision)
