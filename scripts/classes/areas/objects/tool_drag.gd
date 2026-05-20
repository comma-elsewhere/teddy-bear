class_name ToolDrag extends DragArea

@export_enum("Remove", "Cut", "Stitch") var tool_target: int = 0
@export var texture: Texture2D

const GROUP: Array[String] = ["RemovePopup", "CutPopup", "StitchPopup"]

const STICK := 0.4
const UNSTICK := 0.8

var tool_group: String

func _ready() -> void:
	var sprite := Sprite2D.new()
	sprite.texture = texture
	add_child(sprite)
	create_collision(float(sprite.texture.get_width())/2)
	reset_point = global_position
	_set_tool_group()
	area_entered.connect(_check_area)
	area_exited.connect(_forget_area)
	set_visibility_layer_bit(3, true)
	z_index = 10
	start()
	
func _check_area(area: Area2D) -> void:
	if area.is_in_group(tool_group):
		drop_body = area
		_color_body(true)
	
func _forget_area(area: Area2D) -> void:
	if area == drop_body:
		_color_body(false)
		drop_body = null
	
func _set_tool_group() -> void:
	tool_group = GROUP[tool_target]

func _attempt_drop() -> void:
	super()
	if is_dropped == true:
		_popup_and_reset()
	
func _popup_and_reset() -> void:
	_color_body(false)
	await get_tree().create_timer(STICK).timeout
	drop_body.create_popup()
	await get_tree().create_timer(UNSTICK).timeout
	is_dragging = false
	is_dropped = false
	drop_body = null
